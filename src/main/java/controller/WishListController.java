package controller;

import dao.BookDAO;
import dao.CartDAO;
import dao.WishListDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Account;
import model.WishlistItem;

import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.util.List;


public class WishListController extends HttpServlet {

    private final WishListDAO wishlistDAO = new WishListDAO();
    private final BookDAO bookDAO = new BookDAO();
    private final CartDAO cartDAO = new CartDAO();

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

    private void handleAdd(HttpServletRequest req, HttpServletResponse resp,
            Account account, int bookID, String referer, boolean isAjax) throws IOException {
        // TODO: implement
    }

    private void handleRemove(HttpServletRequest req, HttpServletResponse resp,
            Account account, int bookID, String referer, boolean isAjax) throws IOException {
        // TODO: implement
    }

    private void handleMoveToCart(HttpServletRequest req, HttpServletResponse resp,
            Account account, int bookID, String referer, boolean isAjax) throws IOException {
        // TODO: implement
    }

    private String buildRemoveRedirect(HttpServletRequest req, String referer, int bookID) {
        // TODO: implement
        return null;
    }

    private void respondSuccess(HttpServletResponse resp, boolean isAjax, String referer,
            String fallback, String action, int wishlistCount, int cartCount, String message)
            throws IOException {
        // TODO: implement
    }

    private void respondError(HttpServletRequest req, HttpServletResponse resp, boolean isAjax,
            String referer, String fallback, String errorCode, String message) throws IOException {
        // TODO: implement
    }

    private void writeJson(HttpServletResponse resp, int status, String body) throws IOException {
        // TODO: implement
    }

    private Account requireCustomer(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {
        // TODO: implement
        return null;
    }

    private boolean isAjaxRequest(HttpServletRequest req) {
        // TODO: implement
        return false;
    }

    private String buildRedirectUrl(String referer, String fallback, String extraParam) {
        // TODO: implement
        return null;
    }

    private int parseIntParam(String param, int defaultVal) {
        // TODO: implement
        return 0;
    }

    private String escapeJson(String value) {
        // TODO: implement
        return null;
    }
}