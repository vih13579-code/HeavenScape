package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import model.Category;
import utils.DBContext;

public class CategoryDAO {

    private final DBContext db = new DBContext();

    public List<Category> getAllCategories() {
        List<Category> list = new ArrayList<>();
        String sql = "SELECT g.categoryID, g.category_name, COUNT(b.bookID) AS book_count "
                + "FROM Category g "
                + "LEFT JOIN Book b ON b.categoryID = g.categoryID "
                + "GROUP BY g.categoryID, g.category_name "
                + "ORDER BY g.categoryID DESC";

        try (Connection conn = db.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                list.add(new Category(
                        rs.getInt("categoryID"),
                        rs.getString("category_name"),
                        rs.getInt("book_count")
                ));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    public List<Category> searchCategories(String keyword) {
        List<Category> list = new ArrayList<>();
        String sql = "SELECT g.categoryID, g.category_name, COUNT(b.bookID) AS book_count "
                + "FROM Category g "
                + "LEFT JOIN Book b ON b.categoryID = g.categoryID "
                + "WHERE g.category_name LIKE ? "
                + "GROUP BY g.categoryID, g.category_name "
                + "ORDER BY g.categoryID DESC";

        try (Connection conn = db.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, "%" + keyword.trim() + "%");

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(new Category(
                            rs.getInt("categoryID"),
                            rs.getString("category_name"),
                            rs.getInt("book_count")
                    ));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    public Category getCategoryById(int id) {
        String sql = "SELECT g.categoryID, g.category_name, COUNT(b.bookID) AS book_count "
                + "FROM Category g "
                + "LEFT JOIN Book b ON b.categoryID = g.categoryID "
                + "WHERE g.categoryID = ? "
                + "GROUP BY g.categoryID, g.category_name";

        try (Connection conn = db.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, id);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return new Category(
                            rs.getInt("categoryID"),
                            rs.getString("category_name"),
                            rs.getInt("book_count")
                    );
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return null;
    }

    public boolean isCategoryNameExists(String name) {
        return isCategoryNameExists(name, 0);
    }

    public boolean isCategoryNameExists(String name, int exceptId) {
        String sql = "SELECT COUNT(*) FROM Category WHERE LOWER(LTRIM(RTRIM(category_name))) = LOWER(LTRIM(RTRIM(?)))";
        if (exceptId > 0) {
            sql += " AND categoryID <> ?";
        }

        try (Connection conn = db.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, name);
            if (exceptId > 0) {
                ps.setInt(2, exceptId);
            }

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }

    public boolean insertCategory(String name) {
        String sql = "INSERT INTO Category(category_name) VALUES (?)";

        try (Connection conn = db.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, name.trim());
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }

    public boolean updateCategory(int id, String name) {
        String sql = "UPDATE Category SET category_name = ? WHERE categoryID = ?";

        try (Connection conn = db.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, name.trim());
            ps.setInt(2, id);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }

    public boolean deleteCategory(int id) {
        String sql = "DELETE FROM Category WHERE categoryID = ?";

        try (Connection conn = db.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }

    public int countBooksByCategory(int id) {
        String sql = "SELECT COUNT(*) FROM Book WHERE categoryID = ?";

        try (Connection conn = db.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, id);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return 0;
    }
}
