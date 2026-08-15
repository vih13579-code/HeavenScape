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
        // TODO: implement
    }

    private boolean isCustomer(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        // TODO: implement
        return false;
    }

    private Account getAccount(HttpServletRequest request) {
        // TODO: implement
        return null;
    }

    private int toInt(String value, int defaultVal) {
        // TODO: implement
        return 0;
    }
}
