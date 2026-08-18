package controller;

import dao.OrderDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Account;
import model.CartItem;
import model.Order;
import utils.VNPayConfig;

import java.io.IOException;
import java.math.BigDecimal;
import java.util.*;

public class VNPayReturnController extends HttpServlet {

    private final OrderDAO orderDAO = new OrderDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        Map<String, String> vnp_Params = new HashMap<>();
        for (Map.Entry<String, String[]> entry : request.getParameterMap().entrySet()) {
            String key = entry.getKey();
            if (!key.equals("vnp_SecureHash") && !key.equals("vnp_SecureHashType")) {
                vnp_Params.put(key, entry.getValue()[0]);
            }
        }

        String vnp_SecureHash = request.getParameter("vnp_SecureHash");
        String calculatedHash = VNPayConfig.hashAllFields(vnp_Params);
        boolean isValidSignature = calculatedHash.equalsIgnoreCase(vnp_SecureHash);
        String vnp_ResponseCode = request.getParameter("vnp_ResponseCode");
        HttpSession session = request.getSession(false);

        boolean isResponseOk = "00".equals(vnp_ResponseCode);
        if (isValidSignature && isResponseOk) {
            if (session == null) {
                response.sendRedirect(request.getContextPath() + "/home");
                return;
            }

            Account account = (Account) session.getAttribute("account");
            if (account == null) {
                response.sendRedirect(request.getContextPath() + "/login");
                return;
            }

            Object addressIDObj = session.getAttribute("vnpay_addressID");
            BigDecimal total = (BigDecimal) session.getAttribute("vnpay_total");

            if (addressIDObj == null) {
                session.setAttribute("errorMessage", "The payment session has expired. Please try again!");
                response.sendRedirect(request.getContextPath() + "/checkout");
                return;
            }
            if (total == null) {
                session.setAttribute("errorMessage", "The payment session has expired. Please try again!");
                response.sendRedirect(request.getContextPath() + "/checkout");
                return;
            }

            int addressID = (Integer) addressIDObj;

            @SuppressWarnings("unchecked")
            List<CartItem> cartItems = (List<CartItem>) session.getAttribute("vnpay_cartItems");

            if (cartItems == null) {
                session.setAttribute("errorMessage", "The payment session has expired. Please try again!");
                session.removeAttribute("vnpay_txnRef");
                session.removeAttribute("vnpay_addressID");
                session.removeAttribute("vnpay_total");
                session.removeAttribute("vnpay_cartItems");
                response.sendRedirect(request.getContextPath() + "/checkout");
                return;
            }
            if (cartItems.isEmpty()) {
                session.setAttribute("errorMessage", "The payment session has expired. Please try again!");
                session.removeAttribute("vnpay_txnRef");
                session.removeAttribute("vnpay_addressID");
                session.removeAttribute("vnpay_total");
                session.removeAttribute("vnpay_cartItems");
                response.sendRedirect(request.getContextPath() + "/checkout");
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
                session.setAttribute("errorMessage", "All cart items are out of stock. Please contact support for a refund.");
                session.removeAttribute("vnpay_txnRef");
                session.removeAttribute("vnpay_addressID");
                session.removeAttribute("vnpay_total");
                session.removeAttribute("vnpay_cartItems");
                response.sendRedirect(request.getContextPath() + "/cart");
                return;
            }

            // Kiểm tồn + tạo đơn pending — KHÔNG trừ kho ngay.
            // Kho thật sẽ trừ khi Staff duyệt.
            int orderID = orderDAO.createOrderWithStockCheck(
                    account.getId(), addressID, "vnpay", total, cartItems);

            if (orderID == -2) {
                // Out of Stock tại thời điểm VNPay return — tiền đã thu, cần hoàn
                session.setAttribute("errorMessage",
                        "An item in your cart went out of stock during payment. "
                        + "Please contact support for a refund!");
                session.removeAttribute("vnpay_txnRef");
                session.removeAttribute("vnpay_addressID");
                session.removeAttribute("vnpay_total");
                session.removeAttribute("vnpay_cartItems");
                response.sendRedirect(request.getContextPath() + "/cart");
                return;
            }
            if (orderID == -1) {
                session.setAttribute("errorMessage", "Could not create the order!");
                response.sendRedirect(request.getContextPath() + "/checkout");
                return;
            }

            // Đánh dấu đã thanh toán (tiền đã thu qua VNPay)
            orderDAO.updatePaymentStatus(orderID, "paid");

            orderDAO.clearCart(account.getId());

            Integer appliedVoucherID = (Integer) session.getAttribute("appliedVoucherID");
            if (appliedVoucherID != null) {
                String appliedCode = (String) session.getAttribute("appliedVoucherCode");
                dao.VoucherDAO voucherDAO = new dao.VoucherDAO();
                model.Voucher v = voucherDAO.getVoucherByCode(appliedCode);
                Integer vQty;
                if (v != null) {
                    vQty = v.getQuantity();
                } else {
                    vQty = null;
                }
                voucherDAO.insertVoucherUsage(account.getId(), appliedVoucherID, vQty);

                session.removeAttribute("appliedVoucherID");
                session.removeAttribute("appliedVoucherCode");
                session.removeAttribute("appliedVoucherDiscount");
            }

            session.removeAttribute("vnpay_txnRef");
            session.removeAttribute("vnpay_addressID");
            session.removeAttribute("vnpay_total");
            session.removeAttribute("vnpay_cartItems");

            Order order = orderDAO.getOrderByID(orderID);
            String orderCode;
            if (order != null) {
                orderCode = order.getOrderCode();
            } else {
                orderCode = "HS-" + orderID;
            }
            session.setAttribute("cartCount", 0);
            session.setAttribute("just_placed_order_id", orderID);
            session.setAttribute("successMessage",
                    "VNPAY payment successful! Order code: " + orderCode);

            response.sendRedirect(request.getContextPath()
                    + "/order-confirmation?orderID=" + orderID);

        } else {
            if (session != null) {
                session.removeAttribute("vnpay_txnRef");
                session.removeAttribute("vnpay_addressID");
                session.removeAttribute("vnpay_total");
                session.removeAttribute("vnpay_cartItems");

                String msg;

                switch (vnp_ResponseCode) {
                    case "24":
                        msg = "You cancelled the VNPAY transaction!";
                        break;

                    default:
                        msg = "VNPAY payment failed. Please try again.";
                        break;
                }
                session.setAttribute("errorMessage", msg);
            }
            response.sendRedirect(request.getContextPath() + "/checkout");
        }
    }
}
