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

    /*
     * Keep the common book query in one place.
     * Rating is calculated by subquery, so there is no need for a very long GROUP
     * BY.
     */
    private static final String BOOK_SELECT = "SELECT b.*, g.category_name, c.content_name, s.series_name, "
            + "o.origin_name, p.publisher_name, "
            + "ISNULL((SELECT AVG(CAST(r.rating AS FLOAT)) FROM Review r WHERE r.bookID = b.bookID), 0) AS avg_rating, "
            + "(SELECT COUNT(*) FROM Review r WHERE r.bookID = b.bookID) AS review_count "
            + "FROM Book b "
            + "LEFT JOIN Category g ON b.categoryID = g.categoryID "
            + "LEFT JOIN Content c ON b.contentID = c.contentID "
            + "LEFT JOIN BookSeries s ON b.seriesID = s.seriesID "
            + "LEFT JOIN BookOrigin o ON b.originID = o.originID "
            + "LEFT JOIN Publisher p ON b.publisherID = p.publisherID ";

    private static final String PUBLIC_STATUS = "b.status IN ('available', 'out_of_stock')";

    public List<Book> getBooks(int offset, int pageSize, String orderClause) {
        String sql = BOOK_SELECT
                + "WHERE " + PUBLIC_STATUS + " "
                + orderClause
                + " OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";

        List<Book> books = new ArrayList<>();

        try (Connection conn = new DBContext().getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, offset);
            ps.setInt(2, pageSize);

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

    public List<Book> getBooksFiltered(int offset, int pageSize, String orderClause,
            String keyword, List<Integer> categoryIDs, List<Integer> authorIDs,
            BigDecimal minPrice, BigDecimal maxPrice, List<String> availability) {

        StringBuilder sql = new StringBuilder(BOOK_SELECT)
                .append("WHERE ").append(PUBLIC_STATUS).append(" ");

        appendPublicFilters(sql, keyword, categoryIDs, authorIDs, minPrice, maxPrice,
                availability);
        sql.append(orderClause)
                .append(" OFFSET ? ROWS FETCH NEXT ? ROWS ONLY");

        List<Book> books = new ArrayList<>();

        try (Connection conn = new DBContext().getConnection();
                PreparedStatement ps = conn.prepareStatement(sql.toString())) {

            int index = bindPublicFilters(ps, 1, keyword, categoryIDs, authorIDs,
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

    public int countBooksFiltered(String keyword, List<Integer> categoryIDs,
            List<Integer> authorIDs, BigDecimal minPrice, BigDecimal maxPrice,
            List<String> availability) {

        StringBuilder sql = new StringBuilder("SELECT COUNT(*) FROM Book b WHERE ")
                .append(PUBLIC_STATUS).append(" ");

        appendPublicFilters(sql, keyword, categoryIDs, authorIDs, minPrice, maxPrice,
                availability);

        try (Connection conn = new DBContext().getConnection();
                PreparedStatement ps = conn.prepareStatement(sql.toString())) {

            bindPublicFilters(ps, 1, keyword, categoryIDs, authorIDs,
                    minPrice, maxPrice);

            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? rs.getInt(1) : 0;
            }
        } catch (Exception e) {
            e.printStackTrace();
            return 0;
        }
    }

    public int countBooks() {
        String sql = "SELECT COUNT(*) FROM Book WHERE status IN ('available', 'out_of_stock')";
        return getCount(sql);
    }

    public Book getBookByID(int bookID) {
        String sql = BOOK_SELECT + "WHERE b.bookID = ?";

        try (Connection conn = new DBContext().getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, bookID);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return readBook(conn, rs);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return null;
    }

    public List<Book> getFeaturedByOrders(int limit) {
        String sql = BOOK_SELECT
                + "WHERE " + PUBLIC_STATUS + " "
                + "AND EXISTS (SELECT 1 FROM OrderDetail sold "
                + "            JOIN [Order] completedOrder ON completedOrder.orderID = sold.orderID "
                + "            WHERE sold.bookID = b.bookID "
                + "              AND LOWER(LTRIM(RTRIM(completedOrder.status))) = 'completed') "
                + "ORDER BY (SELECT ISNULL(SUM(od.quantity), 0) "
                + "          FROM OrderDetail od "
                + "          JOIN [Order] ord ON ord.orderID = od.orderID "
                + "          WHERE od.bookID = b.bookID "
                + "            AND LOWER(LTRIM(RTRIM(ord.status))) = 'completed') DESC, "
                + "avg_rating DESC, b.bookID ASC "
                + "OFFSET 0 ROWS FETCH NEXT ? ROWS ONLY";

        List<Book> books = new ArrayList<>();

        try (Connection conn = new DBContext().getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, limit);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Book book = readBook(conn, rs);
                    book.setFeatured(true);
                    books.add(book);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return books;
    }

    public List<Book> getNewBooks(int limit) {
        String sql = BOOK_SELECT
                + "WHERE " + PUBLIC_STATUS + " "
                + "ORDER BY b.created_at DESC "
                + "OFFSET 0 ROWS FETCH NEXT ? ROWS ONLY";

        return getBooksByLimit(sql, limit);
    }

    public List<Book> getFeaturedBooks(int limit) {
        return getFeaturedByOrders(limit);
    }

    public List<Book> getRelatedBooks(int bookID, int categoryID, int limit) {
        String sql = BOOK_SELECT
                + "WHERE " + PUBLIC_STATUS + " "
                + "AND b.bookID != ? AND b.categoryID = ? "
                + "ORDER BY review_count DESC "
                + "OFFSET 0 ROWS FETCH NEXT ? ROWS ONLY";

        List<Book> books = new ArrayList<>();

        try (Connection conn = new DBContext().getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, bookID);
            ps.setInt(2, categoryID);
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
    }

    public List<Book> getRelatedBooksByGenre(int bookID, List<Integer> genreIDs, int limit) {
        if (genreIDs == null || genreIDs.isEmpty()) {
            return new ArrayList<>();
        }
        String sql = BOOK_SELECT + "WHERE " + PUBLIC_STATUS + " AND b.bookID != ? "
                + "AND EXISTS (SELECT 1 FROM BookGenre bg WHERE bg.bookID = b.bookID AND bg.genreID IN ("
                + placeholders(genreIDs.size()) + ")) ORDER BY review_count DESC "
                + "OFFSET 0 ROWS FETCH NEXT ? ROWS ONLY";
        List<Book> books = new ArrayList<>();
        try (Connection conn = new DBContext().getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            int index = 1;
            ps.setInt(index++, bookID);
            for (Integer genreID : genreIDs) {
                ps.setInt(index++, genreID);
            }
            ps.setInt(index, limit);
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

    public int countAllBooks() {
        return getCount("SELECT COUNT(*) FROM Book");
    }

    public int countBooksByStatus(String status) {
        return countBooksByStatus(status, null, null);
    }

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

            int index = bindDateRange(ps, 1, from, to);

            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? rs.getInt(1) : 0;
            }
        } catch (Exception e) {
            e.printStackTrace();
            return 0;
        }
    }

    public int countBooksByStatus(String status, Timestamp from, Timestamp to) {
        StringBuilder sql = new StringBuilder("SELECT COUNT(*) FROM Book WHERE status = ? ");

        if (from != null) {
            sql.append("AND created_at >= ? ");
        }
        if (to != null) {
            sql.append("AND created_at < ? ");
        }

        try (Connection conn = new DBContext().getConnection();
                PreparedStatement ps = conn.prepareStatement(sql.toString())) {

            int index = 1;
            ps.setString(index++, status);
            bindDateRange(ps, index, from, to);

            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? rs.getInt(1) : 0;
            }
        } catch (Exception e) {
            e.printStackTrace();
            return 0;
        }
    }

    public List<Book> getRecentBooksAdmin(int limit) {
        return getRecentBooksAdmin(limit, null, null);
    }

    public List<Book> getRecentBooksAdmin(int limit, Timestamp from, Timestamp to) {
        StringBuilder sql = new StringBuilder(BOOK_SELECT)
                .append("WHERE 1 = 1 ");

        if (from != null) {
            sql.append("AND b.created_at >= ? ");
        }
        if (to != null) {
            sql.append("AND b.created_at < ? ");
        }

        sql.append("ORDER BY b.created_at DESC ")
                .append("OFFSET 0 ROWS FETCH NEXT ? ROWS ONLY");

        List<Book> books = new ArrayList<>();

        try (Connection conn = new DBContext().getConnection();
                PreparedStatement ps = conn.prepareStatement(sql.toString())) {

            int index = bindDateRange(ps, 1, from, to);
            ps.setInt(index, limit);

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

    public List<Book> getBooksAdmin(int offset, int pageSize, String keyword,
            String status, Integer categoryID) {

        StringBuilder sql = new StringBuilder(BOOK_SELECT).append("WHERE 1 = 1 ");
        appendAdminFilters(sql, keyword, status, categoryID);
        sql.append("ORDER BY b.created_at DESC OFFSET ? ROWS FETCH NEXT ? ROWS ONLY");

        List<Book> books = new ArrayList<>();

        try (Connection conn = new DBContext().getConnection();
                PreparedStatement ps = conn.prepareStatement(sql.toString())) {

            int index = bindAdminFilters(ps, 1, keyword, status, categoryID);
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

    public int countBooksAdmin(String keyword, String status, Integer categoryID) {
        StringBuilder sql = new StringBuilder("SELECT COUNT(*) FROM Book b WHERE 1 = 1 ");
        appendAdminFilters(sql, keyword, status, categoryID);

        try (Connection conn = new DBContext().getConnection();
                PreparedStatement ps = conn.prepareStatement(sql.toString())) {

            bindAdminFilters(ps, 1, keyword, status, categoryID);

            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? rs.getInt(1) : 0;
            }
        } catch (Exception e) {
            e.printStackTrace();
            return 0;
        }
    }

    public Map<Integer, String> getCategoryMap() {
        return getLookupMap(
                "SELECT categoryID, category_name FROM Category ORDER BY category_name",
                "categoryID", "category_name");
    }

    public Map<Integer, String> getGenreMap() {
        return getLookupMap(
                "SELECT genreID, genre_name FROM Genre ORDER BY genre_name",
                "genreID", "genre_name");
    }

    public Map<Integer, String> getCatalogAuthorMap() {
        return getLookupMap(
                "SELECT DISTINCT a.authorID, a.fullname "
                        + "FROM Author a "
                        + "JOIN BookAuthor ba ON ba.authorID = a.authorID "
                        + "JOIN Book b ON b.bookID = ba.bookID "
                        + "WHERE b.status IN ('available', 'out_of_stock') "
                        + "ORDER BY a.fullname",
                "authorID", "fullname");
    }

    public Map<Integer, String> getOriginMap() {
        return getLookupMap(
                "SELECT originID, origin_name FROM BookOrigin ORDER BY origin_name",
                "originID", "origin_name");
    }

    public Map<Integer, String> getContentMap() {
        return getLookupMap(
                "SELECT contentID, content_name FROM Content ORDER BY content_name",
                "contentID", "content_name");
    }

    public Map<Integer, String> getSeriesMap() {
        return getLookupMap(
                "SELECT seriesID, series_name FROM BookSeries ORDER BY series_name",
                "seriesID", "series_name");
    }

    public Map<Integer, String> getPublisherMap() {
        return getLookupMap(
                "SELECT publisherID, publisher_name FROM Publisher ORDER BY publisher_name",
                "publisherID", "publisher_name");
    }

    public boolean createBook(Book book, String authorsStr, int createdBy) {
        return createBook(book, authorsStr, new ArrayList<>(), createdBy);
    }

    public boolean createBook(Book book, String authorsStr, List<Integer> genreIDs, int createdBy) {
        String sql = "INSERT INTO Book "
                + "(title, description, price, stock_quantity, thumbnail, total_pages, dimensions, weight, "
                + "status, categoryID, contentID, seriesID, originID, publisherID, created_by) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

        try (Connection conn = new DBContext().getConnection();
                PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            bindBookFields(ps, book);
            ps.setInt(15, createdBy);

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

    public boolean updateBook(Book book, String authorsStr, int updatedBy) {
        return updateBook(book, authorsStr, new ArrayList<>(), updatedBy);
    }

    public boolean updateBook(Book book, String authorsStr, List<Integer> genreIDs, int updatedBy) {
        String sql = "UPDATE Book SET "
                + "title=?, description=?, price=?, stock_quantity=?, thumbnail=?, total_pages=?, "
                + "dimensions=?, weight=?, status=?, categoryID=?, contentID=?, seriesID=?, originID=?, publisherID=?, "
                + "updated_by=?, updated_at=GETDATE() WHERE bookID=?";

        try (Connection conn = new DBContext().getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {

            bindBookFields(ps, book);
            ps.setInt(15, updatedBy);
            ps.setInt(16, book.getBookID());

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
    }

    public boolean deleteBook(int bookID, int updatedBy) {
        String sql = "UPDATE Book SET status='discontinued', updated_by=?, updated_at=GETDATE() WHERE bookID=?";

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

    private void syncAuthors(Connection conn, int bookID, String authorsStr) throws SQLException {
        if (authorsStr == null || authorsStr.trim().isEmpty()) {
            return;
        }

        try (PreparedStatement ps = conn.prepareStatement(
                "DELETE FROM BookAuthor WHERE bookID = ?")) {
            ps.setInt(1, bookID);
            ps.executeUpdate();
        }

        for (String rawName : authorsStr.split(",")) {
            String name = rawName.trim();
            if (name.isEmpty()) {
                continue;
            }

            int authorID = getOrCreateAuthor(conn, name);
            if (authorID <= 0) {
                continue;
            }

            try (PreparedStatement ps = conn.prepareStatement(
                    "INSERT INTO BookAuthor (bookID, authorID) VALUES (?, ?)")) {
                ps.setInt(1, bookID);
                ps.setInt(2, authorID);
                ps.executeUpdate();
            }
        }
    }

    private void syncGenres(Connection conn, int bookID, List<Integer> genreIDs) throws SQLException {
        try (PreparedStatement ps = conn.prepareStatement("DELETE FROM BookGenre WHERE bookID = ?")) {
            ps.setInt(1, bookID);
            ps.executeUpdate();
        }
        if (genreIDs == null || genreIDs.isEmpty()) {
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
        String findSql = "SELECT authorID FROM Author WHERE fullname = ?";

        try (PreparedStatement ps = conn.prepareStatement(findSql)) {
            ps.setString(1, fullname);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("authorID");
                }
            }
        }

        String insertSql = "INSERT INTO Author (fullname) VALUES (?)";

        try (PreparedStatement ps = conn.prepareStatement(insertSql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, fullname);
            ps.executeUpdate();

            try (ResultSet keys = ps.getGeneratedKeys()) {
                return keys.next() ? keys.getInt(1) : -1;
            }
        }
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

        String sql = "UPDATE Book SET "
                + "stock_quantity = stock_quantity - ?, "
                + "status = CASE WHEN stock_quantity - ? <= 0 THEN 'out_of_stock' ELSE status END, "
                + "updated_at = GETDATE() "
                + "WHERE bookID = ? AND stock_quantity >= ? AND status = 'available'";

        Connection conn = null;

        try {
            conn = new DBContext().getConnection();
            conn.setAutoCommit(false);

            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                for (model.CartItem item : items) {
                    int quantity = item.getQuantity();

                    ps.setInt(1, quantity);
                    ps.setInt(2, quantity);
                    ps.setInt(3, item.getBookID());
                    ps.setInt(4, quantity);

                    if (ps.executeUpdate() == 0) {
                        conn.rollback();
                        return false;
                    }
                }
            }

            conn.commit();
            return true;

        } catch (Exception e) {
            e.printStackTrace();
            rollbackQuietly(conn);
            return false;

        } finally {
            closeTransactionConnection(conn);
        }
    }

    public boolean restoreBook(int bookID, int updatedBy) {
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
            List<Integer> categoryIDs, List<Integer> authorIDs,
            BigDecimal minPrice, BigDecimal maxPrice, List<String> availability) {

        if (hasText(keyword)) {
            sql.append("AND (b.title LIKE ? OR EXISTS ("
                    + "SELECT 1 FROM BookAuthor ba JOIN Author a ON a.authorID = ba.authorID "
                    + "WHERE ba.bookID = b.bookID AND a.fullname LIKE ?)) ");
        }
        if (categoryIDs != null && !categoryIDs.isEmpty()) {
                sql.append("AND EXISTS (SELECT 1 FROM BookGenre bg WHERE bg.bookID = b.bookID AND bg.genreID IN (")
                    .append(placeholders(categoryIDs.size())).append(")) ");
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
            List<Integer> categoryIDs, List<Integer> authorIDs,
            BigDecimal minPrice, BigDecimal maxPrice) throws SQLException {

        if (hasText(keyword)) {
            String value = "%" + keyword.trim() + "%";
            ps.setString(index++, value);
            ps.setString(index++, value);
        }
        if (categoryIDs != null) {
            for (Integer categoryID : categoryIDs) {
                ps.setInt(index++, categoryID);
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
            String status, Integer categoryID) {

        if (hasText(keyword)) {
            sql.append("AND (b.title LIKE ? OR b.bookID = ?) ");
        }
        if (hasText(status)) {
            sql.append("AND b.status = ? ");
        }
        if (categoryID != null && categoryID > 0) {
            sql.append("AND EXISTS (SELECT 1 FROM BookGenre bg WHERE bg.bookID = b.bookID AND bg.genreID = ?) ");
        }
    }

    private int bindAdminFilters(PreparedStatement ps, int index, String keyword,
            String status, Integer categoryID) throws SQLException {

        if (hasText(keyword)) {
            String value = keyword.trim();
            ps.setString(index++, "%" + value + "%");
            ps.setInt(index++, parseBookID(value));
        }
        if (hasText(status)) {
            ps.setString(index++, status);
        }
        if (categoryID != null && categoryID > 0) {
            ps.setInt(index++, categoryID);
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

        setNullableInt(ps, 10, book.getCategoryID());
        setNullableInt(ps, 11, book.getContentID());
        setNullableInt(ps, 12, book.getSeriesID());
        setNullableInt(ps, 13, book.getOriginID());
        setNullableInt(ps, 14, book.getPublisherID());
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
        book.setGenres(getGenresByBookID(conn, book.getBookID()));
        return book;
    }

    private List<model.Genre> getGenresByBookID(Connection conn, int bookID) throws SQLException {
        List<model.Genre> genres = new ArrayList<>();
        String sql = "SELECT g.genreID, g.genre_name FROM Genre g "
                + "JOIN BookGenre bg ON bg.genreID = g.genreID WHERE bg.bookID = ? ORDER BY g.genre_name";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, bookID);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    genres.add(new model.Genre(rs.getInt("genreID"), rs.getString("genre_name")));
                }
            }
        }
        return genres;
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
        book.setCategoryID(rs.getInt("categoryID"));
        book.setCategoryName(rs.getString("category_name"));
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
    }

    private List<String> getAuthorsByBookID(Connection conn, int bookID) throws SQLException {
        String sql = "SELECT a.fullname FROM Author a "
                + "JOIN BookAuthor ba ON a.authorID = ba.authorID "
                + "WHERE ba.bookID = ?";

        List<String> authors = new ArrayList<>();

        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, bookID);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    authors.add(rs.getString("fullname"));
                }
            }
        }

        return authors;
    }

    private boolean hasText(String value) {
        return value != null && !value.trim().isEmpty();
    }

    private int parseBookID(String value) {
        try {
            return Integer.parseInt(value);
        } catch (NumberFormatException e) {
            return -1;
        }
    }

    private void rollbackQuietly(Connection conn) {
        if (conn == null) {
            return;
        }

        try {
            conn.rollback();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    private void closeTransactionConnection(Connection conn) {
        if (conn == null) {
            return;
        }

        try {
            conn.setAutoCommit(true);
            conn.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}
