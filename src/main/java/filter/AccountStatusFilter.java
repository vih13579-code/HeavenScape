package filter;

import dao.AccountDAO;
import java.io.IOException;
import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Account;

/**
 * Revalidates authenticated sessions against the database so locking an
 * account also terminates sessions that were created before the lock.
 */
@WebFilter(filterName = "AccountStatusFilter", urlPatterns = {"/*"})
public class AccountStatusFilter implements Filter {

    @Override
    public void doFilter(ServletRequest request, ServletResponse response,
            FilterChain chain) throws IOException, ServletException {

        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse res = (HttpServletResponse) response;

        if (isStaticResource(req)) {
            chain.doFilter(request, response);
            return;
        }

        HttpSession session = req.getSession(false);
        Account sessionAccount = session == null
                ? null
                : (Account) session.getAttribute("account");

        if (sessionAccount != null) {
            // Force Back/Forward to reach the server so a newly applied lock
            // cannot be bypassed by a previously cached authenticated page.
            preventCaching(res);

            Account currentAccount = new AccountDAO().getAccountById(
                    sessionAccount.getId(), sessionAccount.getRole());

            if (currentAccount == null
                    || "inactive".equalsIgnoreCase(currentAccount.getStatus())) {
                session.invalidate();
                res.sendRedirect(req.getContextPath() + "/login?locked=1");
                return;
            }

            // Keep role/profile/status changes synchronized with the live session.
            session.setAttribute("account", currentAccount);
        }

        chain.doFilter(request, response);
    }

    private boolean isStaticResource(HttpServletRequest request) {
        String path = request.getRequestURI().substring(request.getContextPath().length());
        return path.startsWith("/assets/") || "/favicon.ico".equals(path);
    }

    private void preventCaching(HttpServletResponse response) {
        response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
        response.setHeader("Pragma", "no-cache");
        response.setDateHeader("Expires", 0);
    }
}
