package controller;

import dao.BookDAO;
import dao.ReviewDAO;
import dao.WishListDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Account;
import model.Book;
import java.io.IOException;
import java.math.BigDecimal;
import java.util.List;
import java.util.Map;
import model.Review;


public class ProductController extends HttpServlet {

    private static final int DEFAULT_PAGE_SIZE = 12;
    private final BookDAO bookDAO = new BookDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        // TODO: implement
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        // TODO: implement
    }


    private void showList(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        // TODO: implement
    }

 
    private void showDetail(HttpServletRequest req, HttpServletResponse resp, String idParam)
            throws ServletException, IOException {
        // TODO: implement
    }


    private void showFeatured(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        // TODO: implement
    }

 
    private void show404(HttpServletRequest req, HttpServletResponse resp, String message)
            throws ServletException, IOException {
        // TODO: implement
    }


    private int parsePage(String param) {
        // TODO: implement
        return 0;
    }

    private int parsePageSize(String param) {
        // TODO: implement
        return 0;
    }

    private int parseID(String param) {
        // TODO: implement
        return 0;
    }

    private Integer parseIntParam(String param) {
        // TODO: implement
        return null;
    }

    private BigDecimal parsePriceParam(String param) {
        // TODO: implement
        return null;
    }

    private String buildOrderClause(String sortBy) {
        // TODO: implement
        return null;
    }
}