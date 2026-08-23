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

<<<<<<< Updated upstream
    private static final String BASE_SELECT
            = "SELECT b.bookID, b.title, b.description, b.price, b.stock_quantity, "
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

    private static final String GROUP_BY
            = " GROUP BY b.bookID, b.title, b.description, b.price, b.stock_quantity, "
            + "          b.thumbnail, b.total_pages, b.dimensions, b.weight, b.status, "
            + "          g.genreID, g.genre_name, c.contentID, c.content_name, "
            + "          s.seriesID, s.series_name, o.originID, o.origin_name, "
            + "          b.created_at, b.updated_at ";
=======
    /*
     * Keep the common book query in one place.
     * Rating is calculated by subquery, so there is no need for a very long GROUP
     * BY.
     */
        private static final String BOOK_SELECT = "SELECT b.*, "
            + "(SELECT STRING_AGG(g2.genre_name, ', ') FROM BookGenre bg2 "
            + "JOIN Genre g2 ON g2.genreID = bg2.genreID WHERE bg2.bookID = b.bookID) AS genre_names, "
            + "c.content_name, s.series_name, o.origin_name, p.publisher_name, "
            + "ISNULL((SELECT AVG(CAST(r.rating AS FLOAT)) FROM Review r WHERE r.bookID = b.bookID), 0) AS avg_rating, "
            + "(SELECT COUNT(*) FROM Review r WHERE r.bookID = b.bookID) AS review_count "
            + "FROM Book b "
            + "LEFT JOIN Content c ON b.contentID = c.contentID "
            + "LEFT JOIN BookSeries s ON b.seriesID = s.seriesID "
            + "LEFT JOIN BookOrigin o ON b.originID = o.originID "
            + "LEFT JOIN Publisher p ON b.publisherID = p.publisherID ";
>>>>>>> Stashed changes


    public List<Book> getBooks(int offset, int pageSize, String orderClause) {
        // TODO: implement
        return new ArrayList<Book>();
    }


    public List<Book> getBooksFiltered(int offset, int pageSize, String orderClause,
<<<<<<< Updated upstream
            String keyword, Integer genreID,
            BigDecimal minPrice, BigDecimal maxPrice) {
        // TODO: implement
        return new ArrayList<Book>();
    }

    public int countBooksFiltered(String keyword, Integer genreID,
            BigDecimal minPrice, BigDecimal maxPrice) {
        // TODO: implement
        return 0;
=======
            String keyword, List<Integer> genreIDs, List<Integer> authorIDs,
            BigDecimal minPrice, BigDecimal maxPrice, List<String> availability) {

        StringBuilder sql = new StringBuilder(BOOK_SELECT)
                .append("WHERE ").append(PUBLIC_STATUS).append(" ");

        appendPublicFilters(sql, keyword, genreIDs, authorIDs, minPrice, maxPrice,
                availability);
        sql.append(orderClause)
                .append(" OFFSET ? ROWS FETCH NEXT ? ROWS ONLY");

        List<Book> books = new ArrayList<>();

        try (Connection conn = new DBContext().getConnection();
                PreparedStatement ps = conn.prepareStatement(sql.toString())) {

            int index = bindPublicFilters(ps, 1, keyword, genreIDs, authorIDs,
                    minPrice, maxPrice);
            ps.setInt(index++, offset);
            ps.setInt(index, pageSize);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    books.add(readBook(conn, rs));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return books;
    }

    public int countBooksFiltered(String keyword, List<Integer> genreIDs,
            List<Integer> authorIDs, BigDecimal minPrice, BigDecimal maxPrice,
            List<String> availability) {

        StringBuilder sql = new StringBuilder("SELECT COUNT(*) FROM Book b WHERE ")
                .append(PUBLIC_STATUS).append(" ");

        appendPublicFilters(sql, keyword, genreIDs, authorIDs, minPrice, maxPrice,
                availability);

        try (Connection conn = new DBContext().getConnection();
                PreparedStatement ps = conn.prepareStatement(sql.toString())) {

            bindPublicFilters(ps, 1, keyword, genreIDs, authorIDs,
                    minPrice, maxPrice);

            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? rs.getInt(1) : 0;
            }
        } catch (Exception e) {
            e.printStackTrace();
            return 0;
        }
>>>>>>> Stashed changes
    }

    public int countBooks() {
        // TODO: implement
        return 0;
    }


    public Book getBookByID(int bookID) {
        // TODO: implement
        return null;
    }


    public List<Book> getFeaturedByOrders(int limit) {
        // TODO: implement
        return new ArrayList<Book>();
    }


    public List<Book> getNewBooks(int limit) {
        // TODO: implement
        return new ArrayList<Book>();
    }

    public List<Book> getFeaturedBooks(int limit) {
        // TODO: implement
        return new ArrayList<Book>();
    }

<<<<<<< Updated upstream

    public List<Book> getRelatedBooks(int bookID, int genreID, int limit) {
        // TODO: implement
        return new ArrayList<Book>();
=======
    public List<Book> getRelatedBooks(int bookID, int genreID, int limit) {
        String sql = BOOK_SELECT
                + "WHERE " + PUBLIC_STATUS + " "
                + "AND b.bookID != ? AND EXISTS (SELECT 1 FROM BookGenre bg "
                + "WHERE bg.bookID = b.bookID AND bg.genreID = ?) "
                + "ORDER BY review_count DESC "
                + "OFFSET 0 ROWS FETCH NEXT ? ROWS ONLY";

        List<Book> books = new ArrayList<>();

        try (Connection conn = new DBContext().getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, bookID);
            ps.setInt(2, genreID);
            ps.setInt(3, limit);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    books.add(readBook(conn, rs));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return books;
>>>>>>> Stashed changes
    }


    public int countAllBooks() {
        // TODO: implement
        return 0;
    }

    public int countBooksByStatus(String status) {
        // TODO: implement
        return 0;
    }

<<<<<<< Updated upstream
    public int countAllBooks(java.sql.Timestamp from, java.sql.Timestamp to) {
        // TODO: implement
        return 0;
=======
    public int countAllBooks(Timestamp from, Timestamp to) {
        StringBuilder sql = new StringBuilder("SELECT COUNT(*) FROM Book WHERE 1 = 1 ");

        if (from != null) {
            sql.append("AND created_at >= ? ");
        }
        if (to != null) {
            sql.append("AND created_at < ? ");
        }

        try (Connection conn = new DBContext().getConnection();
                PreparedStatement ps = conn.prepareStatement(sql.toString())) {

            bindDateRange(ps, 1, from, to);

            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? rs.getInt(1) : 0;
            }
        } catch (Exception e) {
            e.printStackTrace();
            return 0;
        }
>>>>>>> Stashed changes
    }

    public int countBooksByStatus(String status, java.sql.Timestamp from, java.sql.Timestamp to) {
        // TODO: implement
        return 0;
    }

    public List<Book> getRecentBooksAdmin(int limit) {
        // TODO: implement
        return new ArrayList<Book>();
    }

    public List<Book> getRecentBooksAdmin(int limit, java.sql.Timestamp from, java.sql.Timestamp to) {
        // TODO: implement
        return new ArrayList<Book>();
    }


    public List<Book> getBooksAdmin(int offset, int pageSize, String keyword,
            String status, Integer genreID) {
<<<<<<< Updated upstream
        // TODO: implement
        return new ArrayList<Book>();
    }

    public int countBooksAdmin(String keyword, String status, Integer genreID) {
        // TODO: implement
        return 0;
    }

=======

        StringBuilder sql = new StringBuilder(BOOK_SELECT).append("WHERE 1 = 1 ");
        appendAdminFilters(sql, keyword, status, genreID);
        sql.append("ORDER BY b.created_at DESC OFFSET ? ROWS FETCH NEXT ? ROWS ONLY");

        List<Book> books = new ArrayList<>();

        try (Connection conn = new DBContext().getConnection();
                PreparedStatement ps = conn.prepareStatement(sql.toString())) {

            int index = bindAdminFilters(ps, 1, keyword, status, genreID);
            ps.setInt(index++, offset);
            ps.setInt(index, pageSize);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    books.add(readBook(conn, rs));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return books;
    }

    public int countBooksAdmin(String keyword, String status, Integer genreID) {
        StringBuilder sql = new StringBuilder("SELECT COUNT(*) FROM Book b WHERE 1 = 1 ");
        appendAdminFilters(sql, keyword, status, genreID);

        try (Connection conn = new DBContext().getConnection();
                PreparedStatement ps = conn.prepareStatement(sql.toString())) {

            bindAdminFilters(ps, 1, keyword, status, genreID);

            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? rs.getInt(1) : 0;
            }
        } catch (Exception e) {
            e.printStackTrace();
            return 0;
        }
    }

    public Map<Integer, String> getGenreMap() {
        return getLookupMap(
                "SELECT genreID, genre_name FROM Genre ORDER BY genre_name",
                "genreID", "genre_name");
    }
>>>>>>> Stashed changes

    public Map<Integer, String> getGenreMap() {
        // TODO: implement
        return new HashMap<>();
    }

    public Map<Integer, String> getOriginMap() {
        // TODO: implement
        return new HashMap<>();
    }

    public Map<Integer, String> getContentMap() {
        // TODO: implement
        return new HashMap<>();
    }

    public Map<Integer, String> getSeriesMap() {
        // TODO: implement
        return new HashMap<>();
    }

   
    public boolean createBook(Book b, String authorsStr, int createdBy) {
        // TODO: implement
        return false;
    }

<<<<<<< Updated upstream

    public boolean updateBook(Book b, String authorsStr, int updatedBy) {
        // TODO: implement
        return false;
=======
    public boolean createBook(Book book, String authorsStr, List<Integer> genreIDs, int createdBy) {
        String sql = "INSERT INTO Book "
                + "(title, description, price, stock_quantity, thumbnail, total_pages, dimensions, weight, "
                + "status, contentID, seriesID, originID, publisherID, created_by) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

        try (Connection conn = new DBContext().getConnection();
                PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            bindBookFields(ps, book);
            ps.setInt(14, createdBy);

            if (ps.executeUpdate() == 0) {
                return false;
            }

            try (ResultSet keys = ps.getGeneratedKeys()) {
                if (keys.next()) {
                    int bookID = keys.getInt(1);
                    syncAuthors(conn, bookID, authorsStr);
                    syncGenres(conn, bookID, genreIDs);
                }
            }
            return true;

        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean updateBook(Book book, String authorsStr, List<Integer> genreIDs, int updatedBy) {
        String sql = "UPDATE Book SET "
                + "title=?, description=?, price=?, stock_quantity=?, thumbnail=?, total_pages=?, "
                + "dimensions=?, weight=?, status=?, contentID=?, seriesID=?, originID=?, publisherID=?, "
                + "updated_by=?, updated_at=GETDATE() WHERE bookID=?";

        try (Connection conn = new DBContext().getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {

            bindBookFields(ps, book);
            ps.setInt(14, updatedBy);
            ps.setInt(15, book.getBookID());

            boolean updated = ps.executeUpdate() > 0;
            if (updated) {
                syncAuthors(conn, book.getBookID(), authorsStr);
                syncGenres(conn, book.getBookID(), genreIDs);
            }
            return updated;

        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
>>>>>>> Stashed changes
    }

    public boolean deleteBook(int bookID, int updatedBy) {
        // TODO: implement
        return false;
    }

    private void syncAuthors(Connection conn, int bookID, String authorsStr) throws SQLException {
        // TODO: implement
    }

    private void syncGenres(Connection conn, int bookID, List<Integer> genreIDs) throws SQLException {
        try (PreparedStatement ps = conn.prepareStatement(
                "DELETE FROM BookGenre WHERE bookID = ?")) {
            ps.setInt(1, bookID);
            ps.executeUpdate();
        }

        if (genreIDs == null) {
            return;
        }

        try (PreparedStatement ps = conn.prepareStatement(
                "INSERT INTO BookGenre (bookID, genreID) VALUES (?, ?)")) {
            for (Integer genreID : genreIDs) {
                if (genreID != null && genreID > 0) {
                    ps.setInt(1, bookID);
                    ps.setInt(2, genreID);
                    ps.addBatch();
                }
            }
            ps.executeBatch();
        }
    }

    private int getOrCreateAuthor(Connection conn, String fullname) throws SQLException {
        // TODO: implement
        return 0;
    }


    public String validatePurchaseQuantity(int bookID, int requestedQty) {
        // TODO: implement
        return null;
    }

    public String validateWishlistAdd(int bookID) {
        // TODO: implement
        return null;
    }


    public boolean deductStockForOrder(List<model.CartItem> items) {
        // TODO: implement
        return false;
    }

    public boolean restoreBook(int bookID, int updatedBy) {
<<<<<<< Updated upstream
        // TODO: implement
        return false;
    }

    private Book mapBook(ResultSet rs) throws SQLException {
        // TODO: implement
        return null;
=======
        String sql = "UPDATE Book SET "
                + "status = CASE WHEN stock_quantity > 0 THEN 'available' ELSE 'out_of_stock' END, "
                + "updated_by=?, updated_at=GETDATE() WHERE bookID=?";

        try (Connection conn = new DBContext().getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, updatedBy);
            ps.setInt(2, bookID);
            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    private void appendPublicFilters(StringBuilder sql, String keyword,
            List<Integer> genreIDs, List<Integer> authorIDs,
            BigDecimal minPrice, BigDecimal maxPrice, List<String> availability) {

        if (hasText(keyword)) {
            sql.append("AND (b.title LIKE ? OR EXISTS ("
                    + "SELECT 1 FROM BookAuthor ba JOIN Author a ON a.authorID = ba.authorID "
                    + "WHERE ba.bookID = b.bookID AND a.fullname LIKE ?)) ");
        }
        if (genreIDs != null && !genreIDs.isEmpty()) {
            sql.append("AND EXISTS (SELECT 1 FROM BookGenre bg "
                + "WHERE bg.bookID = b.bookID AND bg.genreID IN (")
                .append(placeholders(genreIDs.size())).append(")) ");
        }
        if (authorIDs != null && !authorIDs.isEmpty()) {
            sql.append("AND EXISTS (SELECT 1 FROM BookAuthor ba2 "
                    + "WHERE ba2.bookID = b.bookID AND ba2.authorID IN (")
                    .append(placeholders(authorIDs.size())).append(")) ");
        }
        if (minPrice != null) {
            sql.append("AND b.price >= ? ");
        }
        if (maxPrice != null) {
            sql.append("AND b.price <= ? ");
        }
        boolean availableOnly = availability != null
                && availability.contains("available")
                && !availability.contains("out_of_stock");
        boolean outOfStockOnly = availability != null
                && availability.contains("out_of_stock")
                && !availability.contains("available");
        if (availableOnly) {
            sql.append("AND b.status = 'available' AND b.stock_quantity > 0 ");
        } else if (outOfStockOnly) {
            sql.append("AND (b.status = 'out_of_stock' OR b.stock_quantity <= 0) ");
        }
    }

    private int bindPublicFilters(PreparedStatement ps, int index, String keyword,
            List<Integer> genreIDs, List<Integer> authorIDs,
            BigDecimal minPrice, BigDecimal maxPrice) throws SQLException {

        if (hasText(keyword)) {
            String value = "%" + keyword.trim() + "%";
            ps.setString(index++, value);
            ps.setString(index++, value);
        }
        if (genreIDs != null) {
            for (Integer genreID : genreIDs) {
                ps.setInt(index++, genreID);
            }
        }
        if (authorIDs != null) {
            for (Integer authorID : authorIDs) {
                ps.setInt(index++, authorID);
            }
        }
        if (minPrice != null) {
            ps.setBigDecimal(index++, minPrice);
        }
        if (maxPrice != null) {
            ps.setBigDecimal(index++, maxPrice);
        }
        return index;
    }

    private String placeholders(int count) {
        StringBuilder result = new StringBuilder();
        for (int i = 0; i < count; i++) {
            if (i > 0) {
                result.append(',');
            }
            result.append('?');
        }
        return result.toString();
    }

    private void appendAdminFilters(StringBuilder sql, String keyword,
            String status, Integer genreID) {

        if (hasText(keyword)) {
            sql.append("AND (b.title LIKE ? OR b.bookID = ?) ");
        }
        if (hasText(status)) {
            sql.append("AND b.status = ? ");
        }
        if (genreID != null && genreID > 0) {
            sql.append("AND EXISTS (SELECT 1 FROM BookGenre bg "
                    + "WHERE bg.bookID = b.bookID AND bg.genreID = ?) ");
        }
    }

    private int bindAdminFilters(PreparedStatement ps, int index, String keyword,
            String status, Integer genreID) throws SQLException {

        if (hasText(keyword)) {
            String value = keyword.trim();
            ps.setString(index++, "%" + value + "%");
            ps.setInt(index++, parseBookID(value));
        }
        if (hasText(status)) {
            ps.setString(index++, status);
        }
        if (genreID != null && genreID > 0) {
            ps.setInt(index++, genreID);
        }

        return index;
    }

    private int bindDateRange(PreparedStatement ps, int index,
            Timestamp from, Timestamp to) throws SQLException {

        if (from != null) {
            ps.setTimestamp(index++, from);
        }
        if (to != null) {
            ps.setTimestamp(index++, to);
        }
        return index;
    }

    private void bindBookFields(PreparedStatement ps, Book book) throws SQLException {
        ps.setString(1, book.getTitle());
        ps.setString(2, book.getDescription());
        ps.setBigDecimal(3, book.getPrice());
        ps.setInt(4, book.getStockQuantity());
        ps.setString(5, book.getThumbnail());

        setNullableInt(ps, 6, book.getTotalPages());
        ps.setString(7, book.getDimensions());

        if (book.getWeight() == null) {
            ps.setNull(8, Types.DECIMAL);
        } else {
            ps.setBigDecimal(8, book.getWeight());
        }

        String status = book.getStatus() == null ? "available" : book.getStatus();
        ps.setString(9, status);

        setNullableInt(ps, 10, book.getContentID());
        setNullableInt(ps, 11, book.getSeriesID());
        setNullableInt(ps, 12, book.getOriginID());
        setNullableInt(ps, 13, book.getPublisherID());
    }

    private void setNullableInt(PreparedStatement ps, int index, int value) throws SQLException {
        if (value > 0) {
            ps.setInt(index, value);
        } else {
            ps.setNull(index, Types.INTEGER);
        }
    }

    private List<Book> getBooksByLimit(String sql, int limit) {
        List<Book> books = new ArrayList<>();

        try (Connection conn = new DBContext().getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, limit);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    books.add(readBook(conn, rs));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return books;
    }

    private int getCount(String sql) {
        try (Connection conn = new DBContext().getConnection();
                PreparedStatement ps = conn.prepareStatement(sql);
                ResultSet rs = ps.executeQuery()) {

            return rs.next() ? rs.getInt(1) : 0;

        } catch (Exception e) {
            e.printStackTrace();
            return 0;
        }
    }

    private Map<Integer, String> getLookupMap(String sql, String idColumn, String nameColumn) {
        Map<Integer, String> result = new LinkedHashMap<>();

        try (Connection conn = new DBContext().getConnection();
                PreparedStatement ps = conn.prepareStatement(sql);
                ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                result.put(rs.getInt(idColumn), rs.getString(nameColumn));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return result;
    }

    private Book readBook(Connection conn, ResultSet rs) throws SQLException {
        Book book = mapBook(rs);
        book.setAuthors(getAuthorsByBookID(conn, book.getBookID()));
        return book;
    }

    private Book mapBook(ResultSet rs) throws SQLException {
        Book book = new Book();
        book.setBookID(rs.getInt("bookID"));
        book.setTitle(rs.getString("title"));
        book.setDescription(rs.getString("description"));
        book.setPrice(rs.getBigDecimal("price"));
        book.setStockQuantity(rs.getInt("stock_quantity"));
        book.setThumbnail(rs.getString("thumbnail"));
        book.setTotalPages(rs.getInt("total_pages"));
        book.setDimensions(rs.getString("dimensions"));
        book.setWeight(rs.getBigDecimal("weight"));
        book.setStatus(rs.getString("status"));
        String genreNames = rs.getString("genre_names");
        book.setGenreNames(genreNames == null || genreNames.isEmpty()
            ? new ArrayList<>() : new ArrayList<>(java.util.Arrays.asList(genreNames.split(", "))));
        book.setGenreIDs(getGenreIDsByBookID(rs.getStatement().getConnection(), rs.getInt("bookID")));
        book.setContentID(rs.getInt("contentID"));
        book.setContentName(rs.getString("content_name"));
        book.setSeriesID(rs.getInt("seriesID"));
        book.setSeriesName(rs.getString("series_name"));
        book.setOriginID(rs.getInt("originID"));
        book.setOriginName(rs.getString("origin_name"));
        book.setPublisherID(rs.getInt("publisherID"));
        book.setPublisherName(rs.getString("publisher_name"));
        book.setCreatedAt(rs.getTimestamp("created_at"));
        book.setUpdatedAt(rs.getTimestamp("updated_at"));
        book.setAvgRating(rs.getDouble("avg_rating"));
        book.setReviewCount(rs.getInt("review_count"));
        return book;
>>>>>>> Stashed changes
    }

    private List<String> getAuthorsByBookID(Connection conn, int bookID) throws SQLException {
        // TODO: implement
        return new ArrayList<String>();
    }

<<<<<<< Updated upstream
    private void closeAll(ResultSet rs, PreparedStatement ps, Connection conn) {
        // TODO: implement
=======
    private List<Integer> getGenreIDsByBookID(Connection conn, int bookID) throws SQLException {
        List<Integer> genreIDs = new ArrayList<>();
        String sql = "SELECT genreID FROM BookGenre WHERE bookID = ? ORDER BY genreID";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, bookID);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    genreIDs.add(rs.getInt("genreID"));
                }
            }
        }
        return genreIDs;
    }

    private boolean hasText(String value) {
        return value != null && !value.trim().isEmpty();
>>>>>>> Stashed changes
    }
}