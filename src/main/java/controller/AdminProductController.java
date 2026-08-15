package controller;

import dao.BookDAO;
import dao.LookupDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Account;
import utils.RoleGuard;
import model.Book;

import java.io.IOException;
import java.math.BigDecimal;
import java.util.List;
import java.util.Map;


public class AdminProductController extends HttpServlet {

    private static final int PAGE_SIZE = 10;
    private final BookDAO bookDAO = new BookDAO();
    private final LookupDAO lookupDAO = new LookupDAO();

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


    private void showForm(HttpServletRequest req, HttpServletResponse resp, Book book)
            throws ServletException, IOException {
        // TODO: implement
    }

 
    private void showEditForm(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        // TODO: implement
    }

    private void handleCreate(HttpServletRequest req, HttpServletResponse resp, Account account)
            throws IOException {
        // TODO: implement
    }

    private void handleUpdate(HttpServletRequest req, HttpServletResponse resp, Account account)
            throws IOException {
        // TODO: implement
    }

    private void handleDelete(HttpServletRequest req, HttpServletResponse resp, Account account)
            throws IOException {
        // TODO: implement
    }
    private void handleRestore(HttpServletRequest req, HttpServletResponse resp, Account account)
        throws IOException {
        // TODO: implement
}


    private String validateStockQuantity(String raw) {
        // TODO: implement
        return null;
    }


    private String validateStatusVsStock(String stockRaw, String statusRaw) {
        // TODO: implement
        return null;
    }

    private Book buildBookFromRequest(HttpServletRequest req) {
        // TODO: implement
        return null;
    }

    private String clean(String s) {
        // TODO: implement
        return null;
    }


    private Account requireStaff(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {
        // TODO: implement
        return null;
    }


    private int parsePage(String param) {
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
}