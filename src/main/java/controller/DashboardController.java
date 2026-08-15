package controller;

import dao.AccountDAO;
import dao.BookDAO;
import dao.DashboardDAO;
import dao.GenreDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Account;
import model.Book;
import model.Genre;

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
    private final GenreDAO genreDAO = new GenreDAO();
    private final BookDAO bookDAO = new BookDAO();
    private final AccountDAO accountDAO = new AccountDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // TODO: implement
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // TODO: implement
    }

    private String validateDateRange(String fromDate, String toDate) {
        // TODO: implement
        return null;
    }

    private void addRevenuePercentages(List<Map<String, Object>> rows) {
        // TODO: implement
    }

    private BigDecimal toBigDecimal(Object value) {
        // TODO: implement
        return null;
    }

    private boolean isAdminOrStaff(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        // TODO: implement
        return false;
    }

    private Integer parseGenreID(String raw) {
        // TODO: implement
        return null;
    }

    private String trimToNull(String value) {
        // TODO: implement
        return null;
    }
}