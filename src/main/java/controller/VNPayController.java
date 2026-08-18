package controller;

import dao.BookDAO;
import dao.CartDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Account;
import model.CartItem;
import utils.VNPayConfig;

import java.io.IOException;
import java.math.BigDecimal;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.text.SimpleDateFormat;
import java.util.*;

public class VNPayController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.sendRedirect(request.getContextPath() + "/checkout");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("account") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        Account account = (Account) session.getAttribute("account");

        String fullname = request.getParameter("fullname");
        String phone = request.getParameter("phone");
        String street = request.getParameter("street");
        String district = request.getParameter("district");
        String city = request.getParameter("city");
        String addressIDRaw = request.getParameter("addressID");

        if (isEmpty(fullname) || isEmpty(phone) || isEmpty(street)
                || isEmpty(district) || isEmpty(city)) {
            session.setAttribute("errorMessage", "Please complete all shipping information!");
            response.sendRedirect(request.getContextPath() + "/checkout");
            return;
        }

        if (isEmpty(addressIDRaw)) {
            session.setAttribute("errorMessage", "Please select a shipping address!");
            response.sendRedirect(request.getContextPath() + "/checkout");
            return;
        }

        int addressID;
        try {
            addressID = Integer.parseInt(addressIDRaw.trim());
        } catch (NumberFormatException e) {
            session.setAttribute("errorMessage", "Invalid shipping address!");
            response.sendRedirect(request.getContextPath() + "/checkout");
            return;
        }

        CartDAO cartDAO = new CartDAO();
        List<CartItem> cartItems = cartDAO.getCartItems(account.getId());

        if (cartItems.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/cart");
            return;
        }

        List<CartItem> availableItems = new java.util.ArrayList<>();
        for (CartItem item : cartItems) {
            if (item.getStockQuantity() > 0) {
                availableItems.add(item);
            }
        }
        cartItems = availableItems;

        if (cartItems.isEmpty()) {
            session.setAttribute("errorMessage", "All items in your cart are out of stock!");
            response.sendRedirect(request.getContextPath() + "/cart");
            return;
        }

        // Kiểm tra số lượng tồn kho chính xác trước khi mở cổng VNPAY
        // (tránh trường hợp khách đã trả tiền nhưng số lượng vượt kho)
        BookDAO bookDAO = new BookDAO();
        for (CartItem item : cartItems) {
            String stockError = bookDAO.validatePurchaseQuantity(item.getBookID(), item.getQuantity());
            if (stockError != null) {
                session.setAttribute("errorMessage",
                        item.getTitle() + ": " + stockError);
                response.sendRedirect(request.getContextPath() + "/cart");
                return;
            }
        }

        BigDecimal total = cartDAO.calcSubtotal(cartItems);

        Double discountObj = (Double) session.getAttribute("appliedVoucherDiscount");
        if (discountObj != null) {
            if (discountObj > 0) {
                BigDecimal discount = BigDecimal.valueOf(discountObj);
                total = total.subtract(discount);
                if (total.compareTo(BigDecimal.ZERO) < 0) {
                    total = BigDecimal.ZERO;
                }
            }
        }

        String txnRef = VNPayConfig.getRandomNumber(12);
        session.setAttribute("vnpay_txnRef", txnRef);
        session.setAttribute("vnpay_addressID", addressID);
        session.setAttribute("vnpay_total", total);
        session.setAttribute("vnpay_cartItems", new java.util.ArrayList<>(cartItems));

        String vnpayUrl = buildVNPayUrl(request, txnRef, total);
        response.sendRedirect(vnpayUrl);
    }

    private String buildVNPayUrl(HttpServletRequest request, String txnRef, BigDecimal total)
            throws IOException {

        long amount = total.setScale(0, java.math.RoundingMode.HALF_UP).longValue() * 100;

        Calendar cld = Calendar.getInstance(TimeZone.getTimeZone("Etc/GMT+7"));
        SimpleDateFormat formatter = new SimpleDateFormat("yyyyMMddHHmmss");
        String vnp_CreateDate = formatter.format(cld.getTime());
        cld.add(Calendar.MINUTE, 15);
        String vnp_ExpireDate = formatter.format(cld.getTime());

        Map<String, String> vnp_Params = new HashMap<>();
        vnp_Params.put("vnp_Version", VNPayConfig.vnp_Version);
        vnp_Params.put("vnp_Command", VNPayConfig.vnp_Command);
        vnp_Params.put("vnp_TmnCode", VNPayConfig.vnp_TmnCode);
        vnp_Params.put("vnp_Amount", String.valueOf(amount));
        vnp_Params.put("vnp_CurrCode", VNPayConfig.vnp_CurrCode);
        vnp_Params.put("vnp_TxnRef", txnRef);
        vnp_Params.put("vnp_OrderInfo", "Payment for order: " + txnRef);
        vnp_Params.put("vnp_OrderType", VNPayConfig.vnp_OrderType);
        vnp_Params.put("vnp_Locale", VNPayConfig.vnp_Locale);
        vnp_Params.put("vnp_ReturnUrl", VNPayConfig.vnp_ReturnUrl);
        vnp_Params.put("vnp_IpAddr", VNPayConfig.getIpAddress(request));
        vnp_Params.put("vnp_CreateDate", vnp_CreateDate);
        vnp_Params.put("vnp_ExpireDate", vnp_ExpireDate);

        List<String> fieldNames = new ArrayList<>(vnp_Params.keySet());
        Collections.sort(fieldNames);

        StringBuilder hashData = new StringBuilder();
        StringBuilder query = new StringBuilder();

        Iterator<String> itr = fieldNames.iterator();
        while (itr.hasNext()) {
            String fieldName = itr.next();
            String fieldValue = vnp_Params.get(fieldName);
            if (fieldValue != null) {
                if (fieldValue.length() > 0) {
                    hashData.append(fieldName);
                    hashData.append('=');
                    hashData.append(URLEncoder.encode(fieldValue, StandardCharsets.US_ASCII.toString()));
                    query.append(URLEncoder.encode(fieldName, StandardCharsets.US_ASCII.toString()));
                    query.append('=');
                    query.append(URLEncoder.encode(fieldValue, StandardCharsets.US_ASCII.toString()));
                    if (itr.hasNext()) {
                        query.append('&');
                        hashData.append('&');
                    }
                }
            }
        }

        String secureHash = VNPayConfig.hmacSHA512(VNPayConfig.vnp_HashSecret, hashData.toString());
        query.append("&vnp_SecureHash=").append(secureHash);
        return VNPayConfig.vnp_PayUrl + "?" + query.toString();
    }

    private boolean isEmpty(String value) {
        return value == null || value.trim().isEmpty();
    }
}
