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
        // TODO: implement
        return new ArrayList<Review>();
    }

    // customer thêm review mới 
    public boolean addReview(int customerID, int bookID, int orderDetailID, int rating, String comment) {
        // TODO: implement
        return false;
    }

    // kiểm tra customer có review được ko 
    public boolean canReview(int customerID, int bookID) {
        // TODO: implement
        return false;
    }

    // lấy oderDtailID để review    
    public int getReviewableOrderDetail(
            int customerID,
            int bookID) {
        // TODO: implement
        return 0;
    }

    // lấy tất cả review để admin và staff xem 
    public List<Review> getAllReviews(String search, Integer rating, String status) {
        // TODO: implement
        return new ArrayList<Review>();
    }

    // admin với staff phản hồi review 
    public boolean replyReview(
            int reviewID,
            int adminID,
            String reply) {
        // TODO: implement
        return false;
    }

    // ẩn review
    public boolean hideReview(int reviewID) {
        // TODO: implement
        return false;
    }

    // mở ẩn review
    public boolean toggleHideReview(int reviewID) {
        // TODO: implement
        return false;
    }

    public boolean lockAccountByReview(int customerID) {
        // TODO: implement
        return false;
    }

    public Review getReviewByID(int reviewID) {
        // TODO: implement
        return null;
    }

    public boolean updateReview(int reviewID, int customerID, int rating, String comment) {
        // TODO: implement
        return false;
    }
}
