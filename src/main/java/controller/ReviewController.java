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

        HttpSession session = request.getSession(false);

        if (session == null
                || session.getAttribute("account") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        Account acc = (Account) session.getAttribute("account");
        String role = acc.getRole();

        if (!"admin".equalsIgnoreCase(role)
                && !"staff".equalsIgnoreCase(role)) {
            response.sendRedirect(request.getContextPath() + "/home");
            return;
        }

        // Đọc tham số search/filter từ query string
        String search = request.getParameter("search");
        String ratingParam = request.getParameter("rating");
        String status = request.getParameter("status");

        Integer rating = null;
        if (ratingParam != null && !ratingParam.trim().isEmpty()) {
            try {
                rating = Integer.parseInt(ratingParam.trim());
            } catch (NumberFormatException e) {
                rating = null;
            }
        }

        ReviewDAO dao = new ReviewDAO();

        request.setAttribute("reviews", dao.getAllReviews(search, rating, status));

        // Trả lại giá trị filter hiện tại cho JSP để hiển thị đúng trạng thái UI
        request.setAttribute("searchValue", search == null ? "" : search);
        request.setAttribute("ratingValue", ratingParam == null ? "" : ratingParam);
        request.setAttribute("statusValue", status == null ? "all" : status);

        request.getRequestDispatcher(
                "/views/admin/review/review-management.jsp"
        ).forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        String action = request.getParameter("action");

        if (action == null) {
            action = "";
        }

        try {
            switch (action) {
                case "add":
                    handleAddReview(request, response);
                    break;
                case "edit":
                    handleEditReview(request, response);
                    break;
                case "reply":
                    handleReplyReview(request, response);
                    break;
                case "updateReply":
                    handleUpdateReply(request, response);
                    break;
                case "deleteReply":
                    handleDeleteReply(request, response);
                    break;
                case "hide":
                    handleHideReview(request, response);
                    break;
                case "lock":
                    handleLockAccount(request, response);
                    break;
                default:
                    sendJson(response,
                            "{\"success\":false,\"message\":\"Invalid action\"}");
            }
        } catch (NumberFormatException e) {
            e.printStackTrace();
            response.setStatus(400);
            response.getWriter().write("{\"success\":false,\"message\":\"Invalid data\"}");
        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(500);
            String safeMsg = e.getMessage() == null
                    ? "Server error"
                    : e.getMessage().replace("\"", "'").replace("\n", " ");
            response.getWriter().write("{\"success\":false,\"message\":\"Server error: " + safeMsg + "\"}");
        }
    }

    // thêm review mới
    private void handleAddReview(HttpServletRequest request,
            HttpServletResponse response)
            throws IOException {
        if (!isCustomer(request)) {
            sendJson(response,
                    "{\"success\":false,\"message\":\"Please sign in\"}");
            return;
        }
        Account acc = getAccount(request);
        int customerID = acc.getId();
        int bookID = toInt(request.getParameter("bookID"), 0);
        int rating = toInt(request.getParameter("rating"), 0);
        String comment = request.getParameter("comment");

        // Validate
        if (bookID <= 0) {
            sendJson(response,
                    "{\"success\":false,\"message\":\"Invalid book\"}");
            return;
        }
        if (rating < 1 || rating > 5) {
            sendJson(response,
                    "{\"success\":false,\"message\":\"Rating must be between 1 and 5 stars\"}");
            return;
        }
        if (comment == null || comment.trim().isEmpty()) {
            sendJson(response,
                    "{\"success\":false,\"message\":\"Please enter review content\"}");
            return;
        }
        comment = comment.trim();
        ReviewDAO dao = new ReviewDAO();

        // Kiểm tra customer có quyền review không
        int orderDetailID = dao.getReviewableOrderDetail(customerID, bookID);

        if (orderDetailID == -1) {
            sendJson(response,
                    "{\"success\":false,\"message\":\"You must purchase and receive the book before reviewing it\"}");
            return;
        }

        // Add review
        boolean success = dao.addReview(
                customerID,
                bookID,
                orderDetailID,
                rating,
                comment
        );

        if (success) {
            sendJson(response,
                    "{\"success\":true,\"message\":\"Review submitted successfully\"}");
        } else {
            sendJson(response,
                    "{\"success\":false,\"message\":\"Could not submit the review\"}");
        }
    }

    private void handleEditReview(HttpServletRequest request,
            HttpServletResponse response)
            throws IOException {

        if (!isCustomer(request)) {
            sendJson(response,
                    "{\"success\":false,\"message\":\"Please sign in\"}");
            return;
        }
        Account acc = getAccount(request);
        int customerID = acc.getId();

        int reviewID = toInt(request.getParameter("reviewID"), 0);
        int rating = toInt(request.getParameter("rating"), 0);
        String comment = request.getParameter("comment");
        if (reviewID <= 0) {
            sendJson(response,
                    "{\"success\":false,\"message\":\"Invalid review\"}");
            return;
        }
        if (rating < 1 || rating > 5) {
            sendJson(response,
                    "{\"success\":false,\"message\":\"Rating must be between 1 and 5 stars\"}");
            return;
        }
        if (comment == null || comment.trim().isEmpty()) {
            sendJson(response,
                    "{\"success\":false,\"message\":\"Please enter review content\"}");
            return;
        }
        comment = comment.trim();
        ReviewDAO dao = new ReviewDAO();
        // Kiểm tra review có tồn tại và đúng là của customer này không
        Review review = dao.getReviewByID(reviewID);
        if (review == null) {
            sendJson(response,
                    "{\"success\":false,\"message\":\"Review does not exist\"}");
            return;
        }
        if (review.getCustomerID() != customerID) {
            sendJson(response,
                    "{\"success\":false,\"message\":\"You do not have permission to edit this review\"}");
            return;
        }
        boolean success = dao.updateReview(
                reviewID,
                customerID,
                rating,
                comment
        );
        if (success) {
            sendJson(response,
                    "{\"success\":true,\"message\":\"Review updated successfully\"}");
        } else {
            sendJson(response,
                    "{\"success\":false,\"message\":\"Could not update the review\"}");
        }
    }

    // admin/ staff phản hồi
    private void handleReplyReview(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        // Kiểm tra admin/staff
        if (!isAdminOrStaff(request)) {
            sendJson(response, "{\"success\":false,\"message\":\"You do not have permission to perform this action\"}");
            return;
        }

        Account acc = getAccount(request);
        int adminID = acc.getId();

        int reviewID = toInt(request.getParameter("reviewID"), 0);
        String reply = request.getParameter("reply");
        if (reviewID <= 0) {
            sendJson(response, "{\"success\":false,\"message\":\"Invalid review\"}");
            return;
        }
        if (reply == null || reply.trim().isEmpty()) {
            sendJson(response, "{\"success\":false,\"message\":\"Please enter a reply\"}");
            return;
        }
        reply = reply.trim();
        ReviewDAO dao = new ReviewDAO();
        Review review = dao.getReviewByID(reviewID);
        if (review == null) {
            sendJson(response, "{\"success\":false,\"message\":\"Review does not exist\"}");
            return;
        }
        if (review.getCustomerStatus() != null && "inactive".equalsIgnoreCase(review.getCustomerStatus())) {
            sendJson(response, "{\"success\":false,\"message\":\"Cannot reply because the customer account is locked\"}");
            return;
        }
        boolean success = dao.replyReview(reviewID, adminID, reply);
        if (success) {
            sendJson(response, "{\"success\":true,\"message\":\"Reply sent successfully\"}");
        } else {
            sendJson(response, "{\"success\":false,\"message\":\"Could not send the reply\"}");
        }
    }

    private void handleUpdateReply(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        if (!isAdminOrStaff(request)) {
            sendJson(response, "{\"success\":false,\"message\":\"You do not have permission to perform this action\"}");
            return;
        }

        int reviewID = toInt(request.getParameter("reviewID"), 0);
        String reply = request.getParameter("reply");
        if (reviewID <= 0) {
            sendJson(response, "{\"success\":false,\"message\":\"Invalid review\"}");
            return;
        }
        if (reply == null || reply.trim().isEmpty()) {
            sendJson(response, "{\"success\":false,\"message\":\"Please enter a reply\"}");
            return;
        }

        ReviewDAO dao = new ReviewDAO();
        Review review = dao.getReviewByID(reviewID);
        if (review == null) {
            sendJson(response, "{\"success\":false,\"message\":\"Review does not exist\"}");
            return;
        }
        if (review.getAdminReply() == null || review.getAdminReply().trim().isEmpty()) {
            sendJson(response, "{\"success\":false,\"message\":\"This review does not have a reply to update\"}");
            return;
        }

        Account acc = getAccount(request);
        boolean success = dao.updateReplyReview(reviewID, acc.getId(), reply.trim());
        if (success) {
            sendJson(response, "{\"success\":true,\"message\":\"Reply updated successfully\"}");
        } else {
            sendJson(response, "{\"success\":false,\"message\":\"Could not update the reply\"}");
        }
    }

    private void handleDeleteReply(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        if (!isAdminOrStaff(request)) {
            sendJson(response, "{\"success\":false,\"message\":\"You do not have permission to perform this action\"}");
            return;
        }

        int reviewID = toInt(request.getParameter("reviewID"), 0);
        if (reviewID <= 0) {
            sendJson(response, "{\"success\":false,\"message\":\"Invalid review\"}");
            return;
        }

        ReviewDAO dao = new ReviewDAO();
        Review review = dao.getReviewByID(reviewID);
        if (review == null) {
            sendJson(response, "{\"success\":false,\"message\":\"Review does not exist\"}");
            return;
        }
        if (review.getAdminReply() == null || review.getAdminReply().trim().isEmpty()) {
            sendJson(response, "{\"success\":false,\"message\":\"This review does not have a reply to delete\"}");
            return;
        }

        boolean success = dao.deleteReplyReview(reviewID);
        if (success) {
            sendJson(response, "{\"success\":true,\"message\":\"Reply deleted successfully\"}");
        } else {
            sendJson(response, "{\"success\":false,\"message\":\"Could not delete the reply\"}");
        }
    }

    private void handleHideReview(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        if (!isAdmin(request)) {
            sendJson(response, "{\"success\":false,\"message\":\"You do not have permission to hide this review\"}");
            return;
        }
        int reviewID = toInt(request.getParameter("reviewID"), 0);
        if (reviewID <= 0) {
            sendJson(response, "{\"success\":false,\"message\":\"Invalid review\"}");
            return;
        }
        ReviewDAO dao = new ReviewDAO();
        boolean success = dao.toggleHideReview(reviewID);

        if (success) {
            sendJson(response, "{\"success\":true,\"message\":\"Review status updated successfully\"}");
        } else {
            sendJson(response, "{\"success\":false,\"message\":\"Could not update the review\"}");
        }
    }

    // admin và staff đều được khóa tài khoản customer, không phân biệt role cụ thể
    private void handleLockAccount(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        if (!isAdminOrStaff(request)) {
            sendJson(response, "{\"success\":false,\"message\":\"You do not have permission to lock this account\"}");
            return;
        }

        int reviewID = toInt(request.getParameter("reviewID"), 0);
        if (reviewID <= 0) {
            sendJson(response, "{\"success\":false,\"message\":\"Invalid review\"}");
            return;
        }

        ReviewDAO dao = new ReviewDAO();
        Review review = dao.getReviewByID(reviewID);

        if (review == null) {
            sendJson(response, "{\"success\":false,\"message\":\"Review does not exist\"}");
            return;
        }
        if (review.getCustomerStatus() != null && "inactive".equalsIgnoreCase(review.getCustomerStatus())) {
            sendJson(response, "{\"success\":false,\"message\":\"The customer account is already locked\"}");
            return;
        }

        boolean success = dao.lockAccountByReview(review.getCustomerID());

        if (success) {
            CustomerDAO customerDAO = new CustomerDAO();
            Customer customer = customerDAO.getCustomerById(review.getCustomerID());
            if (customer != null && customer.getEmail() != null && !customer.getEmail().trim().isEmpty()) {
                sendAccountViolationLockedEmailAsync(customer.getEmail(), customer.getFullname());
            }
            sendJson(response, "{\"success\":true,\"message\":\"Account locked successfully\"}");
        } else {
            sendJson(response, "{\"success\":false,\"message\":\"Could not lock the account\"}");
        }
    }

    private void sendAccountViolationLockedEmailAsync(String email, String fullname) {
        final String toEmail = email;
        final String name = fullname;

        new Thread(new Runnable() {
            @Override
            public void run() {
                try {
                    utils.EmailUtil.sendAccountLockedForViolationEmail(toEmail, name);
                } catch (Exception e) {
                    e.printStackTrace();
                }
            }
        }).start();
    }

    private boolean isCustomer(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("account") == null) {
            return false;
        }
        Account acc = (Account) session.getAttribute("account");
        return "customer".equalsIgnoreCase(acc.getRole());
    }

    private boolean isAdminOrStaff(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("account") == null) {
            return false;
        }
        Account acc = (Account) session.getAttribute("account");
        String role = acc.getRole();
        return "admin".equalsIgnoreCase(role) || "staff".equalsIgnoreCase(role);
    }

    private boolean isAdmin(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("account") == null) {
            return false;
        }
        Account acc = (Account) session.getAttribute("account");
        return "admin".equalsIgnoreCase(acc.getRole());
    }

    private Account getAccount(HttpServletRequest request) {
        return (Account) request.getSession().getAttribute("account");
    }

    private int toInt(String value, int defaultValue) {
        try {
            return Integer.parseInt(value);
        } catch (Exception e) {
            return defaultValue;
        }
    }

    @Override
    public String getServletInfo() {
        return "Review Controller";
    }

    private void sendJson(HttpServletResponse response, String json)
            throws IOException {
        response.getWriter().print(json);
    }
}
