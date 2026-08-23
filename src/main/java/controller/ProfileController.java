package controller;

import dao.AccountDAO;
import dao.CustomerDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.time.LocalDate;
import java.time.Period;
import model.Account;
import model.Customer;

public class ProfileController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("account") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        Account loginUser = (Account) session.getAttribute("account");
        boolean isCustomer = "customer".equalsIgnoreCase(loginUser.getRole());
        String profilePath = isCustomer ? "/profile" : "/dashboard/profile";

        if (!isCustomer && !isDashboardRequest(request)) {
            response.sendRedirect(request.getContextPath() + profilePath + "?id=" + loginUser.getId());
            return;
        }

        String idParam = request.getParameter("id");

        if (idParam == null || idParam.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + profilePath + "?id=" + loginUser.getId());
            return;
        }
        idParam = idParam.trim();
        if (!idParam.matches("^[1-9]\\d*$")) {
            request.getRequestDispatcher("/views/error/404.jsp")
                    .forward(request, response);
            return;
        }

        int id;
        try {
            id = Integer.parseInt(idParam);
        } catch (NumberFormatException ex) {
            request.getRequestDispatcher("/views/error/404.jsp")
                    .forward(request, response);
            return;
        }

        if (id != loginUser.getId()) {
            request.getRequestDispatcher("/views/error/404.jsp")
                    .forward(request, response);
            return;
        }
        if (isCustomer) {
            CustomerDAO customerDao = new CustomerDAO();
            Customer customer = customerDao.getCustomerById(id);
            request.setAttribute("customer", customer);
            request.getRequestDispatcher("/views/profile/profile.jsp").forward(request, response);
            return;
        }
        AccountDAO accountDao = new AccountDAO();
        Account account = accountDao.getStaffById(id);
        request.setAttribute("account", account);
        request.getRequestDispatcher("/views/profile/profile-admin.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("account") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        Account acc = (Account) session.getAttribute("account");
        boolean isCustomer = "customer".equalsIgnoreCase(acc.getRole());
        String profileUrl = request.getContextPath()
                + (isCustomer ? "/profile?id=" : "/dashboard/profile?id=")
                + acc.getId();

        if (!isCustomer && !isDashboardRequest(request)) {
            response.sendRedirect(profileUrl);
            return;
        }

        String fullname = safeTrim(request.getParameter("fullname"));
        String phone = safeTrim(request.getParameter("phone"));
        String gender = request.getParameter("gender");
        String dob = request.getParameter("dob");
        boolean fullnameChanged = !fullname.equals(safeTrim(acc.getFullname()));
        if (fullname.isEmpty()) {
            session.setAttribute("error", "Full name is required");
            response.sendRedirect(profileUrl);
            return;
        }
        if (fullnameChanged && fullname.matches(".*\\s{2,}.*")) {
            session.setAttribute("error", "Full name cannot contain consecutive spaces");
            response.sendRedirect(profileUrl);
            return;
        }
        // Chỉ chứa chữ cái, các từ cách nhau đúng 1 dấu cách, tối thiểu 2 từ (vd: "Duy
        // Minh")
        if (fullnameChanged
                && (!fullname.matches("^[\\p{L}]+( [\\p{L}]+)+$") || fullname.length() > 50)) {
            session.setAttribute("error", "Full name must contain at least two words, use letters only, and have single spaces between words");
            response.sendRedirect(profileUrl);
            return;
        }

        if (phone == null)
            phone = "";
        if (!phone.matches("^0\\d{9}$")) {
            session.setAttribute("error", "Phone number must contain 10 digits and start with 0");
            response.sendRedirect(profileUrl);
            return;
        }

        if (isCustomer) {
            dob = safeTrim(dob);
            if (!dob.isEmpty()) {
                try {
                    LocalDate birthDate = LocalDate.parse(dob);
                    LocalDate today = LocalDate.now();
                    if (birthDate.isAfter(today)) {
                        session.setAttribute("error", "Invalid date of birth");
                        response.sendRedirect(profileUrl);
                        return;
                    }
                    int age = Period.between(birthDate, today).getYears();
                    if (age < 18 || age > 120) {
                        session.setAttribute("error", "You must be between 18 and 119 years old");
                        response.sendRedirect(profileUrl);
                        return;
                    }
                } catch (Exception ex) {
                    session.setAttribute("error", "Invalid date-of-birth format");
                    response.sendRedirect(profileUrl);
                    return;
                }
            } else {
                dob = null;
            }

            CustomerDAO dao = new CustomerDAO();
            boolean success = dao.updateCustomer(
                    acc.getId(),
                    fullname,
                    phone,
                    gender,
                    dob);

            if (success) {
                Customer updated = dao.getCustomerById(acc.getId());
                if (updated != null) {
                    Account refreshed = new Account(
                            updated.getCustomerID(),
                            updated.getFullname(),
                            updated.getEmail(),
                            updated.getPhone(),
                            updated.getRole(),
                            updated.getStatus());
                    session.setAttribute("account", refreshed);
                }
                session.removeAttribute("error");
                session.setAttribute("message", "Information updated successfully!");
            } else {
                session.removeAttribute("message");
                session.setAttribute("error", "Update failed!");
            }

            response.sendRedirect(profileUrl);
            return;
        }
        AccountDAO accountDao = new AccountDAO();
        boolean success = accountDao.updateStaff(
                acc.getId(),
                fullname,
                acc.getEmail(),
                phone,
                acc.getRole());

        if (success) {
            Account updated = accountDao.getStaffById(acc.getId());
            if (updated != null) {
                session.setAttribute("account", updated);
            }
            session.removeAttribute("error");
            session.setAttribute("message", "Information updated successfully!");
        } else {
            session.removeAttribute("message");
            session.setAttribute("error", "Update failed!");
        }
        response.sendRedirect(profileUrl);
    }

    private boolean isDashboardRequest(HttpServletRequest request) {
        return request.getServletPath().startsWith("/dashboard/");
    }

    private String safeTrim(String s) {
        return s == null ? "" : s.trim();
    }
}
