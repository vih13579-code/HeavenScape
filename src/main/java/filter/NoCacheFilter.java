package filter;

import java.io.IOException;
import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.FilterConfig;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletResponse;

/**
 * Chặn trình duyệt cache lại các trang nhạy cảm (dashboard, home, login...).
 * Đảm bảo khi bấm Back/Forward, trình duyệt phải gọi lại server thay vì
 * hiển thị bản đã lưu trong cache -> để các filter phân quyền luôn được chạy.
 */
@WebFilter(filterName = "NoCacheFilter", urlPatterns = {
    "/dashboard/*",
    "/home",
    "/login"
})
public class NoCacheFilter implements Filter {

    private FilterConfig filterConfig = null;

    @Override
    public void doFilter(ServletRequest request, ServletResponse response,
            FilterChain chain) throws IOException, ServletException {

        HttpServletResponse res = (HttpServletResponse) response;

        res.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
        res.setHeader("Pragma", "no-cache");
        res.setDateHeader("Expires", 0);

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
}