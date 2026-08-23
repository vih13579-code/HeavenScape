package controller;

import dao.CustomerDAO;
import utils.EmailUtil;
import java.io.IOException;
import java.util.Random;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

public class RegisterController extends HttpServlet {

    private final CustomerDAO customerDAO = new CustomerDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/views/auth/register.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        // trim
        String fullname = trim(request.getParameter("fullname"));
        String email = trim(request.getParameter("email"));
        String phone = trim(request.getParameter("phone"));
        String password = trim(request.getParameter("password"));
        String confirmPassword = trim(request.getParameter("confirmPassword"));

        // Validate dữ liệu
        String error = validate(fullname, email, phone, password, confirmPassword);
        if (error != null) {
            request.setAttribute("errorMessage", error);
            request.getRequestDispatcher("/views/auth/register.jsp").forward(request, response);
            return;
        }

        // Kiểm tra email đã tồn tại
        if (customerDAO.isEmailExists(email)) {
            request.setAttribute("errorMessage", "This email is already in use. Please use another email address.");
            request.getRequestDispatcher("/views/auth/register.jsp").forward(request, response);
            return;
        }

        // Sinh mã OTP 6 số
        String otp = String.format("%06d", new Random().nextInt(999999));

        // Save thông tin vào session để OtpController xử lý tiếp
        HttpSession session = request.getSession();
        session.setAttribute("otp_fullname", fullname);
        session.setAttribute("otp_email", email);
        session.setAttribute("otp_phone", phone);
        session.setAttribute("otp_password", password);
        session.setAttribute("otp_code", otp);
        session.setAttribute("otp_created", System.currentTimeMillis());

        // Gửi OTP qua email
        try {
            EmailUtil.sendOtp(email, otp);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Could not send the OTP email. Please try again.");
            request.getRequestDispatcher("/views/auth/register.jsp").forward(request, response);
            return;
        }

        // Chuyển sang trang nhập OTP
        response.sendRedirect(request.getContextPath() + "/otp");
    }

    private String validate(String fullname, String email, String phone,
            String password, String confirmPassword) {
        // Kiểm tra không được bỏ trống
        if (fullname == null || fullname.isEmpty()) {
            return "Full name is required.";
        }

        String[] nameParts = fullname.trim().split("\\s+");
        if (nameParts.length < 2) {
            return "Please enter a full name with at least two words.";
        }
        if (!fullname.matches("^[\\p{L}\\s]+$")) {
            return "Full name cannot contain numbers or special characters.";
        }
        if (email == null || email.isEmpty()) {
            return "Email is required.";
        }
        if (phone == null || phone.isEmpty()) {
            return "Phone number is required.";
        }
        if (password == null || password.isEmpty()) {
            return "Password is required.";
        }
        if (fullname.length() < 2 || fullname.length() > 50) {
            return "Full name must be 2–50 characters long.";
        }
        if (confirmPassword == null || confirmPassword.isEmpty()) {
            return "Password confirmation is required.";
        }

        // Kiểm tra định dạng email (hỗ trợ cả tên miền phụ, vd: mail.co.uk)
        if (!email.matches("^[\\w.+-]+@[\\w-]+(\\.[\\w-]+)*\\.[a-zA-Z]{2,}$")) {
            return "Invalid email format.";
        }

        // Kiểm tra định dạng số điện thoại Vietnam
        if (!phone.matches("^(0[35789])\\d{8}$")) {
            return "Invalid phone number format.";
        }

        // Kiểm tra độ dài mật khẩu 8 - 15 ký tự
        if (password.length() < 8 || password.length() > 15) {
            return "Password must be 8–15 characters long.";
        }

        // Kiểm tra mật khẩu phải có đủ chữ hoa, chữ thường, số, ký tự đặc biệt
        if (!password.matches(".*[A-Z].*")) {
            return "Password must contain at least one uppercase letter.";
        }
        if (!password.matches(".*[a-z].*")) {
            return "Password must contain at least one lowercase letter.";
        }
        if (!password.matches(".*[0-9].*")) {
            return "Password must contain at least one number.";
        }
        if (!password.matches(".*[!@#$%^&*()_+\\-=\\[\\]{};':\"\\\\|,.<>\\/?].*")) {
            return "Password must contain at least one special character.";
        }

        // Kiểm tra xác nhận mật khẩu
        if (!password.equals(confirmPassword)) {
            return "Passwords do not match.";
        }

        return null;
    }

    private String trim(String s) {
        return s != null ? s.trim() : null;
    }
}
