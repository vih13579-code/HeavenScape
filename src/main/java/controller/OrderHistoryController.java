package controller;

import dao.OrderDAO;
import dao.CartDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Account;
import model.Order;
import model.OrderDetail;

import java.io.IOException;
import java.util.List;

public class OrderHistoryController extends HttpServlet {

    private static final int PAGE_SIZE = 5;

    private final OrderDAO orderDAO = new OrderDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        if (!isCustomer(request, response)) {
            return;
        }

        String action = request.getParameter("action");
        if (action == null) {
            action = "";
        }

        switch (action) {
            case "view":
                int viewOrderID = toInt(request.getParameter("orderID"), 0);
                response.sendRedirect(request.getContextPath() + "/profile/order-history?action=detail&orderID=" + viewOrderID);
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

        if (!isCustomer(request, response)) {
            return;
        }

        String action = request.getParameter("action");
        if (action == null) {
            action = "";
        }

        switch (action) {
            case "cancel":
                handleCancel(request, response);
                break;
            case "requestRefund":
                handleRefundRequest(request, response);
                break;
            case "buyAgain":
                handleBuyAgain(request, response);
                break;
            default:
                response.sendRedirect(request.getContextPath() + "/profile/order-history");
                break;
        }
    }

    private void showList(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        Account account = getAccount(request);

        String status = request.getParameter("status");

        int pageSize = PAGE_SIZE;
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

        int totalRecords = orderDAO.countOrdersByCustomerFiltered(account.getId(), status);
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

        List<Order> orders = orderDAO.getOrdersByCustomerFiltered(account.getId(), status, offset, pageSize);
        for (Order order : orders) {
            order.setOrderDetails(orderDAO.getOrderDetails(order.getOrderID()));
        }

        request.setAttribute("orders", orders);
        request.setAttribute("currentPage", currentPage);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("status", status);

        String statusParam = "";
        if (status != null) {
            statusParam = status;
        }
        String baseUrl = request.getContextPath() + "/profile/order-history?status=" + statusParam;
        request.setAttribute("baseUrl", baseUrl);

        request.getRequestDispatcher("/views/order/order-history.jsp").forward(request, response);
    }

    private void showDetail(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        Account account = getAccount(request);

        int orderID = toInt(request.getParameter("orderID"), 0);

        Order order = orderDAO.getOrderByID(orderID);

        if (order == null || order.getCustomerID() != account.getId()) {
            request.getRequestDispatcher("/views/error/404.jsp").forward(request, response);
            return;
        }

        List<OrderDetail> orderDetails = orderDAO.getOrderDetails(orderID);

        request.setAttribute("order", order);
        request.setAttribute("orderDetails", orderDetails);

        request.getRequestDispatcher("/views/order/order-history-detail.jsp").forward(request, response);
    }

    private void handleCancel(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        Account account = getAccount(request);
        int orderID = toInt(request.getParameter("orderID"), 0);

        String cancelReason = request.getParameter("cancelReason");
        if (cancelReason == null) {
            cancelReason = "";
        }
        cancelReason = cancelReason.trim();

        String redirectTarget = request.getParameter("redirect");
        String redirectUrl;
        if ("list".equalsIgnoreCase(redirectTarget)) {
            redirectUrl = request.getContextPath() + "/profile/order-history";
        } else {
            redirectUrl = request.getContextPath() + "/profile/order-history?action=detail&orderID=" + orderID;
        }

        if (cancelReason.isEmpty()) {
            HttpSession session = request.getSession();
            session.setAttribute("errorMessage", "Please enter a cancellation reason.");
            response.sendRedirect(redirectUrl);
            return;
        }
        if (cancelReason.length() < 10 || cancelReason.length() > 50) {
            HttpSession session = request.getSession();
            session.setAttribute("errorMessage", "The cancellation reason must be 10-50 characters long.");
            response.sendRedirect(redirectUrl);
            return;
        }
        if (!cancelReason.matches(".*\\p{L}.*")) {
            HttpSession session = request.getSession();
            session.setAttribute("errorMessage", "The cancellation reason must contain at least one letter.");
            response.sendRedirect(redirectUrl);
            return;
        }

        Order order = orderDAO.getOrderByID(orderID);
        boolean ok = orderDAO.cancelOrder(orderID, account.getId(), cancelReason);

        HttpSession session = request.getSession();
        if (ok) {
            if (order != null) {
                boolean isCodAndPaid = "cod".equalsIgnoreCase(order.getPaymentMethod())
                        && "paid".equalsIgnoreCase(order.getPaymentStatus());

                if (isCodAndPaid) {
                    orderDAO.updatePaymentStatus(orderID, "pending_refund");

                    final Order finalOrder = order;
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
                    final Order finalOrder = order;
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

            String orderCode;
            if (order != null) {
                orderCode = order.getOrderCode();
            } else {
                orderCode = String.valueOf(orderID);
            }
            session.setAttribute("successMessage", "Order #" + orderCode + " cancelled successfully!");
        } else {
            session.setAttribute("errorMessage", "This order cannot be cancelled because it has already been processed.");
        }

        response.sendRedirect(redirectUrl);
    }

    private void handleRefundRequest(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        Account account = getAccount(request);
        int orderID = toInt(request.getParameter("orderID"), 0);
        String refundReason = request.getParameter("refundReason");
        refundReason = refundReason == null ? "" : refundReason.trim();

        String redirectTarget = request.getParameter("redirect");
        String redirectUrl = "list".equalsIgnoreCase(redirectTarget)
                ? request.getContextPath() + "/profile/order-history"
                : request.getContextPath() + "/profile/order-history?action=detail&orderID=" + orderID;

        HttpSession session = request.getSession();
        if (refundReason.isEmpty()) {
            session.setAttribute("errorMessage", "Please enter a refund reason.");
            response.sendRedirect(redirectUrl);
            return;
        }
        if (refundReason.length() < 10 || refundReason.length() > 50) {
            session.setAttribute("errorMessage", "The refund reason must be 10-50 characters long.");
            response.sendRedirect(redirectUrl);
            return;
        }
        if (!refundReason.matches(".*\\p{L}.*")) {
            session.setAttribute("errorMessage", "The refund reason must contain at least one letter.");
            response.sendRedirect(redirectUrl);
            return;
        }

        Order order = orderDAO.getOrderByID(orderID);
        boolean ok = orderDAO.requestCodRefund(orderID, account.getId(), refundReason);

        if (ok) {
            if (order != null && order.getCustomerEmail() != null) {
                final Order finalOrder = order;
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
            }
            String orderCode = order != null ? order.getOrderCode() : String.valueOf(orderID);
            session.setAttribute("successMessage",
                    "Refund request for order #" + orderCode + " was submitted successfully!");
        } else {
            session.setAttribute("errorMessage",
                    "This order is not eligible for a COD refund or has already been submitted.");
        }

        response.sendRedirect(redirectUrl);
    }

    private void handleBuyAgain(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        Account account = getAccount(request);
        int orderID = toInt(request.getParameter("orderID"), 0);
        Order order = orderDAO.getOrderByID(orderID);
        HttpSession session = request.getSession();

        if (order == null || order.getCustomerID() != account.getId()
                || !"completed".equalsIgnoreCase(order.getStatus())) {
            session.setAttribute("errorMessage", "This order is not available for repurchase.");
            response.sendRedirect(request.getContextPath() + "/profile/order-history");
            return;
        }

        List<OrderDetail> details = orderDAO.getOrderDetails(orderID);
        CartDAO cartDAO = new CartDAO();
        int addedQuantity = 0;
        boolean hasUnavailableItem = false;

        for (OrderDetail detail : details) {
            int stock = cartDAO.getStockByBookID(detail.getBookID());
            int currentQuantity = cartDAO.getCurrentCartQty(account.getId(), detail.getBookID());
            int availableQuantity = Math.max(0, stock - currentQuantity);
            int quantityToAdd = Math.min(detail.getQuantity(), availableQuantity);

            if (quantityToAdd > 0 && cartDAO.addToCart(account.getId(), detail.getBookID(), quantityToAdd)) {
                addedQuantity += quantityToAdd;
            }
            if (quantityToAdd < detail.getQuantity()) {
                hasUnavailableItem = true;
            }
        }

        if (addedQuantity == 0) {
            session.setAttribute("errorMessage", "The books in this order are currently out of stock.");
            response.sendRedirect(request.getContextPath() + "/profile/order-history");
            return;
        }

        int cartCount = 0;
        for (model.CartItem item : cartDAO.getCartItems(account.getId())) {
            cartCount += item.getQuantity();
        }
        session.setAttribute("cartCount", cartCount);
        session.setAttribute("successMessage", hasUnavailableItem
                ? "Available books were added to your cart. Some quantities were limited by stock."
                : "Order items were added to your cart.");
        response.sendRedirect(request.getContextPath() + "/cart");
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

    private int toInt(String value, int defaultVal) {
        if (value == null || value.trim().isEmpty()) {
            return defaultVal;
        }
        try {
            return Integer.parseInt(value.trim());
        } catch (NumberFormatException e) {
            return defaultVal;
        }
    }
}
