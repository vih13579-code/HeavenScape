package controller;

import dao.AccountDAO;
import dao.BookDAO;
import dao.DashboardDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Account;
import model.Book;

import java.io.IOException;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.format.DateTimeParseException;
import java.util.Collections;
import java.util.List;
import java.util.Map;

public class DashboardController extends HttpServlet {

    private final DashboardDAO dashboardDAO = new DashboardDAO();
    private final BookDAO bookDAO = new BookDAO();
    private final AccountDAO accountDAO = new AccountDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        if (!isAdminOrStaff(request, response)) {
            return;
        }

        String fromDate = trimToNull(request.getParameter("fromDate"));
        String toDate = trimToNull(request.getParameter("toDate"));

        boolean showAll = "true".equalsIgnoreCase(request.getParameter("showAll"));
        boolean filterRequested = "filter".equalsIgnoreCase(request.getParameter("action"));

        // Nếu users dùng chỉ nhập một ngày thì hiểu là lọc đúng ngày đó.
        if (filterRequested) {
            if (fromDate != null && toDate == null) {
                toDate = fromDate;
            } else if (fromDate == null && toDate != null) {
                fromDate = toDate;
            }
        }

        String dateError = validateDateRange(fromDate, toDate);
        if (dateError != null) {
            request.setAttribute("dateError", dateError);
            filterRequested = false;
        }

        BigDecimal totalRevenue = dashboardDAO.getTotalRevenue(fromDate, toDate, null);
        int totalOrders = dashboardDAO.getTotalOrders(fromDate, toDate, null);
        int totalCustomers = dashboardDAO.getTotalCustomers(fromDate, toDate, null);
        int totalBooks = dashboardDAO.getTotalBooks(null);
        int totalSoldBooks = dashboardDAO.getTotalSoldBooks(fromDate, toDate, null);
        Map<String, Integer> statusSummary = dashboardDAO.getOrderStatusSummary(
                fromDate, toDate, null);
        List<Map<String, Object>> topSellingBooks = dashboardDAO.getTopSellingBooks(
                fromDate, toDate, null);
        List<Map<String, Object>> revenueTrend = dashboardDAO.getRevenueTrend(fromDate, toDate);
        List<Map<String, Object>> allOrders;
        if (showAll) {
            // "View All Orders" does not apply the date filter.
            allOrders = dashboardDAO.getAllOrders(null, null, null);
        } else if (filterRequested && dateError == null) {
            // Chỉ hiển thị danh sách đơn khi users dùng thật sự bấm nút Filter.
            allOrders = dashboardDAO.getAllOrders(fromDate, toDate, null);
        } else {
            // Lần đầu mở dashboard hoặc bấm Delete: để trống khu vực đơn hàng.
            allOrders = Collections.emptyList();
        }

        // Giữ code cũ: thống kê kho sách và nhân viên.
        int allBooks = bookDAO.countAllBooks();
        int availableBooks = bookDAO.countBooksByStatus("available");
        int outOfStockBooks = bookDAO.countBooksByStatus("out_of_stock");
        int discontinuedBooks = bookDAO.countBooksByStatus("discontinued");
        List<Book> recentBooks = bookDAO.getRecentBooksAdmin(8);
        int totalStaffs = accountDAO.countStaffs();

        request.setAttribute("totalRevenue", totalRevenue);
        request.setAttribute("totalOrders", totalOrders);
        request.setAttribute("totalCustomers", totalCustomers);
        request.setAttribute("totalBooks", totalBooks);
        request.setAttribute("totalSoldBooks", totalSoldBooks);
        request.setAttribute("statusSummary", statusSummary);
        request.setAttribute("topSellingBooks", topSellingBooks);
        request.setAttribute("revenueTrend", revenueTrend);
        request.setAttribute("allOrders", allOrders);
        request.setAttribute("fromDate", fromDate);
        request.setAttribute("toDate", toDate);
        request.setAttribute("showAll", showAll);
        request.setAttribute("filterRequested", filterRequested);
        request.setAttribute("currentDate", LocalDate.now().toString());

        request.setAttribute("allBooks", allBooks);
        request.setAttribute("availableBooks", availableBooks);
        request.setAttribute("outOfStockBooks", outOfStockBooks);
        request.setAttribute("discontinuedBooks", discontinuedBooks);
        request.setAttribute("recentBooks", recentBooks);
        request.setAttribute("totalStaffs", totalStaffs);

        request.getRequestDispatcher("/views/admin/dashboard/dashboard.jsp")
                .forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }

    private String validateDateRange(String fromDate, String toDate) {
        try {
            LocalDate from = fromDate == null ? null : LocalDate.parse(fromDate);
            LocalDate to = toDate == null ? null : LocalDate.parse(toDate);
            LocalDate today = LocalDate.now();
            if ((from != null && from.isAfter(today)) || (to != null && to.isAfter(today))) {
                return "A future date cannot be selected.";
            }
            if (from != null && to != null && from.isAfter(to)) {
                return "Start date cannot be after the end date.";
            }
            return null;
        } catch (DateTimeParseException e) {
            return "Invalid date format.";
        }
    }

    private boolean isAdminOrStaff(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        HttpSession session = request.getSession(false);
        Account account = session == null
                ? null : (Account) session.getAttribute("account");

        if (account == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return false;
        }

        String role = account.getRole();
        if (!"admin".equalsIgnoreCase(role) && !"staff".equalsIgnoreCase(role)) {
            response.sendRedirect(request.getContextPath() + "/home");
            return false;
        }
        return true;
    }

    private String trimToNull(String value) {
        return value == null || value.trim().isEmpty() ? null : value.trim();
    }
}
