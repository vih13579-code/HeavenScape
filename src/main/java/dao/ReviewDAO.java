package dao;

import model.Review;
import utils.DBContext;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.List;

public class ReviewDAO {

    DBContext db = new DBContext();

    // lấy review theo bookID cho trang product detail
    public List<Review> getReviewsByBook(int bookID) {
        List<Review> list = new ArrayList<>();
        String sql
                = "SELECT r.*, c.fullname "
                + "FROM Review r "
                + "JOIN Customer c ON r.customerID = c.customerID "
                + "WHERE r.bookID = ? AND r.isHidden = 0 "
                + "ORDER BY r.created_at DESC";
        try {
            Connection conn = db.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, bookID);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Review review = new Review();

                review.setReviewID(rs.getInt("reviewID"));
                review.setCustomerID(rs.getInt("customerID"));
                review.setCustomerName(rs.getString("fullname"));
                review.setBookID(rs.getInt("bookID"));
                review.setOrderDetailID(rs.getInt("orderDetailID"));
                review.setRating(rs.getInt("rating"));
                review.setComment(rs.getString("comment"));
                review.setCreatedAt(rs.getTimestamp("created_at"));
                review.setAdminID(rs.getInt("adminID"));
                review.setAdminReply(rs.getString("adminReply"));
                review.setAdminReplyDate(rs.getTimestamp("adminReplyDate"));

                list.add(review);
            }

            conn.close();

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    // customer thêm review mới 
    public boolean addReview(int customerID, int bookID, int orderDetailID, int rating, String comment) {

        String sql = "INSERT INTO Review " + "(customerID, bookID, orderDetailID, rating, comment, created_at) " + "VALUES (?, ?, ?, ?, ?, GETDATE())";
        try {
            Connection conn = db.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, customerID);
            ps.setInt(2, bookID);
            ps.setInt(3, orderDetailID);
            ps.setInt(4, rating);
            ps.setString(5, comment);
            int result = ps.executeUpdate();
            conn.close();
            return result > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }

    // kiểm tra customer có review được ko 
    public boolean canReview(int customerID, int bookID) {

        String sql
                = "SELECT 1 "
                + "FROM [Order] o "
                + "JOIN OrderDetail od ON o.orderID = od.orderID "
                + "LEFT JOIN Review r ON r.orderDetailID = od.orderDetailID "
                + "WHERE o.customerID = ? "
                + "AND od.bookID = ? "
                + "AND LOWER(o.status) = 'completed' "
                + "AND r.reviewID IS NULL";

        try (Connection conn = db.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, customerID);
            ps.setInt(2, bookID);

            ResultSet rs = ps.executeQuery();

            return rs.next();

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }

    // lấy oderDtailID để review    
    public int getReviewableOrderDetail(
            int customerID,
            int bookID) {

        String sql
                = "SELECT TOP 1 od.orderDetailID "
                + "FROM [Order] o "
                + "JOIN OrderDetail od ON o.orderID = od.orderID "
                + "WHERE o.customerID = ? "
                + "AND od.bookID = ? "
                + "AND o.status = 'completed' "
                + "AND NOT EXISTS ( "
                + "    SELECT 1 "
                + "    FROM Review r "
                + "    WHERE r.orderDetailID = od.orderDetailID "
                + ")";

        try {
            Connection conn = db.getConnection();

            PreparedStatement ps = conn.prepareStatement(sql);

            ps.setInt(1, customerID);
            ps.setInt(2, bookID);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {

                int orderDetailID
                        = rs.getInt("orderDetailID");

                conn.close();

                return orderDetailID;
            }

            conn.close();

        } catch (Exception e) {
            e.printStackTrace();
        }

        return -1;
    }

    // lấy tất cả review để admin và staff xem 
    public List<Review> getAllReviews(String search, Integer rating, String status) {
        List<Review> list = new ArrayList<>();

        StringBuilder sql = new StringBuilder(
                "SELECT r.*, c.fullname, c.status as customerStatus, "
                + "b.title as bookTitle, b.thumbnail as bookCover "
                + "FROM Review r "
                + "JOIN Customer c ON r.customerID = c.customerID "
                + "JOIN Book b ON r.bookID = b.bookID "
                + "WHERE 1=1 "
        );

        List<Object> params = new ArrayList<>();

        if (search != null && !search.trim().isEmpty()) {
            sql.append("AND (c.fullname COLLATE Vietnamese_CI_AI LIKE ? COLLATE Vietnamese_CI_AI ")
                    .append("OR b.title COLLATE Vietnamese_CI_AI LIKE ? COLLATE Vietnamese_CI_AI) ");
            String kw = "%" + search.trim() + "%";
            params.add(kw);
            params.add(kw);
        }

        if (rating != null && rating >= 1 && rating <= 5) {
            sql.append("AND r.rating = ? ");
            params.add(rating);
        }

        if (status != null) {
            if ("pending".equalsIgnoreCase(status)) {
                sql.append("AND (r.adminReply IS NULL OR LTRIM(RTRIM(r.adminReply)) = '') ");
            } else if ("approved".equalsIgnoreCase(status)) {
                sql.append("AND r.adminReply IS NOT NULL AND LTRIM(RTRIM(r.adminReply)) <> '' ");
            }
        }

        sql.append("ORDER BY r.created_at DESC");

        try {
            Connection conn = db.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql.toString());

            for (int i = 0; i < params.size(); i++) {
                Object p = params.get(i);
                if (p instanceof String) {
                    ps.setString(i + 1, (String) p);
                } else if (p instanceof Integer) {
                    ps.setInt(i + 1, (Integer) p);
                }
            }

            ResultSet rs = ps.executeQuery();
            SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy");

            while (rs.next()) {
                Review review = new Review();
                review.setReviewID(rs.getInt("reviewID"));
                review.setCustomerID(rs.getInt("customerID"));
                review.setCustomerName(rs.getString("fullname"));
                review.setCustomerStatus(rs.getString("customerStatus"));
                review.setBookID(rs.getInt("bookID"));
                review.setBookTitle(rs.getString("bookTitle"));
                review.setBookCover(rs.getString("bookCover"));
                review.setOrderDetailID(rs.getInt("orderDetailID"));
                review.setRating(rs.getInt("rating"));
                review.setComment(rs.getString("comment"));
                review.setCreatedAt(rs.getTimestamp("created_at"));
                review.setAdminID(rs.getInt("adminID") == 0 ? null : rs.getInt("adminID"));
                review.setAdminReply(rs.getString("adminReply"));
                review.setAdminReplyDate(rs.getTimestamp("adminReplyDate"));
                review.setIsHidden(rs.getInt("isHidden") == 1);

                if (rs.getTimestamp("created_at") != null) {
                    review.setDate(sdf.format(rs.getTimestamp("created_at")));
                }

                String st = "Pending Approval";
                if (rs.getString("adminReply") != null && !rs.getString("adminReply").trim().isEmpty()) {
                    st = "Approved";
                }
                review.setStatus(st);

                list.add(review);
            }

            conn.close();
        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    // admin với staff phản hồi review 
    public boolean replyReview(
            int reviewID,
            int adminID,
            String reply) {

        String sql
                = "UPDATE Review "
                + "SET adminID = ?, "
                + "adminReply = ?, "
                + "adminReplyDate = GETDATE() "
                + "WHERE reviewID = ? "
                + "AND (adminReply IS NULL OR LTRIM(RTRIM(adminReply)) = '')";

        try {

            Connection conn = db.getConnection();

            PreparedStatement ps
                    = conn.prepareStatement(sql);

            ps.setInt(1, adminID);
            ps.setString(2, reply);
            ps.setInt(3, reviewID);

            int result = ps.executeUpdate();

            conn.close();

            return result > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }

    public boolean updateReplyReview(int reviewID, int adminID, String reply) {
        String sql = "UPDATE Review "
                + "SET adminID = ?, adminReply = ?, adminReplyDate = GETDATE() "
                + "WHERE reviewID = ? "
                + "AND adminReply IS NOT NULL AND LTRIM(RTRIM(adminReply)) <> ''";

        try (Connection conn = db.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, adminID);
            ps.setString(2, reply);
            ps.setInt(3, reviewID);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean deleteReplyReview(int reviewID) {
        String sql = "UPDATE Review "
                + "SET adminID = NULL, adminReply = NULL, adminReplyDate = NULL "
                + "WHERE reviewID = ? "
                + "AND adminReply IS NOT NULL AND LTRIM(RTRIM(adminReply)) <> ''";

        try (Connection conn = db.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, reviewID);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    // ẩn review
    public boolean hideReview(int reviewID) {
        String sql = "UPDATE Review SET isHidden = 1 WHERE reviewID = ?";
        try {
            Connection conn = db.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, reviewID);
            int result = ps.executeUpdate();
            conn.close();
            return result > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    // mở ẩn review
    public boolean toggleHideReview(int reviewID) {
        String checkSql = "SELECT isHidden FROM Review WHERE reviewID = ?";
        String updateSql = "UPDATE Review SET isHidden = ? WHERE reviewID = ?";

        try {
            Connection conn = db.getConnection();
            PreparedStatement checkPs = conn.prepareStatement(checkSql);
            checkPs.setInt(1, reviewID);
            ResultSet rs = checkPs.executeQuery();
            if (rs.next()) {
                int currentStatus = rs.getInt("isHidden");
                int newStatus = currentStatus == 1 ? 0 : 1;
                PreparedStatement updatePs = conn.prepareStatement(updateSql);
                updatePs.setInt(1, newStatus);
                updatePs.setInt(2, reviewID);
                int result = updatePs.executeUpdate();

                conn.close();
                return result > 0;
            }
            conn.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean lockAccountByReview(int customerID) {
        String sql = "UPDATE Customer SET status = 'inactive' WHERE customerID = ?";
        try {
            Connection conn = db.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, customerID);
            int result = ps.executeUpdate();
            conn.close();
            return result > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public Review getReviewByID(int reviewID) {
        String sql = "SELECT r.*, c.fullname, c.status as customerStatus, b.title as bookTitle "
                + "FROM Review r "
                + "JOIN Customer c ON r.customerID = c.customerID "
                + "JOIN Book b ON r.bookID = b.bookID "
                + "WHERE r.reviewID = ?";

        try {
            Connection conn = db.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, reviewID);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                Review review = new Review();
                review.setReviewID(rs.getInt("reviewID"));
                review.setCustomerID(rs.getInt("customerID"));
                review.setCustomerName(rs.getString("fullname"));
                review.setCustomerStatus(rs.getString("customerStatus"));
                review.setBookID(rs.getInt("bookID"));
                review.setBookTitle(rs.getString("bookTitle"));
                review.setOrderDetailID(rs.getInt("orderDetailID"));
                review.setRating(rs.getInt("rating"));
                review.setComment(rs.getString("comment"));
                review.setCreatedAt(rs.getTimestamp("created_at"));
                review.setAdminID(rs.getInt("adminID") == 0 ? null : rs.getInt("adminID"));
                review.setAdminReply(rs.getString("adminReply"));
                review.setAdminReplyDate(rs.getTimestamp("adminReplyDate"));

                conn.close();
                return review;
            }

            conn.close();
        } catch (Exception e) {
            e.printStackTrace();
        }

        return null;
    }

    public boolean updateReview(int reviewID, int customerID, int rating, String comment) {

        String sql = "UPDATE Review "
                + "SET rating = ?, comment = ? "
                + "WHERE reviewID = ? AND customerID = ?";

        try {
            Connection conn = db.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, rating);
            ps.setString(2, comment);
            ps.setInt(3, reviewID);
            ps.setInt(4, customerID);
            int result = ps.executeUpdate();
            conn.close();
            return result > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }

    public boolean deleteReply(int reviewID) {
        String sql = "UPDATE Review SET adminID = NULL, adminReply = NULL, "
                + "adminReplyDate = NULL WHERE reviewID = ? "
                + "AND adminReply IS NOT NULL";

        try (Connection conn = db.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, reviewID);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }
}
