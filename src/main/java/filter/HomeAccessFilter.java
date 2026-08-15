package filter;

import java.io.IOException;
import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.FilterConfig;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Account;

/**
 * Chặn admin/staff không cho vào trang /home (dành cho customer).
 */
@WebFilter(filterName = "HomeAccessFilter", urlPatterns = {"/home"})
public class HomeAccessFilter implements Filter {

    private FilterConfig filterConfig = null;
    private static final boolean debug = true;

    @Override
    public void doFilter(ServletRequest request, ServletResponse response,
            FilterChain chain) throws IOException, ServletException {

        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse res = (HttpServletResponse) response;

        HttpSession session = req.getSession(false);
        Account account = (session != null)
                ? (Account) session.getAttribute("account")
                : null;

        boolean isStaffOrAdmin = account != null
                && ("admin".equals(account.getRole()) || "staff".equals(account.getRole()));

        if (isStaffOrAdmin) {
            if (debug) {
                log("HomeAccessFilter: role=" + account.getRole() + " bi chan vao /home, redirect ve dashboard");
            }
            res.sendRedirect(req.getContextPath() + "/dashboard/account-management");
            return;
        }

        chain.doFilter(request, response);
    }

    @Override
    public void init(FilterConfig filterConfig) {
        this.filterConfig = filterConfig;
    }

    @Override
    public void destroy() {
        this.filterConfig = null;
    }

    public void log(String msg) {
        if (filterConfig != null) {
            filterConfig.getServletContext().log(msg);
        }
    }
}