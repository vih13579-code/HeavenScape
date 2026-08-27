package controller;

import dao.AccountDAO;
import dao.CustomerDAO;
import model.Account;
import utils.EmailUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.Random;
import utils.EmailUtil;

public class OtpController extends HttpServlet {

    private static final long OTP_EXPIRE_MS = 5 * 60 * 1000L; // 5 phút
    private static final long RESEND_COOLDOWN_MS = 60 * 1000L; // chống spam: 60 giây
    private static final int MAX_WRONG_ATTEMPTS = 5; // giới hạn số lần nhập sai

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("otp_code") == null) {
            // Phân biệt luồng để redirect đúng chỗ
            String flow = (session != null) ? (String) session.getAttribute("otp_flow") : null;
            if ("forgot".equals(flow)) {
                response.sendRedirect(request.getContextPath() + "/forgot-password");
            } else if ("change_email".equals(flow)) {
                response.sendRedirect(request.getContextPath() + "/profile");
            } else {
                response.sendRedirect(request.getContextPath() + "/register");
            }
            return;
        }
        request.getRequestDispatcher("/views/auth/otp.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        if ("resend".equals(action)) {
            handleResend(request, response);
        } else {
            handleVerify(request, response);
        }
    }

    // Xử lý thành công khi đổi mật khẩu
    private void handleChangePasswordSuccess(HttpServletRequest request, HttpServletResponse response,
            HttpSession session)
            throws IOException {

        Integer targetId = (Integer) session.getAttribute("otp_target_id");
        String targetRole = (String) session.getAttribute("otp_target_role");
        String email = (String) session.getAttribute("otp_email");
        String currentPassword = (String) session.getAttribute("otp_current_password");
        String newPassword = (String) session.getAttribute("otp_new_password");

        if (targetId == null || targetRole == null || email == null || currentPassword == null || newPassword == null) {
            clearOtpAttributes(session, true);
            session.setAttribute("otp_error", "Invalid verification session. Please try again.");
            response.sendRedirect(request.getContextPath() + "/profile/change-password");
            return;
        }
        boolean success;
        if ("customer".equalsIgnoreCase(targetRole)) {

            success = new CustomerDAO().changePassword(targetId, currentPassword, newPassword);
        } else {
            success = new AccountDAO().changePassword(targetId, currentPassword, newPassword);
        }

        if (!success) {
            clearOtpAttributes(session, true);
            session.setAttribute("error", "Current password is incorrect. Password was not changed.");
            response.sendRedirect(request.getContextPath() + "/profile/change-password");
            return;
        }
        try {
            EmailUtil.sendPasswordChangeNotification(email);
        } catch (Exception e) {
            e.printStackTrace();

        }
        clearOtpAttributes(session, true);
        session.invalidate();

        HttpSession newSession = request.getSession(true);
        newSession.setAttribute(
                "successMessage",
                "Password changed successfully! Please sign in again.");

        response.sendRedirect(request.getContextPath() + "/login");
    }

    // OTP Verification users dùng nhập
    private void handleVerify(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("otp_code") == null) {
            response.sendRedirect(request.getContextPath() + "/register");
            return;
        }

        String inputOtp = request.getParameter("otp");
        String savedOtp = (String) session.getAttribute("otp_code");
        Long createdAt = (Long) session.getAttribute("otp_created");
        String flow = (String) session.getAttribute("otp_flow"); // "register" hoặc "forgot"

        // Kiểm tra hết hạn
        if (System.currentTimeMillis() - createdAt > OTP_EXPIRE_MS) {
            invalidateCurrentOtp(session);
            session.setAttribute("otp_error", "The OTP has expired. Select \"Resend Code\" to receive a new one.");
            request.getRequestDispatcher("/views/auth/otp.jsp").forward(request, response);
            return;
        }

        // Kiểm tra OTP đúng không
        if (!savedOtp.equals(inputOtp)) {
            Integer attempts = (Integer) session.getAttribute("otp_attempts");
            attempts = (attempts == null) ? 1 : attempts + 1;
            session.setAttribute("otp_attempts", attempts);

            if (attempts >= MAX_WRONG_ATTEMPTS) {
                // Nhập sai quá số lần cho phép thì hủy mã hiện tại, bắt buộc gửi lại mã mới
                invalidateCurrentOtp(session);
                session.setAttribute("otp_error",
                        "You entered an incorrect OTP more than " + MAX_WRONG_ATTEMPTS + " times. "
                                + "Select \"Resend Code\" to receive a new one.");
            } else {
                int remaining = MAX_WRONG_ATTEMPTS - attempts;
                session.setAttribute("otp_error",
                        "Incorrect OTP. You have " + remaining + " attempts remaining.");
            }
            request.getRequestDispatcher("/views/auth/otp.jsp").forward(request, response);
            return;
        }

        // đổi email (customer lẫn admin/staff)
        if ("change_email".equals(flow)) {
            handleChangeEmailSuccess(request, response, session);
            return;
        }
        // đổi mật khẩu (VinhLee)

        if ("change_password".equals(flow)) {
            handleChangePasswordSuccess(request, response, session);
            return;
        }

        // quên mk
        if ("forgot".equals(flow)) {
            session.setAttribute("fp_verified", true);
            clearOtpAttributes(session, false);
            response.sendRedirect(request.getContextPath() + "/reset-password");
            return;
        }

        // của đăng ký
        String fullname = (String) session.getAttribute("otp_fullname");
        String email = (String) session.getAttribute("otp_email");
        String phone = (String) session.getAttribute("otp_phone");
        String password = (String) session.getAttribute("otp_password");

        CustomerDAO dao = new CustomerDAO();
        boolean success = dao.registerCustomer(fullname, email, phone, password);

        clearOtpAttributes(session, true);

        if (success) {
            session.setAttribute("register_success", "Registration successful! Please sign in.");
            response.sendRedirect(request.getContextPath() + "/login");
        } else {
            request.setAttribute("errorMessage", "Could not create the account. Please try again.");
            request.getRequestDispatcher("/views/auth/register.jsp").forward(request, response);
        }
    }

    // Update email trong DB + session sau khi users dùng xác thực OTP đúng
    private void handleChangeEmailSuccess(HttpServletRequest request, HttpServletResponse response,
            HttpSession session) throws IOException {

        String newEmail = (String) session.getAttribute("otp_email");
        Integer targetId = (Integer) session.getAttribute("otp_target_id");
        String targetRole = (String) session.getAttribute("otp_target_role");

        // Dữ liệu phiên bị thiếu/hỏng thì không thực hiện, tránh NPE hoặc cập nhật sai
        // users
        if (newEmail == null || targetId == null || targetRole == null) {
            clearOtpAttributes(session, true);
            session.setAttribute("otp_error", "Invalid verification session. Please try again.");
            response.sendRedirect(request.getContextPath() + "/profile");
            return;
        }

        boolean success;
        if ("customer".equalsIgnoreCase(targetRole)) {
            success = new CustomerDAO().updateEmail(targetId, newEmail);
        } else {
            success = new AccountDAO().updateEmail(targetId, newEmail);
        }

        clearOtpAttributes(session, true);

        if (success) {
            // Đồng bộ lại session để hiển thị email mới ngay, không cần đăng nhập lại
            Account current = (Account) session.getAttribute("account");
            if (current != null) {
                Account refreshed = new Account(
                        current.getId(),
                        current.getFullname(),
                        newEmail,
                        current.getPhone(),
                        current.getRole(),
                        current.getStatus());
                session.setAttribute("account", refreshed);
            }
            session.setAttribute("message", "Email changed successfully!");
        } else {
            session.setAttribute("error", "Could not change the email. Please try again.");
        }

        response.sendRedirect(request.getContextPath() + "/profile?id=" + targetId);
    }

    // Gửi lại OTP vs chống spam 60s
    private void handleResend(HttpServletRequest request, HttpServletResponse response)
            throws IOException, ServletException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("otp_email") == null) {
            response.sendRedirect(request.getContextPath() + "/register");
            return;
        }

        Long resendAt = (Long) session.getAttribute("otp_resend_at");
        long now = System.currentTimeMillis();

        if (resendAt != null && now - resendAt < RESEND_COOLDOWN_MS) {
            long waitSec = (RESEND_COOLDOWN_MS - (now - resendAt)) / 1000;
            session.setAttribute("otp_error", "Please wait " + waitSec + " seconds before requesting another code.");
            request.getRequestDispatcher("/views/auth/otp.jsp").forward(request, response);
            return;
        }

        String newOtp = String.format("%06d", new Random().nextInt(999999));
        String email = (String) session.getAttribute("otp_email");

        session.setAttribute("otp_code", newOtp);
        session.setAttribute("otp_created", now);
        session.setAttribute("otp_resend_at", now);
        session.removeAttribute("otp_error");
        session.removeAttribute("otp_attempts"); // reset số lần nhập sai khi có mã mới

        try {
            String flow = (String) session.getAttribute("otp_flow");

            if ("change_password".equals(flow)) {
                EmailUtil.sendChangePasswordOtp(email, newOtp);
            } else {
                EmailUtil.sendOtp(email, newOtp);
            }

            session.setAttribute(
                    "otp_success",
                    "A new OTP was sent to your email.");
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute(
                    "otp_error",
                    "Could not send the email. Please try again.");
        }

        request.getRequestDispatcher("/views/auth/otp.jsp").forward(request, response);
    }

    private void clearOtpAttributes(HttpSession session, boolean keepEmail) {
        session.removeAttribute("otp_code");
        session.removeAttribute("otp_created");
        session.removeAttribute("otp_resend_at");
        session.removeAttribute("otp_error");
        session.removeAttribute("otp_success");
        session.removeAttribute("otp_flow");
        session.removeAttribute("otp_fullname");
        session.removeAttribute("otp_phone");
        session.removeAttribute("otp_password");
        session.removeAttribute("otp_attempts");
        session.removeAttribute("otp_target_id");
        session.removeAttribute("otp_target_role");
        session.removeAttribute("otp_current_password");
        session.removeAttribute("otp_new_password");
        if (keepEmail) {
            session.removeAttribute("otp_email");
        }
    }

    private void invalidateCurrentOtp(HttpSession session) {
        session.removeAttribute("otp_code");
        session.removeAttribute("otp_created");
        session.removeAttribute("otp_attempts");
    }
}
