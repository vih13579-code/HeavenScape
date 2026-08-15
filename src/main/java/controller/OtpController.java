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

public class OtpController extends HttpServlet {

    private static final long OTP_EXPIRE_MS      = 5 * 60 * 1000L; // 5 phút
    private static final long RESEND_COOLDOWN_MS = 60 * 1000L;     // chống spam: 60 giây
    private static final int  MAX_WRONG_ATTEMPTS  = 5;              // giới hạn số lần nhập sai

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

    // OTP Verification users dùng nhập 
    private void handleVerify(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // TODO: implement
    }

    // Update email trong DB + session sau khi users dùng xác thực OTP đúng
    private void handleChangeEmailSuccess(HttpServletRequest request, HttpServletResponse response,
            HttpSession session) throws IOException {
        // TODO: implement
    }

    // Gửi lại OTP vs chống spam 60s
    private void handleResend(HttpServletRequest request, HttpServletResponse response)
            throws IOException, ServletException {
        // TODO: implement
    }

    private void clearOtpAttributes(HttpSession session, boolean keepEmail) {
        // TODO: implement
    }

    private void invalidateCurrentOtp(HttpSession session) {
        // TODO: implement
    }
}
