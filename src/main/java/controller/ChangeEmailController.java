package controller;

import dao.AccountDAO;
import dao.CustomerDAO;
import utils.EmailUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.Random;
import model.Account;
import java.util.Random;
import utils.EmailUtil;

public class ChangeEmailController extends HttpServlet {

    private static final long RESEND_COOLDOWN_MS = 60 * 1000L;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("account") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        Account acc = (Account) session.getAttribute("account");

        if (!"customer".equalsIgnoreCase(acc.getRole())) {
            session.setAttribute("error", "Staff and administrator email addresses cannot be changed.");
            response.sendRedirect(request.getContextPath() + "/profile?id=" + acc.getId());
            return;
        }

        String newEmail = request.getParameter("newEmail");
        newEmail = (newEmail == null) ? "" : newEmail.trim().toLowerCase();

        if (newEmail.isEmpty()) {
            session.setAttribute("error", "Please enter a new email address.");
            response.sendRedirect(request.getContextPath() + "/profile?id=" + acc.getId());
            return;
        }

        if (!newEmail.matches("^[\\w.+-]+@[\\w-]+(\\.[\\w-]+)*\\.[a-zA-Z]{2,}$")) {
            session.setAttribute("error", "Invalid email format.");
            response.sendRedirect(request.getContextPath() + "/profile?id=" + acc.getId());
            return;
        }

        if (newEmail.equalsIgnoreCase(acc.getEmail())) {
            session.setAttribute("error", "The new email must be different from the current email.");
            response.sendRedirect(request.getContextPath() + "/profile?id=" + acc.getId());
            return;
        }

        CustomerDAO customerDAO = new CustomerDAO();
        AccountDAO accountDAO = new AccountDAO();
        if (customerDAO.isEmailExists(newEmail) || accountDAO.isEmailExists(newEmail)) {
            session.setAttribute("error", "This email is already used by another account.");
            response.sendRedirect(request.getContextPath() + "/profile?id=" + acc.getId());
            return;
        }

        Long lastSentAt = (Long) session.getAttribute("otp_resend_at");
        String currentFlow = (String) session.getAttribute("otp_flow");
        long now = System.currentTimeMillis();
        if ("change_email".equals(currentFlow) && lastSentAt != null
                && now - lastSentAt < RESEND_COOLDOWN_MS) {
            long waitSec = (RESEND_COOLDOWN_MS - (now - lastSentAt)) / 1000;
            session.setAttribute("error", "Please wait " + waitSec + " seconds before trying again.");
            response.sendRedirect(request.getContextPath() + "/profile?id=" + acc.getId());
            return;
        }

        String otp = String.format("%06d", new Random().nextInt(999999));

        session.setAttribute("otp_code", otp);
        session.setAttribute("otp_email", newEmail);         
        session.setAttribute("otp_created", now);
        session.setAttribute("otp_resend_at", now);
        session.setAttribute("otp_flow", "change_email");
        session.setAttribute("otp_target_id", acc.getId());
        session.setAttribute("otp_target_role", acc.getRole());
        session.removeAttribute("otp_attempts");

        try {
            EmailUtil.sendOtp(newEmail, otp);
        } catch (Exception e) {
            e.printStackTrace();
            session.removeAttribute("otp_code");
            session.removeAttribute("otp_flow");
            session.setAttribute("error", "Could not send the verification email. Please try again later.");
            response.sendRedirect(request.getContextPath() + "/profile?id=" + acc.getId());
            return;
        }

        response.sendRedirect(request.getContextPath() + "/otp");


    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.sendRedirect(request.getContextPath() + "/profile");
    }
}
