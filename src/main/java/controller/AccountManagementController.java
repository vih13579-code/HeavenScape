package controller;

import dao.AccountDAO;
import dao.CustomerDAO;
import dao.OrderDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Account;

public class AccountManagementController extends HttpServlet {

    private CustomerDAO customerDAO;
    private AccountDAO accountDAO;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        Account loginUser = (session != null) ? (Account) session.getAttribute("account") : null;

        if (loginUser == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        customerDAO = new CustomerDAO();
        accountDAO = new AccountDAO();

        String keyword = nvl(request.getParameter("keyword"), "");
        String role = nvl(request.getParameter("role"), "");
        String status = nvl(request.getParameter("status"), "");

        int pageSize = 10;
        int currentPage = 1;
        try {
            String p = request.getParameter("page");
            if (p != null) {
                currentPage = Math.max(1, Integer.parseInt(p));
            }
        } catch (Exception ignored) {
        }

        int offset = (currentPage - 1) * pageSize;

        boolean queryCustomers = role.isEmpty() || role.equals("customer");
        boolean queryStaffs = role.isEmpty() || role.equals("staff") || role.equals("admin");

        if ("staff".equals(loginUser.getRole())) {
            queryStaffs = false;
        }

        String staffRoleFilter = (role.equals("customer") || role.isEmpty()) ? "" : role;

        int totalCustomers = queryCustomers ? customerDAO.countCustomersFiltered(keyword, status) : 0;
        int totalStaffs = queryStaffs ? accountDAO.countStaffsFiltered(keyword, staffRoleFilter, status) : 0;
        int totalRecords = totalCustomers + totalStaffs;
        int totalPages = (int) Math.ceil((double) totalRecords / pageSize);

        if (queryCustomers) {
            request.setAttribute("customers", customerDAO.searchCustomers(keyword, status, offset, pageSize));
        }

        if (queryStaffs) {
            request.setAttribute("staffs", accountDAO.searchStaffs(keyword, staffRoleFilter, status, offset, pageSize));
        }

        request.setAttribute("currentPage", currentPage);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("keyword", keyword);
        request.setAttribute("role", role);
        request.setAttribute("status", status);

        String baseUrl = request.getContextPath()
                + "/dashboard/account-management"
                + "?keyword=" + keyword
                + "&role=" + role
                + "&status=" + status
                + "&";
        request.setAttribute("baseUrl", baseUrl);

        request.getRequestDispatcher("/views/admin/account/account-management.jsp")
                .forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        Account loginUser = (session != null) ? (Account) session.getAttribute("account") : null;

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        if (loginUser == null) {
            response.setStatus(401);
            response.getWriter().write("{\"success\":false,\"message\":\"Not signed in\"}");
            return;
        }

        customerDAO = new CustomerDAO();
        accountDAO = new AccountDAO();

        String action = nvl(request.getParameter("action"), "");

        try (PrintWriter out = response.getWriter()) {
            switch (action) {
                case "toggleCustomer":
                    handleToggleCustomer(request, out);
                    break;
                case "toggleStaff":
                    handleToggleStaff(request, out, loginUser);
                    break;
                case "updateCustomer":
                    handleUpdateCustomer(request, out);
                    break;
                case "updateStaff":
                    handleUpdateStaff(request, out, loginUser);
                    break;
                case "customerStats":
                    getCustomerStats(request, out);
                    break;
                default:
                    out.write("{\"success\":false,\"message\":\"Invalid action\"}");
            }
        } catch (NumberFormatException e) {
            response.setStatus(400);
            response.getWriter().write("{\"success\":false,\"message\":\"Invalid ID\"}");
        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(500);
            response.getWriter().write("{\"success\":false,\"message\":\"Server error\"}");
        }
    }

    private void handleToggleCustomer(HttpServletRequest request, PrintWriter out) {
        int id = Integer.parseInt(request.getParameter("id"));
        String status = request.getParameter("status");
        boolean ok = customerDAO.toggleCustomerStatus(id, status);

        if (ok) {
            model.Customer customer = customerDAO.getCustomerById(id);
            if (customer != null && customer.getEmail() != null && !customer.getEmail().trim().isEmpty()) {
                sendAccountStatusEmailAsync(customer.getEmail(), customer.getFullname(), status);
            }
        }

        out.write(ok ? "{\"success\":true}" : "{\"success\":false,\"message\":\"Update failed\"}");
    }

    private void handleToggleStaff(HttpServletRequest request, PrintWriter out, Account loginUser) {
        if (!"admin".equals(loginUser.getRole())) {
            out.write("{\"success\":false,\"message\":\"Insufficient permissions\"}");
            return;
        }
        int id = Integer.parseInt(request.getParameter("id"));
        String status = request.getParameter("status");
        boolean ok = accountDAO.toggleStaffStatus(id, status);

        if (ok) {
            Account staff = accountDAO.getStaffById(id);
            if (staff != null && staff.getEmail() != null && !staff.getEmail().trim().isEmpty()) {
                sendAccountStatusEmailAsync(staff.getEmail(), staff.getFullname(), status);
            }
        }

        out.write(ok ? "{\"success\":true}" : "{\"success\":false,\"message\":\"Update failed\"}");
    }

    private void sendAccountStatusEmailAsync(String email, String fullname, String newStatus) {
        final String toEmail = email;
        final String name = fullname;
        final boolean locked = "inactive".equals(newStatus);

        new Thread(new Runnable() {
            @Override
            public void run() {
                try {
                    if (locked) {
                        utils.EmailUtil.sendAccountLockedEmail(toEmail, name);
                    } else {
                        utils.EmailUtil.sendAccountUnlockedEmail(toEmail, name);
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                }
            }
        }).start();
    }

    private void handleUpdateCustomer(HttpServletRequest request, PrintWriter out) {
        int id = Integer.parseInt(request.getParameter("id"));
        String fullname = request.getParameter("fullname");
        String phone = request.getParameter("phone");
        String status = request.getParameter("status");

        if (fullname == null || fullname.trim().isEmpty()) {
            out.write("{\"success\":false,\"message\":\"Full name is required\"}");
            return;
        }
        String phoneError = validatePhone(phone);
        if (phoneError != null) {
            out.write("{\"success\":false,\"message\":\"" + phoneError + "\"}");
            return;
        }
        boolean ok = customerDAO.updateCustomerByAdmin(id, fullname.trim(), phone.trim(), status);
        out.write(ok ? "{\"success\":true}" : "{\"success\":false,\"message\":\"Update failed\"}");
    }

    private void handleUpdateStaff(HttpServletRequest request, PrintWriter out, Account loginUser) {
        if (!"admin".equals(loginUser.getRole())) {
            out.write("{\"success\":false,\"message\":\"Insufficient permissions\"}");
            return;
        }
        int id = Integer.parseInt(request.getParameter("id"));
        String fullname = request.getParameter("fullname");
        String phone = request.getParameter("phone");
        String status = request.getParameter("status");
        String role = request.getParameter("role");

        if (fullname == null || fullname.trim().isEmpty()) {
            out.write("{\"success\":false,\"message\":\"Full name is required\"}");
            return;
        }
        if (!"staff".equals(role) && !"admin".equals(role)) {
            out.write("{\"success\":false,\"message\":\"Invalid role\"}");
            return;
        }
        String phoneError = validatePhone(phone);
        if (phoneError != null) {
            out.write("{\"success\":false,\"message\":\"" + phoneError + "\"}");
            return;
        }
        boolean ok = accountDAO.updateStaffByAdmin(id, fullname.trim(), phone.trim(), role, status);
        out.write(ok ? "{\"success\":true}" : "{\"success\":false,\"message\":\"Update failed\"}");
    }

    private void getCustomerStats(HttpServletRequest request, PrintWriter out) {
        int customerId = Integer.parseInt(request.getParameter("id"));
        OrderDAO orderDAO = new OrderDAO();
        int totalOrders = orderDAO.getTotalOrdersByCustomer(customerId);
        double totalSpent = orderDAO.getTotalSpentByCustomer(customerId);
        out.write("{\"success\":true,\"totalOrders\":" + totalOrders + ",\"totalSpent\":" + totalSpent + "}");
    }

    private String nvl(String value, String defaultValue) {
        return (value != null) ? value : defaultValue;
    }

    private String validatePhone(String phone) {
        if (phone == null || phone.trim().isEmpty()) {
            return "Phone number is required";
        }

        String trimmed = phone.trim();
        if (!trimmed.matches("^[0-9+\\-\\s\\(\\)]*$")) {
            return "Phone number contains invalid characters";
        }

        String normalized = trimmed.replaceAll("[\\s\\-\\(\\)]", "");
        if (!normalized.matches("^(0|\\+84)[0-9]{9,10}$")) {
            return "Invalid phone number (must start with 0 or +84)";
        }

        String digitsOnly = normalized.replaceAll("[^0-9]", "");
        if (digitsOnly.length() < 10 || digitsOnly.length() > 11) {
            return "Phone number must contain 10–11 digits";
        }

        return null;
    }

    @Override
    public String getServletInfo() {
        return "Account Management Controller";
    }
}
