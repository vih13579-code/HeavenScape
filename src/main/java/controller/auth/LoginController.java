package controller.auth;

import dao.AccountDAO;
import dao.CartDAO;
import model.Account;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;
import model.CartItem;

public class LoginController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if ("1".equals(request.getParameter("locked"))) {
            request.setAttribute(
                    "errorMessage",
                    "Your account has been disabled. Please contact an administrator."
            );
        }
        request.getRequestDispatcher("/views/auth/login.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        String email = request.getParameter("email");
        String password = request.getParameter("password");

        // Validate input phía server 
        String validationError = validateInput(email, password);
        if (validationError != null) {
            request.setAttribute("errorMessage", validationError);
            request.setAttribute("enteredEmail", email);
            request.getRequestDispatcher("/views/auth/login.jsp").forward(request, response);
            return;
        }

        AccountDAO accountDAO = new AccountDAO();
        Account acc = accountDAO.checkLogin(email.trim(), password);

        if (acc != null) {
            if ("inactive".equalsIgnoreCase(acc.getStatus())) {
                request.setAttribute(
                        "errorMessage",
                        "Your account has been disabled. Please contact an administrator."
                );
                request.setAttribute("enteredEmail", email);
                request.getRequestDispatcher("/views/auth/login.jsp")
                        .forward(request, response);
                return;
            }
            HttpSession session = request.getSession();
            session.setAttribute("account", acc);
            session.setMaxInactiveInterval(30 * 60);
            if ("customer".equals(acc.getRole())) {
                CartDAO cartDAO = new CartDAO();
                List<CartItem> items = cartDAO.getCartItems(acc.getId());

                int total = 0;
                for (CartItem item : items) {
                    total += item.getQuantity();
                }
                session.setAttribute("cartCount", total);
            }

            Cookie emailCookie = new Cookie("savedEmail", email);
            emailCookie.setMaxAge(24 * 60 * 60);
            emailCookie.setHttpOnly(true);
            emailCookie.setPath("/");
            response.addCookie(emailCookie);

            // Thông báo cho toast.jsp hiện popup "Log In thành công" ở trang tiếp theo
            session.setAttribute("successMessage", "Signed in successfully! Welcome " + acc.getFullname() + ".");

            if (acc.getRole().equals("admin") || acc.getRole().equals("staff")) {
                response.sendRedirect(request.getContextPath() + "/dashboard");
            } else {
                response.sendRedirect(request.getContextPath() + "/home");
            }
        } else {
            request.setAttribute("errorMessage", "Incorrect email or password!");
            request.setAttribute("enteredEmail", email);
            request.getRequestDispatcher("/views/auth/login.jsp").forward(request, response);
        }
    }

    /** Kiểm tra dữ liệu nhập vào, trả về thông báo lỗi cụ thể hoặc null nếu hợp lệ. */
    private String validateInput(String email, String password) {
        if (email == null || email.trim().isEmpty()) {
            return "Please enter an email address.";
        }
        if (!email.trim().matches("^[\\w.+-]+@[\\w-]+(\\.[\\w-]+)*\\.[a-zA-Z]{2,}$")) {
            return "Invalid email format.";
        }
        if (password == null || password.isEmpty()) {
            return "Please enter a password.";
        }
        return null;
    }
}
