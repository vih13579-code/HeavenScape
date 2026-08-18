package controller;

import dao.AccountDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Account;
import utils.EmailUtil;

public class CreateStaffController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        Account loginUser = (Account) session.getAttribute("account");
        if (loginUser == null || !loginUser.getRole().equals("admin")) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        request.setAttribute("mode", "add");
        request.getRequestDispatcher("/views/admin/account/create-staff.jsp")
                .forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession(false);
        if (session == null) {
            response.setStatus(401);
            response.getWriter().write("{\"success\":false,\"message\":\"Not signed in\"}");
            return;
        }
        Account loginUser = (Account) session.getAttribute("account");
        if (loginUser == null || !loginUser.getRole().equals("admin")) {
            response.setStatus(403);
            response.getWriter().write("{\"success\":false,\"message\":\"You do not have permission to perform this action\"}");
            return;
        }
        AccountDAO dao = new AccountDAO();
        try (PrintWriter out = response.getWriter()) {
            String mode = request.getParameter("mode");
            String fullname = request.getParameter("fullname");
            String email = request.getParameter("email");
            String phone = request.getParameter("phone");
            String role = request.getParameter("role");
            String password = request.getParameter("password");
            String status = request.getParameter("status");

            // Validate bắt buộc
            if (fullname == null || fullname.trim().isEmpty()) {
                out.write("{\"success\":false,\"message\":\"Please enter a full name\"}");
                return;
            }
            if (email == null || email.trim().isEmpty()) {
                out.write("{\"success\":false,\"message\":\"Please enter an email address\"}");
                return;
            }
            if (role == null || role.trim().isEmpty()) {
                out.write("{\"success\":false,\"message\":\"Please select a role\"}");
                return;
            }
            // Chỉ cho phép tạo staff hoặc admin
            if (!role.equals("staff") && !role.equals("admin")) {
                out.write("{\"success\":false,\"message\":\"Invalid role\"}");
                return;
            }
            if (password == null || password.trim().isEmpty()) {
                out.write("{\"success\":false,\"message\":\"Please enter a password\"}");
                return;
            }
            if (password.length() < 6) {
                out.write("{\"success\":false,\"message\":\"Password must be at least 6 characters\"}");
                return;
            }
            if (phone == null || phone.trim().isEmpty()) {
                out.write("{\"success\":false,\"message\":\"Please enter a phone number\"}");
                return;
            }

            String phoneError = validatePhone(phone);
            if (phoneError != null) {
                out.write("{\"success\":false,\"message\":\"" + phoneError + "\"}");
                return;
            }
            // Default status = active nếu không truyền
            if (status == null || status.isEmpty()) {
                status = "active";
            }

            if (dao.isEmailExists(email.trim())) {
                out.write("{\"success\":false,\"message\":\"This email already exists\"}");
                return;
            }

            if ("add".equals(mode)) {
                boolean ok = dao.registerStaff(
                        fullname.trim(),
                        email.trim(),
                        phone.trim(),
                        password,
                        role.trim(),
                        status
                );
                if (ok) {
                    try {
                        EmailUtil.sendStaffAccount(
                                email.trim(),
                                fullname.trim(),
                                email.trim(), // username hiện tại
                                password
                        );
                    } catch (Exception e) {
                        e.printStackTrace();
                    }

                    out.write("{\"success\":true,\"message\":\"Account created successfully\"}");
                } else {
                    out.write("{\"success\":false,\"message\":\"Could not create the account. Please try again.\"}");
                }
            } else {
                out.write("{\"success\":false,\"message\":\"Invalid action\"}");
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(500);
            response.getWriter().write("{\"success\":false,\"message\":\"Server error: " + e.getMessage() + "\"}");
        }
    }

    private String validatePhone(String phone) {
        if (phone == null || phone.trim().isEmpty()) {
            return "Please enter a phone number";
        }

        String trimmedPhone = phone.trim();

        // Chỉ cho phép số, +, -, khoảng trắng, ()
        if (!trimmedPhone.matches("^[0-9+\\-\\s\\(\\)]*$")) {
            return "Phone number contains invalid characters";
        }

        // Loại bỏ khoảng trắng, dấu -, ()
        String normalized = trimmedPhone.replaceAll("[\\s\\-\\(\\)]", "");

        // Kiểm tra định dạng Vietnam
        if (!normalized.matches("^(0|\\+84)[0-9]{9,10}$")) {
            return "The phone number is invalid. It must start with 0 or +84";
        }

        String digitsOnly = normalized.replaceAll("[^0-9]", "");

        if (digitsOnly.length() < 10 || digitsOnly.length() > 11) {
            return "Phone number must contain 10–11 digits";
        }

        return null;
    }

    @Override
    public String getServletInfo() {
        return "Create Staff Controller";
    }
}
