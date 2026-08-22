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

        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("account") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        Account acc = (Account) session.getAttribute("account");
        boolean isCustomer = "customer".equalsIgnoreCase(acc.getRole());

        if (!isCustomer && !isDashboardRequest(request)) {
            response.sendRedirect(request.getContextPath() + "/dashboard/profile/change-password");
            return;
        }

        if (isCustomer) {
            request.getRequestDispatcher(
                    "/views/profile/changePassword.jsp"
            ).forward(request, response);
        } else {
            request.getRequestDispatcher(
                    "/views/profile/changePassword-admin.jsp"
            ).forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession(false);

        if (session == null) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            response.getWriter().write(
                    "{\"success\":false,\"message\":\"Not signed in\"}"
            );
            return;
        }

        Account acc = (Account) session.getAttribute("account");

        if (acc == null) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            response.getWriter().write(
                    "{\"success\":false,\"message\":\"Not signed in\"}"
            );
            return;
        }

        if (!"customer".equalsIgnoreCase(acc.getRole()) && !isDashboardRequest(request)) {
            response.setStatus(HttpServletResponse.SC_FORBIDDEN);
            response.getWriter().write(
                    "{\"success\":false,\"message\":\"Use the protected dashboard endpoint\"}"
            );
            return;
        }

        String currentPassword = request.getParameter("currentPassword");
        String newPassword = request.getParameter("newPassword");
        String confirmPassword = request.getParameter("confirmPassword");

        try (PrintWriter out = response.getWriter()) {

            String validationError = validatePasswordChange(
                    currentPassword,
                    newPassword,
                    confirmPassword
            );

            if (validationError != null) {
                out.write(
                        "{\"success\":false,\"message\":\""
                        + validationError
                        + "\"}"
                );
                return;
            }

            boolean success;

            if ("customer".equalsIgnoreCase(acc.getRole())) {

                success = customerDAO.changePassword(
                        acc.getId(),
                        currentPassword.trim(),
                        newPassword
                );

            } else {

                success = accountDAO.changePassword(
                        acc.getId(),
                        currentPassword.trim(),
                        newPassword
                );
            }

            if (success) {

                session.invalidate();
                out.write(
                        "{\"success\":true,\"message\":\"Password changed successfully\"}"
                );

            } else {

                out.write(
                        "{\"success\":false,\"message\":\"Current password is incorrect\"}"
                );
            }

        } catch (Exception e) {

            e.printStackTrace();

            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);

            response.getWriter().write(
                    "{\"success\":false,\"message\":\"A system error occurred\"}"
            );
        }
    }

    private String validatePasswordChange(
            String currentPassword,
            String newPassword,
            String confirmPassword) {

        if (currentPassword == null || currentPassword.trim().isEmpty()) {
            return "Please enter your current password";
        }

        if (newPassword == null || newPassword.isEmpty()) {
            return "Please enter a new password";
        }

        if (confirmPassword == null || confirmPassword.isEmpty()) {
            return "Please confirm your new password";
        }

        currentPassword = currentPassword.trim();

        // Không cho phép khoảng trắng ở bất kỳ vị trí nào
        if (newPassword.matches(".*\\s.*")) {
            return "Password cannot contain spaces";
        }

        if (confirmPassword.matches(".*\\s.*")) {
            return "Password confirmation cannot contain spaces";
        }

        String error = validateNewPassword(newPassword);

        if (error != null) {
            return error;
        }

        if (currentPassword.equals(newPassword)) {
            return "New password must be different from the current password";
        }

        if (!newPassword.equals(confirmPassword)) {
            return "Passwords do not match";
        }

        return null;
    }

    private boolean isDashboardRequest(HttpServletRequest request) {
        return request.getServletPath().startsWith("/dashboard/");
    }

    private String validateNewPassword(String newPassword) {

        if (newPassword == null || newPassword.isEmpty()) {
            return "Password is required";
        }

        if (newPassword.length() < 8) {
            return "Password must be at least 8 characters";
        }

        if (newPassword.length() > 15) {
            return "Password cannot exceed 15 characters";
        }

        String passwordPattern
                = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[@$!%*?&.#^_+=-])[A-Za-z\\d@$!%*?&.#^_+=-]{8,15}$";

        if (!newPassword.matches(passwordPattern)) {
            return "Password must contain uppercase and lowercase letters, a number, and a special character";
        }

        return null;
    }

    @Override
    public String getServletInfo() {
        return "Change Password Controller";
    }
}
