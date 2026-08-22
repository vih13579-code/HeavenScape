package controller;

import dao.CartDAO;
import dao.OrderDAO;
import dao.AddressDAO;
import dao.BookDAO;
import dao.VoucherDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Account;
import model.CartItem;
import model.Address;
import model.Voucher;

import java.io.IOException;
import java.math.BigDecimal;
import java.math.RoundingMode;
import java.sql.Timestamp;
import java.text.SimpleDateFormat;
import java.util.List;

public class CheckoutController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        if (!isCustomer(request, response)) {
            return;
        }

        Account account = getAccount(request);
        String action = request.getParameter("action");

        if (action != null) {
            switch (action) {
                case "deleteAddress":
                    String addressIdRaw = request.getParameter("addressID");

                    if (addressIdRaw != null && !addressIdRaw.trim().isEmpty()) {
                        try {
                            int addressID = Integer.parseInt(addressIdRaw.trim());
                            AddressDAO addressDAO = new AddressDAO();
                            boolean deleted = addressDAO.deleteAddressByCustomer(
                                    addressID,
                                    account.getId()
                            );

                            if (!deleted) {
                                request.getSession().setAttribute(
                                        "errorMessage",
                                        "Address not found or you do not have permission to delete it."
                                );
                            }
                        } catch (NumberFormatException e) {
                            request.getSession().setAttribute(
                                    "errorMessage",
                                    "Invalid address ID."
                            );
                        }
                    }

                    response.sendRedirect(request.getContextPath() + "/checkout");
                    return;
            }
        }

        CartDAO cartDAO = new CartDAO();
        AddressDAO addressDAO = new AddressDAO();
        List<CartItem> cartItems = cartDAO.getCartItems(account.getId());

        if (cartItems.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/cart");
            return;
        }

        cartItems.removeIf(item -> item.getStockQuantity() == 0);

        if (cartItems.isEmpty()) {
            request.getSession().setAttribute("errorMessage", "All items in your cart are out of stock!");
            response.sendRedirect(request.getContextPath() + "/cart");
            return;
        }

        boolean hasAdjusted = false;
        for (CartItem item : cartItems) {
            if (item.getQuantity() > item.getStockQuantity()) {
                cartDAO.updateQuantity(item.getCartItemID(), account.getId(), item.getStockQuantity());
                item.setQuantity(item.getStockQuantity());
                hasAdjusted = true;
            }
        }

        if (hasAdjusted) {
            request.getSession().setAttribute("warningMessage",
                    "Some item quantities were adjusted to match the remaining stock.");
        }

        BigDecimal total = cartDAO.calcSubtotal(cartItems);

        int totalQuantity = 0;
        for (CartItem item : cartItems) {
            totalQuantity += item.getQuantity();
        }

        List<Address> addressList = addressDAO.getAddressesByCustomerId(account.getId());
        request.setAttribute("cartItems", cartItems);
        request.setAttribute("total", total);
        request.setAttribute("totalQuantity", totalQuantity);
        request.setAttribute("addressList", addressList);

        // Nếu đang có voucher áp dụng trong session, kiểm tra lại còn hợp lệ không
        // (ví dụ giỏ hàng thay đổi khiến không còn đạt giá trị đơn tối thiểu)
        HttpSession session = request.getSession();
        Object voucherIdObj = session.getAttribute(SESSION_VOUCHER_ID);
        if (voucherIdObj != null) {
            String code = (String) session.getAttribute(SESSION_VOUCHER_CODE);
            VoucherDAO voucherDAO = new VoucherDAO();
            VoucherController.VoucherValidationResult recheck = validateVoucher(code, account.getId(), total, voucherDAO);

            if (recheck.success) {
                session.setAttribute(SESSION_VOUCHER_DISCOUNT, recheck.discountAmount);
                request.setAttribute("appliedVoucherCode", recheck.voucher.getCode());
                request.setAttribute("appliedDiscount", recheck.discountAmount);
            } else {
                session.removeAttribute(SESSION_VOUCHER_ID);
                session.removeAttribute(SESSION_VOUCHER_CODE);
                session.removeAttribute(SESSION_VOUCHER_DISCOUNT);
                // Báo cho khách biết lý do voucher bị gỡ, thay vì âm thầm biến mất
                request.setAttribute("errorMessage",
                        "Voucher \"" + code + "\" can no longer be applied: " + recheck.message);
            }
        }

        request.getRequestDispatcher("/views/cart/checkout.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        if (!isCustomer(request, response)) {
            return;
        }

        Account account = getAccount(request);
        String action = request.getParameter("action");

        if ("deleteAddressAjax".equals(action)) {
            deleteAddressAjax(request, response, account);
            return;
        }

        if ("saveAddress".equals(action)) {
            saveAddressAjax(request, response, account);
            return;
        }

        if ("applyVoucher".equals(action)) {
            handleApplyVoucher(request, response, account);
            return;
        }

        if ("removeVoucher".equals(action)) {
            handleRemoveVoucher(request, response);
            return;
        }

        if ("listVouchers".equals(action)) {
            handleListVouchers(request, response);
            return;
        }

        String paymentMethod = request.getParameter("payment_method");

        if (paymentMethod == null || paymentMethod.trim().isEmpty()) {
            request.getSession().setAttribute("errorMessage", "Please select a payment method!");
            response.sendRedirect(request.getContextPath() + "/checkout");
            return;
        }

        if ("vnpay".equals(paymentMethod)) {
            request.getRequestDispatcher("/vnpay-payment").forward(request, response);
            return;
        }

        if (!"cod".equals(paymentMethod)) {
            request.getSession().setAttribute("errorMessage", "This payment method is not supported!");
            response.sendRedirect(request.getContextPath() + "/checkout");
            return;
        }

        CartDAO cartDAO = new CartDAO();
        OrderDAO orderDAO = new OrderDAO();

        List<CartItem> cartItems = cartDAO.getCartItems(account.getId());

        if (cartItems.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/cart");
            return;
        }

        cartItems.removeIf(item -> item.getStockQuantity() == 0);

        if (cartItems.isEmpty()) {
            request.getSession().setAttribute("errorMessage", "All items in your cart are out of stock!");
            response.sendRedirect(request.getContextPath() + "/cart");
            return;
        }

        BigDecimal total = cartDAO.calcSubtotal(cartItems);

        BookDAO bookDAO = new BookDAO();
        for (CartItem item : cartItems) {
            String stockError = bookDAO.validatePurchaseQuantity(item.getBookID(), item.getQuantity());
            if (stockError != null) {
                request.getSession().setAttribute("errorMessage",
                        item.getTitle() + ": " + stockError);
                response.sendRedirect(request.getContextPath() + "/cart");
                return;
            }
        }

        // --- Áp lại voucher (nếu có) và xác thực lần cuối trước khi trừ tiền ---
        HttpSession session = request.getSession();
        Integer appliedVoucherID = (Integer) session.getAttribute(SESSION_VOUCHER_ID);
        BigDecimal finalTotal = total;

        if (appliedVoucherID != null) {
            VoucherDAO voucherDAO = new VoucherDAO();
            String appliedCode = (String) session.getAttribute(SESSION_VOUCHER_CODE);
            VoucherController.VoucherValidationResult recheck = validateVoucher(appliedCode, account.getId(), total, voucherDAO);

            if (recheck.success) {
                finalTotal = total.subtract(BigDecimal.valueOf(recheck.discountAmount));
                if (finalTotal.compareTo(BigDecimal.ZERO) < 0) {
                    finalTotal = BigDecimal.ZERO;
                }
            } else {
                // Voucher không còn hợp lệ tại thời điểm đặt hàng (hết lượt, hết hạn...)
                appliedVoucherID = null;
                session.removeAttribute(SESSION_VOUCHER_ID);
                session.removeAttribute(SESSION_VOUCHER_CODE);
                session.removeAttribute(SESSION_VOUCHER_DISCOUNT);
                request.getSession().setAttribute("errorMessage",
                        "The voucher is no longer valid and was removed from the order. Please review your total.");
            }
        }

        String addressIDRaw = request.getParameter("addressID");

        if (isEmpty(addressIDRaw)) {
            request.getSession().setAttribute("errorMessage", "Please select a shipping address!");
            response.sendRedirect(request.getContextPath() + "/checkout");
            return;
        }

        int addressID;
        try {
            addressID = Integer.parseInt(addressIDRaw.trim());
        } catch (NumberFormatException e) {
            request.getSession().setAttribute("errorMessage", "Invalid shipping address!");
            response.sendRedirect(request.getContextPath() + "/checkout");
            return;
        }

        // Kiểm tra bảo mật: địa chỉ phải thuộc sở hữu của khách hàng đang đăng nhập
        AddressDAO addressDAO = new AddressDAO();
        List<Address> addresses = addressDAO.getAddressesByCustomerId(account.getId());
        boolean isOwnedByCustomer = false;
        for (Address addr : addresses) {
            if (addr.getAddressID() == addressID) {
                isOwnedByCustomer = true;
                break;
            }
        }

        if (!isOwnedByCustomer) {
            request.getSession().setAttribute("errorMessage", "Invalid shipping address!");
            response.sendRedirect(request.getContextPath() + "/checkout");
            return;
        }

        int orderID = orderDAO.createOrderWithStockCheck(
                account.getId(), addressID, paymentMethod, finalTotal, cartItems, appliedVoucherID);

        if (orderID == -2) {
            request.getSession().setAttribute("errorMessage", "An item in your cart went out of stock because another customer purchased it first. Please review your cart!");
            response.sendRedirect(request.getContextPath() + "/cart");
            return;
        } else if (orderID == -3) {
            request.getSession().setAttribute("errorMessage", "The selected shipping address no longer exists or is invalid. Please choose another address.");
            response.sendRedirect(request.getContextPath() + "/checkout");
            return;
        } else if (orderID == -4) {
            session.removeAttribute(SESSION_VOUCHER_ID);
            session.removeAttribute(SESSION_VOUCHER_CODE);
            session.removeAttribute(SESSION_VOUCHER_DISCOUNT);
            request.getSession().setAttribute("errorMessage", "The selected voucher is no longer valid. Please review your order and try again.");
            response.sendRedirect(request.getContextPath() + "/checkout");
            return;
        } else if (orderID == -1) {
            request.getSession().setAttribute("errorMessage", "Could not create the order. Please try again!");
            response.sendRedirect(request.getContextPath() + "/checkout");
            return;
        }

        orderDAO.clearCart(account.getId());

        session.removeAttribute(SESSION_VOUCHER_ID);
        session.removeAttribute(SESSION_VOUCHER_CODE);
        session.removeAttribute(SESSION_VOUCHER_DISCOUNT);

        request.getSession().setAttribute("cartCount", 0);
        request.getSession().setAttribute("just_placed_order_id", orderID);

        response.sendRedirect(request.getContextPath() + "/order-confirmation?orderID=" + orderID);
    }

    private void deleteAddressAjax(HttpServletRequest request,
            HttpServletResponse response,
            Account account) throws IOException {

        response.setContentType("application/json;charset=UTF-8");

        String addressIdRaw = request.getParameter("addressID");

        if (addressIdRaw == null || addressIdRaw.trim().isEmpty()) {
            response.getWriter().write(
                    "{\"success\":false,\"message\":\"Missing address ID\"}"
            );
            return;
        }

        try {
            int addressID = Integer.parseInt(addressIdRaw.trim());

            AddressDAO addressDAO = new AddressDAO();
            boolean deleted = addressDAO.deleteAddressByCustomer(
                    addressID,
                    account.getId()
            );

            if (deleted) {
                response.getWriter().write("{\"success\":true}");
            } else {
                response.getWriter().write(
                        "{\"success\":false,\"message\":\"Address not found or you do not have permission to delete it\"}"
                );
            }
        } catch (NumberFormatException e) {
            response.getWriter().write(
                    "{\"success\":false,\"message\":\"Invalid address ID\"}"
            );
        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write(
                    "{\"success\":false,\"message\":\"Server error while deleting the address\"}"
            );
        }
    }

    private static final String SESSION_VOUCHER_ID = "appliedVoucherID";
    private static final String SESSION_VOUCHER_CODE = "appliedVoucherCode";
    private static final String SESSION_VOUCHER_DISCOUNT = "appliedVoucherDiscount";

    private VoucherController.VoucherValidationResult validateVoucher(String code, int customerID, BigDecimal orderTotal,
            VoucherDAO voucherDAO) {
        VoucherController.VoucherValidationResult r = new VoucherController.VoucherValidationResult();

        if (code == null || code.trim().isEmpty()) {
            r.message = "Please enter a voucher code.";
            return r;
        }

        Voucher v = voucherDAO.getVoucherByCode(code);
        if (v == null) {
            r.message = "Voucher code does not exist.";
            return r;
        }

        if (!"active".equals(v.getStatus())) {
            r.message = "This voucher is no longer available.";
            return r;
        }

        Timestamp now = new Timestamp(System.currentTimeMillis());
        if (v.getStartDate() != null && v.getStartDate().after(now)) {
            r.message = "This voucher is not active yet.";
            return r;
        }
        if (v.getEndDate() != null && v.getEndDate().before(now)) {
            r.message = "This voucher has expired.";
            return r;
        }

        if (v.getMinOrderValue() != null && orderTotal.doubleValue() < v.getMinOrderValue()) {
            r.message = "The order has not reached the minimum value of "
                    + String.format("%,.0f", v.getMinOrderValue()) + " VND required to use this voucher.";
            return r;
        }

        if (v.getQuantity() != null) {
            int usedCount = voucherDAO.getUsedCount(v.getVoucherID());
            if (usedCount >= v.getQuantity()) {
                r.message = "This voucher has reached its usage limit.";
                return r;
            }
        }

        if (voucherDAO.hasCustomerUsedVoucher(customerID, v.getVoucherID())) {
            r.message = "You have already used this voucher.";
            return r;
        }

        BigDecimal discount = orderTotal
                .multiply(BigDecimal.valueOf(v.getDiscountPercent()))
                .divide(BigDecimal.valueOf(100), 2, RoundingMode.HALF_UP);

        if (v.getMaxDiscountValue() != null) {
            BigDecimal maxDiscount = BigDecimal.valueOf(v.getMaxDiscountValue());
            if (discount.compareTo(maxDiscount) > 0) {
                discount = maxDiscount;
            }
        }
        if (discount.compareTo(orderTotal) > 0) {
            discount = orderTotal;
        }

        r.success = true;
        r.voucher = v;
        r.discountAmount = discount.doubleValue();
        r.message = "Voucher applied successfully!";
        return r;
    }

    private void handleApplyVoucher(HttpServletRequest request, HttpServletResponse response, Account account)
            throws IOException {

        response.setContentType("application/json;charset=UTF-8");

        String code = request.getParameter("code");

        CartDAO cartDAO = new CartDAO();
        List<CartItem> cartItems = cartDAO.getCartItems(account.getId());
        cartItems.removeIf(item -> item.getStockQuantity() == 0);

        if (cartItems.isEmpty()) {
            response.getWriter().write("{\"success\":false,\"message\":\"The cart is empty or all items are out of stock.\"}");
            return;
        }

        BigDecimal total = cartDAO.calcSubtotal(cartItems);

        VoucherDAO voucherDAO = new VoucherDAO();
        VoucherController.VoucherValidationResult result = validateVoucher(code, account.getId(), total, voucherDAO);

        if (!result.success) {
            response.getWriter().write("{\"success\":false,\"message\":\"" + escapeJson(result.message) + "\"}");
            return;
        }

        HttpSession session = request.getSession();
        session.setAttribute(SESSION_VOUCHER_ID, result.voucher.getVoucherID());
        session.setAttribute(SESSION_VOUCHER_CODE, result.voucher.getCode());
        session.setAttribute(SESSION_VOUCHER_DISCOUNT, result.discountAmount);

        BigDecimal newTotal = total.subtract(BigDecimal.valueOf(result.discountAmount));
        if (newTotal.compareTo(BigDecimal.ZERO) < 0) {
            newTotal = BigDecimal.ZERO;
        }

        String json = "{\"success\":true,\"message\":\"" + escapeJson(result.message) + "\","
                + "\"discountAmount\":" + result.discountAmount + ","
                + "\"newTotal\":" + newTotal.doubleValue() + "}";
        response.getWriter().write(json);
    }

    private void handleRemoveVoucher(HttpServletRequest request, HttpServletResponse response) throws IOException {
        response.setContentType("application/json;charset=UTF-8");

        HttpSession session = request.getSession(false);
        if (session != null) {
            session.removeAttribute(SESSION_VOUCHER_ID);
            session.removeAttribute(SESSION_VOUCHER_CODE);
            session.removeAttribute(SESSION_VOUCHER_DISCOUNT);
        }

        response.getWriter().write("{\"success\":true}");
    }

    private void handleListVouchers(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        response.setContentType("application/json;charset=UTF-8");

        VoucherDAO voucherDAO = new VoucherDAO();
        Account account = getAccount(request);
        List<Voucher> vouchers = voucherDAO.getActiveVouchers(account.getId());
        List<CartItem> cartItems = new CartDAO().getCartItems(account.getId());
        cartItems.removeIf(item -> item.getQuantity() <= 0
                || item.getStockQuantity() <= 0
                || !"available".equalsIgnoreCase(item.getStatus()));
        BigDecimal orderTotal = new CartDAO().calcSubtotal(cartItems);
        SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy");

        StringBuilder json = new StringBuilder("{\"success\":true,\"vouchers\":[");
        for (int i = 0; i < vouchers.size(); i++) {
            Voucher v = vouchers.get(i);
            VoucherController.VoucherValidationResult eligibility = validateVoucher(
                    v.getCode(), account.getId(), orderTotal, voucherDAO);
            if (i > 0) {
                json.append(",");
            }
            json.append("{")
                    .append("\"code\":\"").append(escapeJson(v.getCode())).append("\",")
                    .append("\"discountPercent\":").append(v.getDiscountPercent()).append(",")
                    .append("\"minOrderValue\":")
                    .append(v.getMinOrderValue() == null ? "null" : v.getMinOrderValue()).append(",")
                    .append("\"maxDiscountValue\":")
                    .append(v.getMaxDiscountValue() == null ? "null" : v.getMaxDiscountValue()).append(",")
                    .append("\"endDate\":\"")
                    .append(v.getEndDate() == null ? "No Expiration" : sdf.format(v.getEndDate())).append("\",")
                    .append("\"eligible\":").append(eligibility.success).append(",")
                    .append("\"ineligibleReason\":\"")
                    .append(escapeJson(eligibility.success ? "" : eligibility.message)).append("\"")
                    .append("}");
        }
        json.append("]}");

        response.getWriter().write(json.toString());
    }

    private String escapeJson(String s) {
        if (s == null) {
            return "";
        }
        return s.replace("\\", "\\\\").replace("\"", "\\\"");
    }

    private void saveAddressAjax(HttpServletRequest request, HttpServletResponse response, Account account)
            throws IOException {

        String street = request.getParameter("street");
        String ward = request.getParameter("ward");
        String city = request.getParameter("city");
        String isDefaultRaw = request.getParameter("isDefault");
        String recipientName = request.getParameter("fullname");
        String recipientPhone = request.getParameter("phone");

        response.setContentType("application/json;charset=UTF-8");

        if (isEmpty(street) || isEmpty(ward) || isEmpty(city)) {
            response.getWriter().write("{\"success\":false}");
            return;
        }

        if (!isValidAddressPart(street) || !isValidAddressPart(ward) || !isValidAddressPart(city)) {
            response.getWriter().write("{\"success\":false,\"message\":\"Invalid address\"}");
            return;
        }

        if (!isValidRecipientName(recipientName)) {
            response.getWriter().write("{\"success\":false,\"message\":\"Invalid recipient name\"}");
            return;
        }

        if (!isValidPhone(recipientPhone)) {
            response.getWriter().write("{\"success\":false,\"message\":\"Invalid recipient phone number\"}");
            return;
        }

        Address address = new Address();
        address.setCustomerID(account.getId());
        address.setStreet(street.trim());
        address.setDistrict(ward.trim());
        address.setCity(city.trim());
        address.setCountry("Vietnam");
        address.setDefault("true".equals(isDefaultRaw));

        address.setRecipientName(recipientName.trim());
        address.setRecipientPhone(recipientPhone.trim());

        AddressDAO addressDAO = new AddressDAO();
        int addressID = addressDAO.insertAddressAndReturnId(address);

        if (addressID == -1) {
            response.getWriter().write("{\"success\":false}");
            return;
        }

        response.getWriter().write("{\"success\":true,\"addressID\":" + addressID + "}");
    }

    private boolean isCustomer(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("account") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return false;
        }

        Account account = (Account) session.getAttribute("account");
        if (!"customer".equals(account.getRole())) {
            response.sendRedirect(request.getContextPath() + "/home");
            return false;
        }

        return true;
    }

    private Account getAccount(HttpServletRequest request) {
        return (Account) request.getSession().getAttribute("account");
    }

    private boolean isEmpty(String value) {
        return value == null || value.trim().isEmpty();
    }

    private boolean isValidAddressPart(String value) {
        if (value == null) {
            return false;
        }

        String trimmed = value.trim();

        if (trimmed.length() < 3) {
            return false;
        }

        return trimmed.matches(".*[a-zA-ZÀ-ỹ].*");
    }

    private boolean isValidRecipientName(String value) {
        if (value == null) {
            return false;
        }

        String trimmed = value.trim();
        return trimmed.matches("^[\\p{L}][\\p{L}\\s.'-]{1,49}$");
    }

    private boolean isValidPhone(String value) {
        if (value == null) {
            return false;
        }

        return value.trim().matches("^0\\d{9}$");
    }
}
