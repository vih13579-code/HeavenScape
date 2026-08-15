package controller;

import dao.AccountDAO;
import dao.CustomerDAO;
import dao.OrderDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Account;

public class AccountManagementController extends HttpServlet {

    private CustomerDAO customerDAO;
    private AccountDAO accountDAO;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // TODO: implement
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // TODO: implement
    }

    private void handleToggleCustomer(HttpServletRequest request, PrintWriter out) {
        // TODO: implement
    }

    private void handleToggleStaff(HttpServletRequest request, PrintWriter out, Account loginUser) {
        // TODO: implement
    }

    private void sendAccountStatusEmailAsync(String email, String fullname, String newStatus) {
        // TODO: implement
    }

    private void handleUpdateCustomer(HttpServletRequest request, PrintWriter out) {
        // TODO: implement
    }

    private void handleUpdateStaff(HttpServletRequest request, PrintWriter out, Account loginUser) {
        // TODO: implement
    }

    private void getCustomerStats(HttpServletRequest request, PrintWriter out) {
        // TODO: implement
    }

    private String nvl(String value, String defaultValue) {
        // TODO: implement
        return null;
    }

    private String validatePhone(String phone) {
        // TODO: implement
        return null;
    }

    @Override
    public String getServletInfo() {
        // TODO: implement
        return null;
    }
}
