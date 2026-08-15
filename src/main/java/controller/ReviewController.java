package controller;

import dao.CustomerDAO;
import dao.ReviewDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Account;

import java.io.IOException;
import model.Customer;
import model.Review;

public class ReviewController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {
        // TODO: implement
    }

    @Override
    protected void doPost(HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {
        // TODO: implement
    }

    // thêm review mới
    private void handleAddReview(HttpServletRequest request,
            HttpServletResponse response)
            throws IOException {
        // TODO: implement
    }

    private void handleEditReview(HttpServletRequest request,
            HttpServletResponse response)
            throws IOException {
        // TODO: implement
    }

    // admin/ staff phản hồi
    private void handleReplyReview(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        // TODO: implement
    }

    private void handleHideReview(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        // TODO: implement
    }

    // admin và staff đều được khóa tài khoản customer, không phân biệt role cụ thể
    private void handleLockAccount(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        // TODO: implement
    }

    private void sendAccountViolationLockedEmailAsync(String email, String fullname) {
        // TODO: implement
    }

    private boolean isCustomer(HttpServletRequest request) {
        // TODO: implement
        return false;
    }

    private boolean isAdminOrStaff(HttpServletRequest request) {
        // TODO: implement
        return false;
    }

    private boolean isAdmin(HttpServletRequest request) {
        // TODO: implement
        return false;
    }

    private Account getAccount(HttpServletRequest request) {
        // TODO: implement
        return null;
    }

    private int toInt(String value, int defaultValue) {
        // TODO: implement
        return 0;
    }

    @Override
    public String getServletInfo() {
        // TODO: implement
        return null;
    }

    private void sendJson(HttpServletResponse response, String json)
            throws IOException {
        // TODO: implement
    }
}