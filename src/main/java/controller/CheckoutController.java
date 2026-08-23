package controller;

import dao.CartDAO;
import dao.OrderDAO;
import dao.AddressDAO;
import dao.VoucherDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Account;
import model.CartItem;
import model.Address;
import model.CheckoutIssue;
import model.CheckoutResult;
import model.CheckoutSnapshot;
import model.Voucher;

import java.io.IOException;
import java.math.BigDecimal;
import java.math.RoundingMode;
import java.sql.Timestamp;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
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
        List<CartItem> cartItems = cartDAO.getCartItemsForCheckout(account.getId());

        if (cartItems.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/cart");
            return;
        }

        for (CartItem item : cartItems) {
            if (!"available".equalsIgnoreCase(item.getStatus())) {
                request.getSession().setAttribute("errorMessage",
                        "'" + item.getTitle() + "' is no longer available for sale. Please review your cart.");
                response.sendRedirect(request.getContextPath() + "/cart");
                return;
            }
            if (item.getQuantity() < 1 || item.getStockQuantity() < item.getQuantity()) {
                request.getSession().setAttribute("errorMessage",
                        "'" + item.getTitle() + "' only has " + item.getStockQuantity()
                                + " item(s) left, which is not enough for your requested quantity ("
                                + item.getQuantity() + "). Please update your cart.");
                response.sendRedirect(request.getContextPath() + "/cart");
                return;
            }
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
        Voucher appliedVoucher = null;
        BigDecimal appliedDiscount = BigDecimal.ZERO;
        Object voucherIdObj = session.getAttribute(SESSION_VOUCHER_ID);
        if (voucherIdObj != null) {
            String code = (String) session.getAttribute(SESSION_VOUCHER_CODE);
            VoucherDAO voucherDAO = new VoucherDAO();
            VoucherController.VoucherValidationResult recheck = validateVoucher(code, account.getId(), total, voucherDAO);

            if (recheck.success) {
                session.setAttribute(SESSION_VOUCHER_DISCOUNT, recheck.discountAmount);
                request.setAttribute("appliedVoucherCode", recheck.voucher.getCode());
                request.setAttribute("appliedDiscount", recheck.discountAmount);
                appliedVoucher = recheck.voucher;
                appliedDiscount = BigDecimal.valueOf(recheck.discountAmount);
            } else {
                session.removeAttribute(SESSION_VOUCHER_ID);
                session.removeAttribute(SESSION_VOUCHER_CODE);
                session.removeAttribute(SESSION_VOUCHER_DISCOUNT);
                // Báo cho khách biết lý do voucher bị gỡ, thay vì âm thầm biến mất
                request.setAttribute("errorMessage",
                        "Voucher \"" + code + "\" can no longer be applied: " + recheck.message);
            }
        }

        session.setAttribute(SESSION_CHECKOUT_SNAPSHOT,
                createSnapshot(cartItems, appliedVoucher, total, appliedDiscount));

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

        HttpSession session = request.getSession();
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

        CheckoutSnapshot expected = (CheckoutSnapshot) session.getAttribute(SESSION_CHECKOUT_SNAPSHOT);
        if (expected == null) {
            session.setAttribute("warningMessage",
                    "Your checkout information has expired. Please review your order before continuing.");
            response.sendRedirect(request.getContextPath() + "/checkout");
            return;
        }

        OrderDAO orderDAO = new OrderDAO();
        CheckoutResult result = orderDAO.createCodOrderWithRevalidation(
                account.getId(), addressID, expected);

        if (result.getStatus() == CheckoutResult.Status.REVIEW_REQUIRED) {
            syncVoucherSession(session, result.getSnapshot());
            session.setAttribute(SESSION_CHECKOUT_SNAPSHOT, result.getSnapshot());
            session.setAttribute(SESSION_CHECKOUT_ISSUES, issueMessages(result));
            response.sendRedirect(request.getContextPath() + "/checkout");
            return;
        }

        if (result.getStatus() == CheckoutResult.Status.BLOCKED) {
            session.setAttribute(SESSION_CHECKOUT_ISSUES, issueMessages(result));
            response.sendRedirect(request.getContextPath()
                    + (hasBookIssue(result) ? "/cart" : "/checkout"));
            return;
        }

        if (result.getStatus() != CheckoutResult.Status.VALID) {
            session.setAttribute("errorMessage", "Could not create the order. Please try again!");
            response.sendRedirect(request.getContextPath() + "/checkout");
            return;
        }

        int orderID = result.getOrderID();

        orderDAO.clearCart(account.getId());

        session.removeAttribute(SESSION_VOUCHER_ID);
        session.removeAttribute(SESSION_VOUCHER_CODE);
        session.removeAttribute(SESSION_VOUCHER_DISCOUNT);
        session.removeAttribute(SESSION_CHECKOUT_SNAPSHOT);
        session.removeAttribute(SESSION_CHECKOUT_ISSUES);

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
    private static final String SESSION_CHECKOUT_SNAPSHOT = "codCheckoutSnapshot";
    private static final String SESSION_CHECKOUT_ISSUES = "checkoutIssueMessages";

    private CheckoutSnapshot createSnapshot(List<CartItem> cartItems, Voucher voucher,
            BigDecimal subtotal, BigDecimal discount) {
        List<CheckoutSnapshot.Item> items = new ArrayList<>();
        for (CartItem item : cartItems) {
            items.add(new CheckoutSnapshot.Item(
                    item.getBookID(), item.getTitle(), item.getQuantity(), item.getPrice()));
        }

        BigDecimal safeDiscount = discount == null ? BigDecimal.ZERO : discount;
        BigDecimal total = subtotal.subtract(safeDiscount).max(BigDecimal.ZERO);
        return new CheckoutSnapshot(
                items,
                voucher == null ? null : voucher.getVoucherID(),
                voucher == null ? null : voucher.getCode(),
                voucher == null ? null : BigDecimal.valueOf(voucher.getDiscountPercent()),
                voucher == null ? null : voucher.getQuantity(),
                voucher == null ? null : voucher.getStartDate(),
                voucher == null ? null : voucher.getEndDate(),
                voucher == null || voucher.getMinOrderValue() == null
                        ? null : BigDecimal.valueOf(voucher.getMinOrderValue()),
                voucher == null || voucher.getMaxDiscountValue() == null
                        ? null : BigDecimal.valueOf(voucher.getMaxDiscountValue()),
                subtotal, safeDiscount, total);
    }

    private CheckoutSnapshot createSnapshotAfterVoucherApply(HttpSession session,
            List<CartItem> currentItems, Voucher voucher, BigDecimal currentSubtotal,
            BigDecimal discount, BigDecimal displayedTotal) {
        CheckoutSnapshot displayed = (CheckoutSnapshot) session.getAttribute(SESSION_CHECKOUT_SNAPSHOT);
        if (displayed == null) {
            return createSnapshot(currentItems, voucher, currentSubtotal, discount);
        }

        return new CheckoutSnapshot(
                displayed.getItems(),
                voucher.getVoucherID(),
                voucher.getCode(),
                BigDecimal.valueOf(voucher.getDiscountPercent()),
                voucher.getQuantity(),
                voucher.getStartDate(),
                voucher.getEndDate(),
                voucher.getMinOrderValue() == null
                        ? null : BigDecimal.valueOf(voucher.getMinOrderValue()),
                voucher.getMaxDiscountValue() == null
                        ? null : BigDecimal.valueOf(voucher.getMaxDiscountValue()),
                displayed.getSubtotal(), discount, displayedTotal);
    }

    private void syncVoucherSession(HttpSession session, CheckoutSnapshot snapshot) {
        if (snapshot == null || snapshot.getVoucherID() == null) {
            session.removeAttribute(SESSION_VOUCHER_ID);
            session.removeAttribute(SESSION_VOUCHER_CODE);
            session.removeAttribute(SESSION_VOUCHER_DISCOUNT);
            return;
        }
        session.setAttribute(SESSION_VOUCHER_ID, snapshot.getVoucherID());
        session.setAttribute(SESSION_VOUCHER_CODE, snapshot.getVoucherCode());
        session.setAttribute(SESSION_VOUCHER_DISCOUNT, snapshot.getDiscount().doubleValue());
    }

    private List<String> issueMessages(CheckoutResult result) {
        List<String> messages = new ArrayList<>();
        for (CheckoutIssue issue : result.getIssues()) {
            messages.add(issue.getMessage());
        }
        return messages;
    }

    private boolean hasBookIssue(CheckoutResult result) {
        for (CheckoutIssue issue : result.getIssues()) {
            if (issue.getCode().startsWith("BOOK_")
                    || "INSUFFICIENT_STOCK".equals(issue.getCode())) {
                return true;
            }
        }
        return false;
    }

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
        List<CartItem> cartItems = cartDAO.getCartItemsForCheckout(account.getId());

        if (cartItems.isEmpty()) {
            response.getWriter().write("{\"success\":false,\"message\":\"The cart is empty or all items are out of stock.\"}");
            return;
        }
        for (CartItem item : cartItems) {
            if (!"available".equalsIgnoreCase(item.getStatus())) {
                response.getWriter().write("{\"success\":false,\"message\":\""
                        + escapeJson("'" + item.getTitle()
                                + "' is no longer available for sale. Please review your cart.")
                        + "\"}");
                return;
            }
            if (item.getQuantity() < 1 || item.getStockQuantity() < item.getQuantity()) {
                response.getWriter().write("{\"success\":false,\"message\":\""
                        + escapeJson("'" + item.getTitle() + "' only has "
                                + item.getStockQuantity() + " item(s) left. Please update your cart.")
                        + "\"}");
                return;
            }
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
        session.setAttribute(SESSION_CHECKOUT_SNAPSHOT,
                createSnapshotAfterVoucherApply(
                        session, cartItems, result.voucher, total,
                        BigDecimal.valueOf(result.discountAmount), newTotal));

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
            CheckoutSnapshot old = (CheckoutSnapshot) session.getAttribute(SESSION_CHECKOUT_SNAPSHOT);
            if (old != null) {
                session.setAttribute(SESSION_CHECKOUT_SNAPSHOT,
                        new CheckoutSnapshot(
                                old.getItems(), null, null, null, null,
                                null, null, null, null,
                                old.getSubtotal(), BigDecimal.ZERO, old.getSubtotal()));
            }
        }

        response.getWriter().write("{\"success\":true}");
    }

    private void handleListVouchers(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        response.setContentType("application/json;charset=UTF-8");

        VoucherDAO voucherDAO = new VoucherDAO();
        Account account = getAccount(request);
        List<Voucher> vouchers = voucherDAO.getActiveVouchers(account.getId());
        List<CartItem> cartItems = new CartDAO().getCartItemsForCheckout(account.getId());
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
