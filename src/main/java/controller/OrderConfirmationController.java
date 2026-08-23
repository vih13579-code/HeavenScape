package controller;

import dao.OrderDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Account;
import model.Order;

import java.io.IOException;

public class OrderConfirmationController extends HttpServlet {

    private final OrderDAO orderDAO = new OrderDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        if (!isCustomer(request, response)) {
            return;
        }

        Account account = getAccount(request);
        int orderID = toInt(request.getParameter("orderID"), 0);
        request.getSession().removeAttribute("just_placed_order_id");

        Order order = orderDAO.getOrderByID(orderID);

        // The confirmation page must remain accessible on browser Back/Forward
        // and Refresh. Ownership is the authorization boundary; a one-time
        // session flag would incorrectly turn a valid revisit into a 404.
        if (order == null || order.getCustomerID() != account.getId()) {
            request.getRequestDispatcher("/views/error/404.jsp").forward(request, response);
            return;
        }

        request.setAttribute("order", order);
        request.getRequestDispatcher("/views/order/order-confirmation.jsp").forward(request, response);
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
