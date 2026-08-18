package dao;

import model.WishlistItem;
import utils.DBContext;

import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class WishListDAO {


    public int getOrCreateWishlist(int customerID) {
        String sqlFind = "SELECT wishlistID FROM WishList WHERE customerID = ?";
        try (Connection conn = new DBContext().getConnection(); PreparedStatement ps = conn.prepareStatement(sqlFind)) {
            ps.setInt(1, customerID);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt("wishlistID");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        String sqlIns = "INSERT INTO WishList (customerID) VALUES (?)";
        try (Connection conn = new DBContext().getConnection(); PreparedStatement ps = conn.prepareStatement(sqlIns, PreparedStatement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, customerID);
            ps.executeUpdate();
            ResultSet keys = ps.getGeneratedKeys();
            if (keys.next()) {
                return keys.getInt(1);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return -1;
    }


    public List<WishlistItem> getWishlistItems(int customerID) {
        List<WishlistItem> items = new ArrayList<>();
        String sql
                = "SELECT wi.wishlistItemID, wi.wishlistID, wi.bookID, wi.added_at, "
                + "       b.title, b.thumbnail, b.price, b.stock_quantity, b.status, "
                + "       ISNULL(AVG(CAST(r.rating AS FLOAT)), 0) AS avg_rating, "
                + "       COUNT(DISTINCT r.reviewID) AS review_count, "
                + "       STRING_AGG(a.fullname, ', ') AS authors "
                + "FROM WishList wl "
                + "JOIN WishList_Item wi ON wi.wishlistID = wl.wishlistID "
                + "JOIN Book b ON b.bookID = wi.bookID "
                + "LEFT JOIN Review r ON r.bookID = b.bookID "
                + "LEFT JOIN BookAuthor ba ON ba.bookID = b.bookID "
                + "LEFT JOIN Author a ON a.authorID = ba.authorID "
                + "WHERE wl.customerID = ? "
                + "GROUP BY wi.wishlistItemID, wi.wishlistID, wi.bookID, wi.added_at, "
                + "         b.title, b.thumbnail, b.price, b.stock_quantity, b.status "
                + "ORDER BY wi.added_at DESC";
        try (Connection conn = new DBContext().getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, customerID);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                WishlistItem item = new WishlistItem();
                item.setWishlistItemID(rs.getInt("wishlistItemID"));
                item.setWishlistID(rs.getInt("wishlistID"));
                item.setBookID(rs.getInt("bookID"));
                item.setAddedAt(rs.getTimestamp("added_at"));
                item.setTitle(rs.getString("title"));
                item.setThumbnail(rs.getString("thumbnail"));
                item.setPrice(rs.getBigDecimal("price"));
                item.setStockQuantity(rs.getInt("stock_quantity"));
                item.setStatus(rs.getString("status"));
                item.setAvgRating(rs.getDouble("avg_rating"));
                item.setReviewCount(rs.getInt("review_count"));
                String authors = rs.getString("authors");
                item.setAuthorsDisplay(authors != null ? authors : "");
                items.add(item);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return items;
    }


    public boolean isInWishlist(int customerID, int bookID) {
        String sql
                = "SELECT 1 FROM WishList wl "
                + "JOIN WishList_Item wi ON wi.wishlistID = wl.wishlistID "
                + "WHERE wl.customerID = ? AND wi.bookID = ?";
        try (Connection conn = new DBContext().getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, customerID);
            ps.setInt(2, bookID);
            return ps.executeQuery().next();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }


    public boolean addToWishlist(int customerID, int bookID) {
        if (isInWishlist(customerID, bookID)) {
            return true; 
        }
        int wishlistID = getOrCreateWishlist(customerID);
        if (wishlistID == -1) {
            return false;
        }

        String sql = "INSERT INTO WishList_Item (wishlistID, bookID) VALUES (?, ?)";
        try (Connection conn = new DBContext().getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, wishlistID);
            ps.setInt(2, bookID);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    
    public boolean removeFromWishlist(int customerID, int bookID) {
        if (!isInWishlist(customerID, bookID)) {
            return true;
        }
        String sql
                = "DELETE wi FROM WishList_Item wi "
                + "JOIN WishList wl ON wl.wishlistID = wi.wishlistID "
                + "WHERE wl.customerID = ? AND wi.bookID = ?";
        try (Connection conn = new DBContext().getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, customerID);
            ps.setInt(2, bookID);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }


    public int countWishlistItems(int customerID) {
        String sql
                = "SELECT COUNT(*) FROM WishList wl "
                + "JOIN WishList_Item wi ON wi.wishlistID = wl.wishlistID "
                + "WHERE wl.customerID = ?";
        try (Connection conn = new DBContext().getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, customerID);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }


    public boolean moveToCart(int customerID, int bookID) {
        return moveToCart(customerID, bookID, 1);
    }

    public boolean moveToCart(int customerID, int bookID, int quantity) {
        if (!isInWishlist(customerID, bookID)) {
            return false;
        }

        CartDAO cartDAO = new CartDAO();
        if (!cartDAO.addToCart(customerID, bookID, quantity)) {
            return false;
        }

        return removeFromWishlist(customerID, bookID);
    }
}
