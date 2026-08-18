package controller;

import dao.AccountDAO;
import dao.CustomerDAO;
import utils.EmailUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.Random;

public class ForgotPasswordController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Showing trang nhập email
        request.getRequestDispatcher("/views/auth/forgot-password.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String email = request.getParameter("email");

        // Validate cơ bản
        if (email == null || email.trim().isEmpty()) {
            request.setAttribute("errorMessage", "Please enter an email address.");
            request.setAttribute("enteredEmail", email);
            request.getRequestDispatcher("/views/auth/forgot-password.jsp").forward(request, response);
            return;
        }

        email = email.trim().toLowerCase();

        // Kiểm tra định dạng email (hỗ trợ cả tên miền phụ, vd: mail.co.uk)
        if (!email.matches("^[\\w.+-]+@[\\w-]+(\\.[\\w-]+)*\\.[a-zA-Z]{2,}$")) {
            request.setAttribute("errorMessage", "Invalid email format.");
            request.setAttribute("enteredEmail", email);
            request.getRequestDispatcher("/views/auth/forgot-password.jsp").forward(request, response);
            return;
        }

        // Kiểm tra email có tồn tại trong hệ thống không (Customer hoặc Account/Staff)
        CustomerDAO customerDAO = new CustomerDAO();
        AccountDAO  accountDAO  = new AccountDAO();

        boolean existsInCustomer = customerDAO.isEmailExists(email);
        boolean existsInAccount  = accountDAO.isEmailExists(email);

        if (!existsInCustomer && !existsInAccount) {
            request.setAttribute("errorMessage", "This email is not registered.");
            request.setAttribute("enteredEmail", email);
            request.getRequestDispatcher("/views/auth/forgot-password.jsp").forward(request, response);
            return;
        }

        // Sinh OTP 6 số
        String otp = String.format("%06d", new Random().nextInt(999999));
        long   now = System.currentTimeMillis();

        // Save thông tin vào session (dùng chung key với OtpController)
        HttpSession session = request.getSession();
        session.setAttribute("otp_code",      otp);
        session.setAttribute("otp_email",     email);
        session.setAttribute("otp_created",   now);
        session.setAttribute("otp_resend_at", now);
        session.setAttribute("otp_flow",      "forgot"); // ← phân biệt luồng
        session.setAttribute("fp_verified",   false);    // chưa xác thực

        // Gửi email OTP
        try {
            EmailUtil.sendOtp(email, otp);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Could not send the email. Please try again later.");
            request.setAttribute("enteredEmail", email);
            request.getRequestDispatcher("/views/auth/forgot-password.jsp").forward(request, response);
            return;
        }

        // Redirect sang trang nhập OTP (dùng chung trang otp.jsp)
        response.sendRedirect(request.getContextPath() + "/otp");
    }
}