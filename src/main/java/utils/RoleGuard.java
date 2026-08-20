package utils;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Account;

import java.io.IOException;

public final class RoleGuard {

    private RoleGuard() {
    }

    public static Account requireStaff(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("account") == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return null;
        }
        Account acc = (Account) session.getAttribute("account");
        if (!"staff".equals(acc.getRole())) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return null;
        }
        return acc;
    }

    public static Account getAccount(HttpServletRequest req) {
        HttpSession session = req.getSession(false);
        if (session == null) {
            return null;
        }
        return (Account) session.getAttribute("account");
    }

    public static boolean isStaff(Account acc) {
        return acc != null && "staff".equals(acc.getRole());
    }
}
