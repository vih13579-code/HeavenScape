package controller;

import dao.AccountDAO;
import dao.BookDAO;
import dao.DashboardDAO;
import dao.CategoryDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Account;
import model.Book;
import model.Category;

import java.io.IOException;
import java.math.BigDecimal;
import java.math.RoundingMode;
import java.time.LocalDate;
import java.time.format.DateTimeParseException;
import java.util.Collections;
import java.util.List;
import java.util.Map;

public class DashboardController extends HttpServlet {

    private final DashboardDAO dashboardDAO = new DashboardDAO();
    private final CategoryDAO categoryDAO = new CategoryDAO();
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
        Integer categoryID = parseCategoryID(request.getParameter("categoryID"));

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

        // Code mới: số liệu bán hàng, lọc ngày và lọc category.
        BigDecimal totalRevenue = dashboardDAO.getTotalRevenue(fromDate, toDate, categoryID);
        int totalOrders = dashboardDAO.getTotalOrders(fromDate, toDate, categoryID);
        int totalCustomers = dashboardDAO.getTotalCustomers(fromDate, toDate, categoryID);
        int totalBooks = dashboardDAO.getTotalBooks(categoryID);
        int totalSoldBooks = dashboardDAO.getTotalSoldBooks(fromDate, toDate, categoryID);
        Map<String, Integer> statusSummary = dashboardDAO.getOrderStatusSummary(
                fromDate, toDate, categoryID);
        List<Map<String, Object>> revenueByCategory = dashboardDAO.getRevenueByCategory(
                fromDate, toDate, categoryID);
        addRevenuePercentages(revenueByCategory);
        List<Map<String, Object>> topSellingBooks = dashboardDAO.getTopSellingBooks(
                fromDate, toDate, categoryID);
        List<Map<String, Object>> allOrders;
        if (showAll) {
            // Nút "View All Orders": không áp dụng bộ lọc ngày/category.
            allOrders = dashboardDAO.getAllOrders(null, null, null);
        } else if (filterRequested && dateError == null) {
            // Chỉ hiển thị danh sách đơn khi users dùng thật sự bấm nút Filter.
            allOrders = dashboardDAO.getAllOrders(fromDate, toDate, categoryID);
        } else {
            // Lần đầu mở dashboard hoặc bấm Delete: để trống khu vực đơn hàng.
            allOrders = Collections.emptyList();
        }
        List<Category> categories = categoryDAO.getAllCategories();

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
        request.setAttribute("revenueByCategory", revenueByCategory);
        request.setAttribute("topSellingBooks", topSellingBooks);
        request.setAttribute("allOrders", allOrders);
        request.setAttribute("categories", categories);
        request.setAttribute("fromDate", fromDate);
        request.setAttribute("toDate", toDate);
        request.setAttribute("selectedCategoryID", categoryID);
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

    private void addRevenuePercentages(List<Map<String, Object>> rows) {
        BigDecimal max = BigDecimal.ZERO;
        for (Map<String, Object> row : rows) {
            Object value = row.get("revenue");
            BigDecimal revenue = toBigDecimal(value);
            if (revenue.compareTo(max) > 0) {
                max = revenue;
            }
        }

        for (Map<String, Object> row : rows) {
            BigDecimal revenue = toBigDecimal(row.get("revenue"));
            int percentage = max.signum() == 0 ? 0
                    : revenue.multiply(BigDecimal.valueOf(100))
                            .divide(max, 0, RoundingMode.HALF_UP)
                            .intValue();
            row.put("percentage", Math.max(0, Math.min(100, percentage)));
        }
    }

    private BigDecimal toBigDecimal(Object value) {
        if (value instanceof BigDecimal) {
            return (BigDecimal) value;
        }
        if (value instanceof Number) {
            return BigDecimal.valueOf(((Number) value).doubleValue());
        }
        return BigDecimal.ZERO;
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

    private Integer parseCategoryID(String raw) {
        try {
            if (raw == null || raw.trim().isEmpty() || "0".equals(raw.trim())) {
                return null;
            }
            return Integer.parseInt(raw.trim());
        } catch (NumberFormatException e) {
            return null;
        }
    }

    private String trimToNull(String value) {
        return value == null || value.trim().isEmpty() ? null : value.trim();
    }
}
