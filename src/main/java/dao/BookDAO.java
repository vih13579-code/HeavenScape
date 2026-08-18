package dao;

import model.Book;
import utils.DBContext;
import java.math.BigDecimal;
import java.sql.*;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

public class BookDAO {

    private static final String BASE_SELECT = "SELECT b.bookID, b.title, b.description, b.price, b.stock_quantity, "
            + "       b.thumbnail, b.total_pages, b.dimensions, b.weight, b.status, "
            + "       g.genreID, g.genre_name, "
            + "       c.contentID, c.content_name, "
            + "       s.seriesID, s.series_name, "
            + "       o.originID, o.origin_name, "
            + "       b.created_at, b.updated_at, "
            + "       ISNULL(AVG(CAST(r.rating AS FLOAT)), 0) AS avg_rating, "
            + "       COUNT(DISTINCT r.reviewID)              AS review_count "
            + "FROM Book b "
            + "LEFT JOIN Genre      g  ON b.genreID   = g.genreID "
            + "LEFT JOIN Content    c  ON b.contentID = c.contentID "
            + "LEFT JOIN BookSeries s  ON b.seriesID  = s.seriesID "
            + "LEFT JOIN BookOrigin o  ON b.originID  = o.originID "
            + "LEFT JOIN Review     r  ON b.bookID    = r.bookID ";

    private static final String GROUP_BY = " GROUP BY b.bookID, b.title, b.description, b.price, b.stock_quantity, "
            + "          b.thumbnail, b.total_pages, b.dimensions, b.weight, b.status, "
            + "          g.genreID, g.genre_name, c.contentID, c.content_name, "
            + "          s.seriesID, s.series_name, o.originID, o.origin_name, "
            + "          b.created_at, b.updated_at ";

    public List<Book> getBooks(int offset, int pageSize, String orderClause) {
        List<Book> books = new ArrayList<>();
        String sql = BASE_SELECT
                + "WHERE b.status IN ('available', 'out_of_stock') "
                + GROUP_BY + orderClause
                + " OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = new DBContext().getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, offset);
            ps.setInt(2, pageSize);
            rs = ps.executeQuery();
            while (rs.next()) {
                Book b = mapBook(rs);
                b.setAuthors(getAuthorsByBookID(conn, b.getBookID()));
                books.add(b);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeAll(rs, ps, conn);
        }
        return books;
    }

    public List<Book> getBooksFiltered(int offset, int pageSize, String orderClause,
            String keyword, Integer genreID,
            BigDecimal minPrice, BigDecimal maxPrice) {
        List<Book> books = new ArrayList<>();

        StringBuilder where = new StringBuilder("WHERE b.status IN ('available', 'out_of_stock') ");
        if (keyword != null && !keyword.trim().isEmpty()) {
            where.append("AND (b.title LIKE ? OR EXISTS ("
                    + "SELECT 1 FROM BookAuthor ba2 JOIN Author a2 ON a2.authorID = ba2.authorID "
                    + "WHERE ba2.bookID = b.bookID AND a2.fullname LIKE ?)) ");
        }
        if (genreID != null && genreID > 0) {
            where.append("AND b.genreID = ? ");
        }
        if (minPrice != null) {
            where.append("AND b.price >= ? ");
        }
        if (maxPrice != null) {
            where.append("AND b.price <= ? ");
        }

        String sql = BASE_SELECT + where + GROUP_BY + orderClause
                + " OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = new DBContext().getConnection();
            ps = conn.prepareStatement(sql);
            int idx = 1;
            if (keyword != null && !keyword.trim().isEmpty()) {
                String kw = "%" + keyword.trim() + "%";
                ps.setString(idx++, kw);
                ps.setString(idx++, kw);
            }
            if (genreID != null && genreID > 0) {
                ps.setInt(idx++, genreID);
            }
            if (minPrice != null) {
                ps.setBigDecimal(idx++, minPrice);
            }
            if (maxPrice != null) {
                ps.setBigDecimal(idx++, maxPrice);
            }
            ps.setInt(idx++, offset);
            ps.setInt(idx, pageSize);
            rs = ps.executeQuery();
            while (rs.next()) {
                Book b = mapBook(rs);
                b.setAuthors(getAuthorsByBookID(conn, b.getBookID()));
                books.add(b);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeAll(rs, ps, conn);
        }
        return books;
    }

    public int countBooksFiltered(String keyword, Integer genreID,
            BigDecimal minPrice, BigDecimal maxPrice) {
        StringBuilder where = new StringBuilder("WHERE b.status IN ('available', 'out_of_stock') ");
        if (keyword != null && !keyword.trim().isEmpty()) {
            where.append("AND (b.title LIKE ? OR EXISTS ("
                    + "SELECT 1 FROM BookAuthor ba2 JOIN Author a2 ON a2.authorID = ba2.authorID "
                    + "WHERE ba2.bookID = b.bookID AND a2.fullname LIKE ?)) ");
        }
        if (genreID != null && genreID > 0) {
            where.append("AND b.genreID = ? ");
        }
        if (minPrice != null) {
            where.append("AND b.price >= ? ");
        }
        if (maxPrice != null) {
            where.append("AND b.price <= ? ");
        }

        String sql = "SELECT COUNT(*) FROM Book b " + where;
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = new DBContext().getConnection();
            ps = conn.prepareStatement(sql);
            int idx = 1;
            if (keyword != null && !keyword.trim().isEmpty()) {
                String kw = "%" + keyword.trim() + "%";
                ps.setString(idx++, kw);
                ps.setString(idx++, kw);
            }
            if (genreID != null && genreID > 0) {
                ps.setInt(idx++, genreID);
            }
            if (minPrice != null) {
                ps.setBigDecimal(idx++, minPrice);
            }
            if (maxPrice != null) {
                ps.setBigDecimal(idx++, maxPrice);
            }
            rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeAll(rs, ps, conn);
        }
        return 0;
    }

    public int countBooks() {
        String sql = "SELECT COUNT(*) FROM Book WHERE status IN ('available', 'out_of_stock')";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = new DBContext().getConnection();
            ps = conn.prepareStatement(sql);
            rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeAll(rs, ps, conn);
        }
        return 0;
    }

    public Book getBookByID(int bookID) {
        String sql = BASE_SELECT + "WHERE b.bookID = ? " + GROUP_BY;
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = new DBContext().getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, bookID);
            rs = ps.executeQuery();
            if (rs.next()) {
                Book b = mapBook(rs);
                b.setAuthors(getAuthorsByBookID(conn, bookID));
                return b;
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeAll(rs, ps, conn);
        }
        return null;
    }

    public List<Book> getFeaturedByOrders(int limit) {
        List<Book> books = new ArrayList<>();
        String sql = "SELECT TOP (?) b.bookID, b.title, b.description, b.price, b.stock_quantity, "
                + "       b.thumbnail, b.total_pages, b.dimensions, b.weight, b.status, "
                + "       g.genreID, g.genre_name, c.contentID, c.content_name, "
                + "       s.seriesID, s.series_name, o.originID, o.origin_name, "
                + "       b.created_at, b.updated_at, "
                + "       ISNULL(AVG(CAST(r.rating AS FLOAT)), 0) AS avg_rating, "
                + "       COUNT(DISTINCT r.reviewID) AS review_count "
                + "FROM Book b "
                + "LEFT JOIN Genre      g  ON b.genreID   = g.genreID "
                + "LEFT JOIN Content    c  ON b.contentID = c.contentID "
                + "LEFT JOIN BookSeries s  ON b.seriesID  = s.seriesID "
                + "LEFT JOIN BookOrigin o  ON b.originID  = o.originID "
                + "LEFT JOIN Review     r  ON b.bookID    = r.bookID "
                + "WHERE b.status IN ('available', 'out_of_stock') "
                + "GROUP BY b.bookID, b.title, b.description, b.price, b.stock_quantity, "
                + "         b.thumbnail, b.total_pages, b.dimensions, b.weight, b.status, "
                + "         g.genreID, g.genre_name, c.contentID, c.content_name, "
                + "         s.seriesID, s.series_name, o.originID, o.origin_name, "
                + "         b.created_at, b.updated_at "
                + "ORDER BY ("
                + "  SELECT ISNULL(SUM(od.quantity), 0) FROM OrderDetail od "
                + "  INNER JOIN [Order] ord ON ord.orderID = od.orderID "
                + "  WHERE od.bookID = b.bookID "
                + "  AND ord.status = 'completed'"
                + ") DESC, avg_rating DESC";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = new DBContext().getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, limit);
            rs = ps.executeQuery();
            while (rs.next()) {
                Book b = mapBook(rs);
                b.setFeatured(true);
                b.setAuthors(getAuthorsByBookID(conn, b.getBookID()));
                books.add(b);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeAll(rs, ps, conn);
        }
        return books;
    }

    public List<Book> getNewBooks(int limit) {
        List<Book> books = new ArrayList<>();
        String sql = BASE_SELECT + "WHERE b.status IN ('available', 'out_of_stock') " + GROUP_BY
                + " ORDER BY b.created_at DESC OFFSET 0 ROWS FETCH NEXT ? ROWS ONLY";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = new DBContext().getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, limit);
            rs = ps.executeQuery();
            while (rs.next()) {
                Book b = mapBook(rs);
                b.setAuthors(getAuthorsByBookID(conn, b.getBookID()));
                books.add(b);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeAll(rs, ps, conn);
        }
        return books;
    }

    public List<Book> getFeaturedBooks(int limit) {
        return getFeaturedByOrders(limit);
    }

    public List<Book> getRelatedBooks(int bookID, int genreID, int limit) {
        List<Book> books = new ArrayList<>();
        String sql = BASE_SELECT
                + "WHERE b.status IN ('available', 'out_of_stock') AND b.bookID <> ? AND b.genreID = ? "
                + GROUP_BY + " ORDER BY review_count DESC "
                + " OFFSET 0 ROWS FETCH NEXT ? ROWS ONLY";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = new DBContext().getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, bookID);
            ps.setInt(2, genreID);
            ps.setInt(3, limit);
            rs = ps.executeQuery();
            while (rs.next()) {
                Book b = mapBook(rs);
                b.setAuthors(getAuthorsByBookID(conn, b.getBookID()));
                books.add(b);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeAll(rs, ps, conn);
        }
        return books;
    }

    public int countAllBooks() {
        String sql = "SELECT COUNT(*) FROM Book";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = new DBContext().getConnection();
            ps = conn.prepareStatement(sql);
            rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeAll(rs, ps, conn);
        }
        return 0;
    }

    public int countBooksByStatus(String status) {
        return countBooksByStatus(status, null, null);
    }

    public int countAllBooks(java.sql.Timestamp from, java.sql.Timestamp to) {
        String sql = "SELECT COUNT(*) FROM Book WHERE 1=1";
        if (from != null) {
            sql += " AND created_at >= ?";
        }
        if (to != null) {
            sql += " AND created_at < ?";
        }
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = new DBContext().getConnection();
            ps = conn.prepareStatement(sql);
            int idx = 1;
            if (from != null) {
                ps.setTimestamp(idx++, from);
            }
            if (to != null) {
                ps.setTimestamp(idx, to);
            }
            rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeAll(rs, ps, conn);
        }
        return 0;
    }

    public int countBooksByStatus(String status, java.sql.Timestamp from, java.sql.Timestamp to) {
        String sql = "SELECT COUNT(*) FROM Book WHERE status = ?";
        if (from != null) {
            sql += " AND created_at >= ?";
        }
        if (to != null) {
            sql += " AND created_at < ?";
        }
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = new DBContext().getConnection();
            ps = conn.prepareStatement(sql);
            int idx = 1;
            ps.setString(idx++, status);
            if (from != null) {
                ps.setTimestamp(idx++, from);
            }
            if (to != null) {
                ps.setTimestamp(idx, to);
            }
            rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeAll(rs, ps, conn);
        }
        return 0;
    }

    public List<Book> getRecentBooksAdmin(int limit) {
        return getRecentBooksAdmin(limit, null, null);
    }

    public List<Book> getRecentBooksAdmin(int limit, java.sql.Timestamp from, java.sql.Timestamp to) {
        List<Book> books = new ArrayList<>();
        String sql = BASE_SELECT + "WHERE 1=1 ";
        if (from != null) {
            sql += "AND b.created_at >= ? ";
        }
        if (to != null) {
            sql += "AND b.created_at < ? ";
        }
        sql += GROUP_BY
                + " ORDER BY b.created_at DESC OFFSET 0 ROWS FETCH NEXT ? ROWS ONLY";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = new DBContext().getConnection();
            ps = conn.prepareStatement(sql);
            int idx = 1;
            if (from != null) {
                ps.setTimestamp(idx++, from);
            }
            if (to != null) {
                ps.setTimestamp(idx++, to);
            }
            ps.setInt(idx, limit);
            rs = ps.executeQuery();
            while (rs.next()) {
                Book b = mapBook(rs);
                b.setAuthors(getAuthorsByBookID(conn, b.getBookID()));
                books.add(b);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeAll(rs, ps, conn);
        }
        return books;
    }

    public List<Book> getBooksAdmin(int offset, int pageSize, String keyword,
            String status, Integer genreID) {
        List<Book> books = new ArrayList<>();
        StringBuilder where = new StringBuilder("WHERE 1=1 ");
        if (keyword != null && !keyword.trim().isEmpty()) {
            where.append("AND (b.title LIKE ? OR b.bookID = ?) ");
        }
        if (status != null && !status.isEmpty()) {
            where.append("AND b.status = ? ");
        }
        if (genreID != null && genreID > 0) {
            where.append("AND b.genreID = ? ");
        }

        String sql = BASE_SELECT + where + GROUP_BY
                + " ORDER BY b.created_at DESC OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = new DBContext().getConnection();
            ps = conn.prepareStatement(sql);
            int idx = 1;
            if (keyword != null && !keyword.trim().isEmpty()) {
                ps.setString(idx++, "%" + keyword.trim() + "%");
                try {
                    ps.setInt(idx++, Integer.parseInt(keyword.trim()));
                } catch (Exception ex) {
                    ps.setInt(idx - 1, -1);
                }
            }
            if (status != null && !status.isEmpty()) {
                ps.setString(idx++, status);
            }
            if (genreID != null && genreID > 0) {
                ps.setInt(idx++, genreID);
            }
            ps.setInt(idx++, offset);
            ps.setInt(idx, pageSize);
            rs = ps.executeQuery();
            while (rs.next()) {
                Book b = mapBook(rs);
                b.setAuthors(getAuthorsByBookID(conn, b.getBookID()));
                books.add(b);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeAll(rs, ps, conn);
        }
        return books;
    }

    public int countBooksAdmin(String keyword, String status, Integer genreID) {
        StringBuilder where = new StringBuilder("WHERE 1=1 ");
        if (keyword != null && !keyword.trim().isEmpty()) {
            where.append("AND (b.title LIKE ? OR b.bookID = ?) ");
        }
        if (status != null && !status.isEmpty()) {
            where.append("AND b.status = ? ");
        }
        if (genreID != null && genreID > 0) {
            where.append("AND b.genreID = ? ");
        }

        String sql = "SELECT COUNT(*) FROM Book b " + where;
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = new DBContext().getConnection();
            ps = conn.prepareStatement(sql);
            int idx = 1;
            if (keyword != null && !keyword.trim().isEmpty()) {
                ps.setString(idx++, "%" + keyword.trim() + "%");
                try {
                    ps.setInt(idx++, Integer.parseInt(keyword.trim()));
                } catch (Exception ex) {
                    ps.setInt(idx - 1, -1);
                }
            }
            if (status != null && !status.isEmpty()) {
                ps.setString(idx++, status);
            }
            if (genreID != null && genreID > 0) {
                ps.setInt(idx++, genreID);
            }
            rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeAll(rs, ps, conn);
        }
        return 0;
    }

    public Map<Integer, String> getGenreMap() {
        Map<Integer, String> map = new LinkedHashMap<>();
        try (Connection conn = new DBContext().getConnection();
                PreparedStatement ps = conn
                        .prepareStatement("SELECT genreID, genre_name FROM Genre ORDER BY genre_name");
                ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                map.put(rs.getInt("genreID"), rs.getString("genre_name"));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return map;
    }

    public Map<Integer, String> getOriginMap() {
        Map<Integer, String> map = new LinkedHashMap<>();
        try (Connection conn = new DBContext().getConnection();
                PreparedStatement ps = conn
                        .prepareStatement("SELECT originID, origin_name FROM BookOrigin ORDER BY origin_name");
                ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                map.put(rs.getInt("originID"), rs.getString("origin_name"));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return map;
    }

    public Map<Integer, String> getContentMap() {
        Map<Integer, String> map = new LinkedHashMap<>();
        try (Connection conn = new DBContext().getConnection();
                PreparedStatement ps = conn
                        .prepareStatement("SELECT contentID, content_name FROM Content ORDER BY content_name");
                ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                map.put(rs.getInt("contentID"), rs.getString("content_name"));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return map;
    }

    public Map<Integer, String> getSeriesMap() {
        Map<Integer, String> map = new LinkedHashMap<>();
        try (Connection conn = new DBContext().getConnection();
                PreparedStatement ps = conn
                        .prepareStatement("SELECT seriesID, series_name FROM BookSeries ORDER BY series_name");
                ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                map.put(rs.getInt("seriesID"), rs.getString("series_name"));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return map;
    }

    public boolean createBook(Book b, String authorsStr, int createdBy) {
        String sql = "INSERT INTO Book (title, description, price, stock_quantity, thumbnail, "
                + "total_pages, dimensions, weight, status, genreID, contentID, seriesID, originID, created_by) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        Connection conn = null;
        PreparedStatement ps = null;
        try {
            conn = new DBContext().getConnection();
            ps = conn.prepareStatement(sql, PreparedStatement.RETURN_GENERATED_KEYS);
            ps.setString(1, b.getTitle());
            ps.setString(2, b.getDescription());
            ps.setBigDecimal(3, b.getPrice());
            ps.setInt(4, b.getStockQuantity());
            ps.setString(5, b.getThumbnail());
            if (b.getTotalPages() > 0) {
                ps.setInt(6, b.getTotalPages());
            } else {
                ps.setNull(6, Types.INTEGER);
            }
            ps.setString(7, b.getDimensions());
            if (b.getWeight() != null) {
                ps.setBigDecimal(8, b.getWeight());
            } else {
                ps.setNull(8, Types.DECIMAL);
            }
            ps.setString(9, b.getStatus() != null ? b.getStatus() : "available");
            if (b.getGenreID() > 0) {
                ps.setInt(10, b.getGenreID());
            } else {
                ps.setNull(10, Types.INTEGER);
            }
            if (b.getContentID() > 0) {
                ps.setInt(11, b.getContentID());
            } else {
                ps.setNull(11, Types.INTEGER);
            }
            if (b.getSeriesID() > 0) {
                ps.setInt(12, b.getSeriesID());
            } else {
                ps.setNull(12, Types.INTEGER);
            }
            if (b.getOriginID() > 0) {
                ps.setInt(13, b.getOriginID());
            } else {
                ps.setNull(13, Types.INTEGER);
            }
            ps.setInt(14, createdBy);
            int rows = ps.executeUpdate();
            if (rows > 0) {
                ResultSet keys = ps.getGeneratedKeys();
                if (keys.next()) {
                    int newBookID = keys.getInt(1);
                    syncAuthors(conn, newBookID, authorsStr);
                }
                return true;
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeAll(null, ps, conn);
        }
        return false;
    }

    public boolean updateBook(Book b, String authorsStr, int updatedBy) {
        String sql = "UPDATE Book SET title=?, description=?, price=?, stock_quantity=?, thumbnail=?, "
                + "total_pages=?, dimensions=?, weight=?, status=?, genreID=?, contentID=?, "
                + "seriesID=?, originID=?, updated_by=?, updated_at=GETDATE() WHERE bookID=?";
        Connection conn = null;
        PreparedStatement ps = null;
        try {
            conn = new DBContext().getConnection();
            ps = conn.prepareStatement(sql);
            ps.setString(1, b.getTitle());
            ps.setString(2, b.getDescription());
            ps.setBigDecimal(3, b.getPrice());
            ps.setInt(4, b.getStockQuantity());
            ps.setString(5, b.getThumbnail());
            if (b.getTotalPages() > 0) {
                ps.setInt(6, b.getTotalPages());
            } else {
                ps.setNull(6, Types.INTEGER);
            }
            ps.setString(7, b.getDimensions());
            if (b.getWeight() != null) {
                ps.setBigDecimal(8, b.getWeight());
            } else {
                ps.setNull(8, Types.DECIMAL);
            }
            ps.setString(9, b.getStatus());
            if (b.getGenreID() > 0) {
                ps.setInt(10, b.getGenreID());
            } else {
                ps.setNull(10, Types.INTEGER);
            }
            if (b.getContentID() > 0) {
                ps.setInt(11, b.getContentID());
            } else {
                ps.setNull(11, Types.INTEGER);
            }
            if (b.getSeriesID() > 0) {
                ps.setInt(12, b.getSeriesID());
            } else {
                ps.setNull(12, Types.INTEGER);
            }
            if (b.getOriginID() > 0) {
                ps.setInt(13, b.getOriginID());
            } else {
                ps.setNull(13, Types.INTEGER);
            }
            ps.setInt(14, updatedBy);
            ps.setInt(15, b.getBookID());
            boolean ok = ps.executeUpdate() > 0;
            if (ok) {
                syncAuthors(conn, b.getBookID(), authorsStr);
            }
            return ok;
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeAll(null, ps, conn);
        }
        return false;
    }

    public boolean deleteBook(int bookID, int updatedBy) {
        String sql = "UPDATE Book SET status='discontinued', updated_by=?, updated_at=GETDATE() WHERE bookID=?";
        Connection conn = null;
        PreparedStatement ps = null;
        try {
            conn = new DBContext().getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, updatedBy);
            ps.setInt(2, bookID);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeAll(null, ps, conn);
        }
        return false;
    }

    private void syncAuthors(Connection conn, int bookID, String authorsStr) throws SQLException {
        if (authorsStr == null || authorsStr.trim().isEmpty()) {
            return;
        }
        // Delete liên kết cũ
        try (PreparedStatement ps = conn.prepareStatement("DELETE FROM BookAuthor WHERE bookID = ?")) {
            ps.setInt(1, bookID);
            ps.executeUpdate();
        }
        String[] names = authorsStr.split(",");
        for (String name : names) {
            name = name.trim();
            if (name.isEmpty()) {
                continue;
            }
            int authorID = getOrCreateAuthor(conn, name);
            if (authorID > 0) {
                try (PreparedStatement ps = conn.prepareStatement(
                        "INSERT INTO BookAuthor (bookID, authorID) VALUES (?, ?)")) {
                    ps.setInt(1, bookID);
                    ps.setInt(2, authorID);
                    ps.executeUpdate();
                }
            }
        }
    }

    private int getOrCreateAuthor(Connection conn, String fullname) throws SQLException {
        try (PreparedStatement ps = conn.prepareStatement(
                "SELECT authorID FROM Author WHERE fullname = ?")) {
            ps.setString(1, fullname);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt("authorID");
            }
        }
        try (PreparedStatement ps = conn.prepareStatement(
                "INSERT INTO Author (fullname) VALUES (?)", PreparedStatement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, fullname);
            ps.executeUpdate();
            ResultSet keys = ps.getGeneratedKeys();
            if (keys.next()) {
                return keys.getInt(1);
            }
        }
        return -1;

    }

    public String validatePurchaseQuantity(int bookID, int requestedQty) {
        Book book = getBookByID(bookID);
        if (book == null) {
            return "Book does not exist";
        }
        if (!"available".equals(book.getStatus()) || book.getStockQuantity() <= 0) {
            return "Book is out of stock";
        }
        if (requestedQty < 1) {
            return "Invalid quantity";
        }
        if (requestedQty > book.getStockQuantity()) {
            return "Only " + book.getStockQuantity() + " copies remain in stock";
        }
        return null;
    }

    public String validateWishlistAdd(int bookID) {
        Book book = getBookByID(bookID);
        if (book == null) {
            return "Book does not exist";
        }
        if ("discontinued".equals(book.getStatus())) {
            return "This discontinued book cannot be added to the wishlist";
        }
        return null;
    }

    public boolean deductStockForOrder(List<model.CartItem> items) {
        if (items == null || items.isEmpty()) {
            return true;
        }
        Connection conn = null;
        PreparedStatement ps = null;
        try {
            conn = new DBContext().getConnection();
            conn.setAutoCommit(false);
            String sql = "UPDATE Book SET stock_quantity = stock_quantity - ?, "
                    + "status = CASE WHEN (stock_quantity - ?) <= 0 THEN 'out_of_stock' ELSE status END, "
                    + "updated_at = GETDATE() "
                    + "WHERE bookID = ? AND stock_quantity >= ? AND status = 'available'";
            ps = conn.prepareStatement(sql);
            for (model.CartItem item : items) {
                ps.setInt(1, item.getQuantity());
                ps.setInt(2, item.getQuantity());
                ps.setInt(3, item.getBookID());
                ps.setInt(4, item.getQuantity());
                if (ps.executeUpdate() <= 0) {
                    conn.rollback();
                    return false;
                }
            }
            conn.commit();
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            if (conn != null) {
                try {
                    conn.rollback();
                } catch (SQLException ex) {
                    ex.printStackTrace();
                }
            }
        } finally {
            if (ps != null) {
                try {
                    ps.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
            if (conn != null) {
                try {
                    conn.setAutoCommit(true);
                    conn.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
        }
        return false;
    }

    public boolean restoreBook(int bookID, int updatedBy) {

        String sql = "UPDATE Book SET status = CASE WHEN stock_quantity > 0 THEN 'available' ELSE 'out_of_stock' END, "
                + "updated_by=?, updated_at=GETDATE() WHERE bookID=?";
        Connection conn = null;
        PreparedStatement ps = null;
        try {
            conn = new DBContext().getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, updatedBy);
            ps.setInt(2, bookID);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeAll(null, ps, conn);
        }
        return false;
    }

    private Book mapBook(ResultSet rs) throws SQLException {
        Book b = new Book();
        b.setBookID(rs.getInt("bookID"));
        b.setTitle(rs.getString("title"));
        b.setDescription(rs.getString("description"));
        b.setPrice(rs.getBigDecimal("price"));
        b.setStockQuantity(rs.getInt("stock_quantity"));
        b.setThumbnail(rs.getString("thumbnail"));
        b.setTotalPages(rs.getInt("total_pages"));
        b.setDimensions(rs.getString("dimensions"));
        b.setWeight(rs.getBigDecimal("weight"));
        b.setStatus(rs.getString("status"));
        b.setGenreID(rs.getInt("genreID"));
        b.setGenreName(rs.getString("genre_name"));
        b.setContentID(rs.getInt("contentID"));
        b.setContentName(rs.getString("content_name"));
        b.setSeriesID(rs.getInt("seriesID"));
        b.setSeriesName(rs.getString("series_name"));
        b.setOriginID(rs.getInt("originID"));
        b.setOriginName(rs.getString("origin_name"));
        b.setCreatedAt(rs.getTimestamp("created_at"));
        b.setUpdatedAt(rs.getTimestamp("updated_at"));
        b.setAvgRating(rs.getDouble("avg_rating"));
        b.setReviewCount(rs.getInt("review_count"));
        return b;
    }

    private List<String> getAuthorsByBookID(Connection conn, int bookID) throws SQLException {
        List<String> authors = new ArrayList<>();
        String sql = "SELECT a.fullname FROM Author a "
                + "JOIN BookAuthor ba ON a.authorID = ba.authorID WHERE ba.bookID = ?";
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            ps = conn.prepareStatement(sql);
            ps.setInt(1, bookID);
            rs = ps.executeQuery();
            while (rs.next()) {
                authors.add(rs.getString("fullname"));
            }
        } finally {
            if (rs != null)
                try {
                    rs.close();
                } catch (Exception e) {
                    e.printStackTrace();
                }
            if (ps != null)
                try {
                    ps.close();
                } catch (Exception e) {
                    e.printStackTrace();
                }
        }
        return authors;
    }

    private void closeAll(ResultSet rs, PreparedStatement ps, Connection conn) {
        if (rs != null)
            try {
                rs.close();
            } catch (Exception e) {
                e.printStackTrace();
            }
        if (ps != null)
            try {
                ps.close();
            } catch (Exception e) {
                e.printStackTrace();
            }
        if (conn != null)
            try {
                conn.close();
            } catch (Exception e) {
                e.printStackTrace();
            }
    }
}