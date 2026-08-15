package controller;

import dao.AccountDAO;
import dao.CustomerDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Account;

public class ChangePasswordController extends HttpServlet {

    private final CustomerDAO customerDAO = new CustomerDAO();
    private final AccountDAO accountDAO = new AccountDAO();

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

    private String validatePasswordChange(
            String currentPassword,
            String newPassword,
            String confirmPassword) {
        // TODO: implement
        return null;
    }

    private String validateNewPassword(String newPassword) {
        // TODO: implement
        return null;
    }

    @Override
    public String getServletInfo() {
        // TODO: implement
        return null;
    }
}
