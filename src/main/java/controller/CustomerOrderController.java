package controller;

import dao.OrderDAO;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Account;
import model.Order;
import model.OrderDetail;

public class CustomerOrderController extends HttpServlet {

    // Phần này tương ứng với backlog:
    // - View Customer Orders
    // - View Customer Order Detail
    // - Update Customer Order Status
    // - Approve Refund Request
    // - Reject Refund Request
    private final OrderDAO orderDAO = new OrderDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        if (!hasAccess(request, response)) {
            return;
        }

        String action = request.getParameter("action");
        if (action == null) {
            action = "";
        }

        switch (action) {
            case "view":
                int viewOrderID = parseInt(request.getParameter("orderID"), 0);
                request.getSession().setAttribute("allowed_staff_order_id", viewOrderID);
                response.sendRedirect(request.getContextPath() + "/dashboard/customer-order?action=detail&orderID=" + viewOrderID);
                break;
            case "detail":
                showDetail(request, response);
                break;
            default:
                showList(request, response);
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        if (!hasAccess(request, response)) {
            return;
        }

        request.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");
        if (action == null) {
            action = "";
        }

        switch (action) {
            case "updateStatus":
                // Staff cập nhật trạng thái đơn hàng như confirmed, shipping, completed, cancelled.
                handleUpdateStatus(request, response);
                break;
            case "confirmRefund":
                // Admin xác nhận yêu cầu hoàn tiền, chuyển payment_status từ pending_refund -> refunded.
                handleConfirmRefund(request, response);
                break;
            case "rejectRefund":
                // Admin từ chối hoàn tiền, gửi lý do cho khách.
                handleRejectRefund(request, response);
                break;
            default:
                response.sendRedirect(request.getContextPath() + "/dashboard/customer-order");
                break;
        }
    }

    private void showList(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String status = request.getParameter("status");

        int pageSize = 10;
        int currentPage = 1;
        try {
            String p = request.getParameter("page");
            if (p != null) {
                int parsedPage = Integer.parseInt(p);
                if (parsedPage < 1) {
                    currentPage = 1;
                } else {
                    currentPage = parsedPage;
                }
            }
        } catch (Exception ignored) {
        }

        int totalRecords = orderDAO.countFilteredOrders(status);
        int totalPages;
        if (totalRecords == 0) {
            totalPages = 1;
        } else {
            totalPages = (totalRecords + pageSize - 1) / pageSize;
        }
        if (currentPage > totalPages) {
            currentPage = totalPages;
        }
        int offset = (currentPage - 1) * pageSize;

        request.setAttribute("orderList", orderDAO.getAllOrders(status, offset, pageSize));
        request.setAttribute("currentPage", currentPage);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("totalRecords", totalRecords);
        request.setAttribute("status", status);

        String statusParam = "";
        if (status != null) {
            statusParam = status;
        }
        String baseUrl = request.getContextPath() + "/dashboard/customer-order?status=" + statusParam;
        request.setAttribute("baseUrl", baseUrl);

        request.setAttribute("countPending", orderDAO.countOrdersByStatus("pending"));
        request.setAttribute("countConfirmed", orderDAO.countOrdersByStatus("confirmed"));
        request.setAttribute("countShipping", orderDAO.countOrdersByStatus("shipping"));
        request.setAttribute("countCompleted", orderDAO.countOrdersByStatus("completed"));
        request.setAttribute("countPendingRefund", orderDAO.countOrdersByStatus("pending_refund"));
        request.setAttribute("countRefunded", orderDAO.countOrdersByStatus("refunded"));
        request.setAttribute("countRefundRejected", orderDAO.countOrdersByStatus("refund_rejected"));

        request.getRequestDispatcher("/views/staff/customer-order.jsp").forward(request, response);
    }

    private void showDetail(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int orderID = parseInt(request.getParameter("orderID"), 0);
        Order order = orderDAO.getOrderByID(orderID);

        HttpSession session = request.getSession();
        Integer allowedStaffID = (Integer) session.getAttribute("allowed_staff_order_id");
        session.removeAttribute("allowed_staff_order_id");

        if (allowedStaffID == null || allowedStaffID != orderID || order == null) {
            session.setAttribute("errorMessage", "Order not found.");
            response.sendRedirect(request.getContextPath() + "/dashboard/customer-order");
            return;
        }

        List<OrderDetail> orderDetails = orderDAO.getOrderDetails(orderID);

        request.setAttribute("order", order);
        request.setAttribute("orderDetails", orderDetails);

        request.getRequestDispatcher("/views/staff/customer-order-detail.jsp").forward(request, response);
    }

    private void handleUpdateStatus(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        // Staff xử lý trạng thái đơn hàng theo từng step.
        // Ngoài cập nhật status, còn phải kiểm tra tồn kho, hủy tự động, và gửi email thông báo.
        int orderID = parseInt(request.getParameter("orderID"), 0);
        String status = request.getParameter("status");
        String redirect = request.getParameter("redirect");

        HttpSession session = request.getSession();
        Account staff = (Account) session.getAttribute("account");

        String cancelReason = request.getParameter("cancelReason");
        if (cancelReason == null) {
            cancelReason = "";
        }
        cancelReason = cancelReason.trim();

        if ("cancelled".equalsIgnoreCase(status)) {
            if (cancelReason.isEmpty()) {
                session.setAttribute("errorMessage", "Please enter a cancellation reason.");
                if ("detail".equals(redirect)) {
                    session.setAttribute("allowed_staff_order_id", orderID);
                    response.sendRedirect(request.getContextPath() + "/dashboard/customer-order?action=detail&orderID=" + orderID);
                } else {
                    response.sendRedirect(request.getContextPath() + "/dashboard/customer-order");
                }
                return;
            }

            if (cancelReason.length() < 10 || cancelReason.length() > 50) {
                session.setAttribute("errorMessage", "The cancellation reason must be 10–50 characters long.");
                if ("detail".equals(redirect)) {
                    session.setAttribute("allowed_staff_order_id", orderID);
                    response.sendRedirect(request.getContextPath() + "/dashboard/customer-order?action=detail&orderID=" + orderID);
                } else {
                    response.sendRedirect(request.getContextPath() + "/dashboard/customer-order");
                }
                return;
            }

            if (!cancelReason.matches(".*\\p{L}.*")) {
                session.setAttribute("errorMessage", "The cancellation reason must contain at least one letter.");
                if ("detail".equals(redirect)) {
                    session.setAttribute("allowed_staff_order_id", orderID);
                    response.sendRedirect(request.getContextPath() + "/dashboard/customer-order?action=detail&orderID=" + orderID);
                } else {
                    response.sendRedirect(request.getContextPath() + "/dashboard/customer-order");
                }
                return;
            }
        }

        model.Order order = orderDAO.getOrderByID(orderID);

        if ("confirmed".equalsIgnoreCase(status)) {
            // Khi staff xác nhận đơn, cần trừ kho.
            // Nếu không đủ hàng thì tự động hủy và gửi thông báo cho khách.
            boolean stockOk = orderDAO.deductStock(orderID);
            if (!stockOk) {
                String outOfStockReason = "The product was out of stock when the order was reviewed";
                orderDAO.updateOrderStatusAndStaff(orderID, "cancelled", staff.getId(), outOfStockReason);
                if (order != null && order.getCustomerEmail() != null) {
                    final model.Order finalOrder = order;
                    new Thread(new Runnable() {
                        @Override
                        public void run() {
                            try {
                                utils.EmailUtil.sendOrderCancelledEmail(finalOrder.getCustomerEmail(), finalOrder, outOfStockReason);
                            } catch (Exception e) {
                                e.printStackTrace();
                            }
                        }
                    }).start();
                }
                session.setAttribute("errorMessage", "Insufficient stock. The order was cancelled automatically and the customer was notified.");
                if ("detail".equals(redirect)) {
                    session.setAttribute("allowed_staff_order_id", orderID);
                    response.sendRedirect(request.getContextPath() + "/dashboard/customer-order?action=detail&orderID=" + orderID);
                } else {
                    response.sendRedirect(request.getContextPath() + "/dashboard/customer-order");
                }
                return;
            }
        }

        if (order != null) {
            if ("completed".equalsIgnoreCase(status)) {
                // COD chưa thanh toán thì khi giao hàng xong, chuyển sang paid để chuẩn bị hoàn tiền / thanh toán.
                if ("cod".equalsIgnoreCase(order.getPaymentMethod()) && "unpaid".equalsIgnoreCase(order.getPaymentStatus())) {
                    orderDAO.updatePaymentStatus(orderID, "paid");
                }
            } else if ("cancelled".equalsIgnoreCase(status)) {
                if ("cod".equalsIgnoreCase(order.getPaymentMethod()) && "paid".equalsIgnoreCase(order.getPaymentStatus())) {

                    orderDAO.updatePaymentStatus(orderID, "pending_refund");

                    final model.Order finalOrder = order;
                    new Thread(new Runnable() {
                        @Override
                        public void run() {
                            try {
                                utils.EmailUtil.sendRefundPendingEmail(finalOrder.getCustomerEmail(), finalOrder);
                            } catch (Exception e) {
                                e.printStackTrace();
                            }
                        }
                    }).start();
                } else {
                    final model.Order finalOrder = order;
                    final String finalReason = cancelReason;
                    new Thread(new Runnable() {
                        @Override
                        public void run() {
                            try {
                                utils.EmailUtil.sendOrderCancelledEmail(finalOrder.getCustomerEmail(), finalOrder, finalReason);
                            } catch (Exception e) {
                                e.printStackTrace();
                            }
                        }
                    }).start();
                }
            }
        }

        boolean ok;
        if ("cancelled".equalsIgnoreCase(status)) {
            ok = orderDAO.updateOrderStatusAndStaff(orderID, status, staff.getId(), cancelReason);
        } else {
            ok = orderDAO.updateOrderStatusAndStaff(orderID, status, staff.getId());
        }

        if (ok) {
            if ("cancelled".equalsIgnoreCase(status)) {
                // Nếu hủy đơn ở trạng thái đã xác nhận hoặc đang giao, cần hoàn lại tồn kho.
                if (order != null) {
                    String currentStatus = order.getStatus();
                    boolean isConfirmed = "confirmed".equalsIgnoreCase(currentStatus);
                    boolean isShipping = "shipping".equalsIgnoreCase(currentStatus);
                    if (isConfirmed || isShipping) {
                        orderDAO.restoreStock(orderID);
                    }
                }
            }
            session.setAttribute("successMessage", "Order status updated successfully!");
        } else {
            session.setAttribute("errorMessage", "Could not update the order status.");
        }

        if ("detail".equals(redirect)) {
            session.setAttribute("allowed_staff_order_id", orderID);
            response.sendRedirect(request.getContextPath() + "/dashboard/customer-order?action=detail&orderID=" + orderID);
        } else {
            response.sendRedirect(request.getContextPath() + "/dashboard/customer-order");
        }
    }

    private void handleConfirmRefund(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        // Dùng cho chức năng "Approve Refund Request" trong backlog.
        // Khi admin xác nhận, đổi payment_status từ pending_refund sang refunded.
        int orderID = parseInt(request.getParameter("orderID"), 0);
        HttpSession session = request.getSession();

        model.Order order = orderDAO.getOrderByID(orderID);
        if (order == null) {
            session.setAttribute("errorMessage", "Order not found.");
            response.sendRedirect(request.getContextPath() + "/dashboard/customer-order");
            return;
        }

        boolean ok = orderDAO.confirmRefund(orderID);

        if (ok) {
            final model.Order updatedOrder = orderDAO.getOrderByID(orderID);
            if (updatedOrder != null && updatedOrder.getCustomerEmail() != null) {
                new Thread(new Runnable() {
                    @Override
                    public void run() {
                        try {
                            utils.EmailUtil.sendRefundConfirmedEmail(updatedOrder.getCustomerEmail(), updatedOrder);
                        } catch (Exception e) {
                            e.printStackTrace();
                        }
                    }
                }).start();
            }
            session.setAttribute("successMessage", "Refund confirmed and customer notification sent!");
        } else {
            session.setAttribute("errorMessage", "Cannot confirm the refund because this order is not awaiting a refund.");
        }

        session.setAttribute("allowed_staff_order_id", orderID);
        response.sendRedirect(request.getContextPath() + "/dashboard/customer-order?action=detail&orderID=" + orderID);
    }

    private void handleRejectRefund(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        int orderID = parseInt(request.getParameter("orderID"), 0);
        HttpSession session = request.getSession();

        String rejectReason = request.getParameter("rejectReason");
        if (rejectReason == null) {
            rejectReason = "";
        }
        rejectReason = rejectReason.trim();

        if (rejectReason.isEmpty()) {
            session.setAttribute("errorMessage", "Please enter a refund rejection reason.");
            session.setAttribute("allowed_staff_order_id", orderID);
            response.sendRedirect(request.getContextPath() + "/dashboard/customer-order?action=detail&orderID=" + orderID);
            return;
        }
        if (rejectReason.length() < 10 || rejectReason.length() > 50) {
            session.setAttribute("errorMessage", "The refund rejection reason must be 10–50 characters long.");
            session.setAttribute("allowed_staff_order_id", orderID);
            response.sendRedirect(request.getContextPath() + "/dashboard/customer-order?action=detail&orderID=" + orderID);
            return;
        }
        if (!rejectReason.matches(".*\\p{L}.*")) {
            session.setAttribute("errorMessage", "The refund rejection reason must contain at least one letter.");
            session.setAttribute("allowed_staff_order_id", orderID);
            response.sendRedirect(request.getContextPath() + "/dashboard/customer-order?action=detail&orderID=" + orderID);
            return;
        }

        model.Order order = orderDAO.getOrderByID(orderID);
        if (order == null) {
            session.setAttribute("errorMessage", "Order not found.");
            response.sendRedirect(request.getContextPath() + "/dashboard/customer-order");
            return;
        }

        boolean ok = orderDAO.rejectRefund(orderID, rejectReason);

        if (ok) {
            final model.Order updatedOrder = orderDAO.getOrderByID(orderID);
            final String finalReason = rejectReason;
            if (updatedOrder != null && updatedOrder.getCustomerEmail() != null) {
                new Thread(new Runnable() {
                    @Override
                    public void run() {
                        try {
                            utils.EmailUtil.sendRefundRejectedEmail(updatedOrder.getCustomerEmail(), updatedOrder, finalReason);
                        } catch (Exception e) {
                            e.printStackTrace();
                        }
                    }
                }).start();
            }
            session.setAttribute("successMessage", "Refund request rejected and customer notification sent!");
        } else {
            session.setAttribute("errorMessage", "Cannot reject the refund because this order is not awaiting a refund.");
        }

        session.setAttribute("allowed_staff_order_id", orderID);
        response.sendRedirect(request.getContextPath() + "/dashboard/customer-order?action=detail&orderID=" + orderID);
    }

    private boolean hasAccess(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        HttpSession session = request.getSession(false);
        if (session == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return false;
        }
        Account user = (Account) session.getAttribute("account");
        if (user == null || !"staff".equals(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login");
            return false;
        }
        return true;
    }

    private int parseInt(String s, int defaultVal) {
        try {
            return Integer.parseInt(s);
        } catch (Exception e) {
            return defaultVal;
        }
    }
}
