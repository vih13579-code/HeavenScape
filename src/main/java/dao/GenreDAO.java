package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import model.Genre;
import utils.DBContext;

public class GenreDAO {

    private final DBContext db = new DBContext();

    public List<Genre> getAllGenres() {
        List<Genre> list = new ArrayList<>();
        String sql = "SELECT g.genreID, g.genre_name, COUNT(b.bookID) AS book_count "
                + "FROM Genre g "
                + "LEFT JOIN Book b ON b.genreID = g.genreID "
                + "GROUP BY g.genreID, g.genre_name "
                + "ORDER BY g.genreID DESC";

        try (Connection conn = db.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                list.add(new Genre(
                        rs.getInt("genreID"),
                        rs.getString("genre_name"),
                        rs.getInt("book_count")
                ));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    public List<Genre> searchGenres(String keyword) {
        List<Genre> list = new ArrayList<>();
        String sql = "SELECT g.genreID, g.genre_name, COUNT(b.bookID) AS book_count "
                + "FROM Genre g "
                + "LEFT JOIN Book b ON b.genreID = g.genreID "
                + "WHERE g.genre_name LIKE ? "
                + "GROUP BY g.genreID, g.genre_name "
                + "ORDER BY g.genreID DESC";

        try (Connection conn = db.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, "%" + keyword.trim() + "%");

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(new Genre(
                            rs.getInt("genreID"),
                            rs.getString("genre_name"),
                            rs.getInt("book_count")
                    ));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    public Genre getGenreById(int id) {
        String sql = "SELECT g.genreID, g.genre_name, COUNT(b.bookID) AS book_count "
                + "FROM Genre g "
                + "LEFT JOIN Book b ON b.genreID = g.genreID "
                + "WHERE g.genreID = ? "
                + "GROUP BY g.genreID, g.genre_name";

        try (Connection conn = db.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, id);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return new Genre(
                            rs.getInt("genreID"),
                            rs.getString("genre_name"),
                            rs.getInt("book_count")
                    );
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return null;
    }

    public boolean isGenreNameExists(String name) {
        return isGenreNameExists(name, 0);
    }

    public boolean isGenreNameExists(String name, int exceptId) {
        String sql = "SELECT COUNT(*) FROM Genre WHERE LOWER(LTRIM(RTRIM(genre_name))) = LOWER(LTRIM(RTRIM(?)))";
        if (exceptId > 0) {
            sql += " AND genreID <> ?";
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

    public boolean insertGenre(String name) {
        String sql = "INSERT INTO Genre(genre_name) VALUES (?)";

        try (Connection conn = db.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, name.trim());
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }

    public boolean updateGenre(int id, String name) {
        String sql = "UPDATE Genre SET genre_name = ? WHERE genreID = ?";

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

    public boolean deleteGenre(int id) {
        String sql = "DELETE FROM Genre WHERE genreID = ?";

        try (Connection conn = db.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }

    public int countBooksByGenre(int id) {
        String sql = "SELECT COUNT(*) FROM Book WHERE genreID = ?";

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
