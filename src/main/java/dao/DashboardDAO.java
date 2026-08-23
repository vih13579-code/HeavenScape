package dao;

import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import utils.DBContext;

public class DashboardDAO {

    private Connection getConnection() throws Exception {
        // TODO: implement
        return null;
    }

    public BigDecimal getTotalRevenue(String fromDate, String toDate, Integer genreID) {
<<<<<<< Updated upstream
        // TODO: implement
        return null;
    }

    public int getTotalOrders(String fromDate, String toDate, Integer genreID) {
        // TODO: implement
=======
        String sql;
        if (genreID == null) {
            sql = "SELECT ISNULL(SUM(o.total_price), 0) AS totalRevenue "
                    + "FROM [Order] o "
                    + "WHERE LOWER(LTRIM(RTRIM(o.status))) = 'completed' "
                    + buildDateFilter();
        } else {
            sql = "SELECT ISNULL(SUM(od.quantity * od.unit_price), 0) AS totalRevenue "
                    + "FROM [Order] o "
                    + "JOIN OrderDetail od ON od.orderID = o.orderID "
                    + "JOIN Book b ON b.bookID = od.bookID "
                    + "WHERE LOWER(LTRIM(RTRIM(o.status))) = 'completed' "
                    + buildDateFilter()
                    + buildGenreFilter(genreID);
        }

        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            setCommonParams(ps, fromDate, toDate, genreID);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getBigDecimal("totalRevenue");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return BigDecimal.ZERO;
    }

    public int getTotalOrders(String fromDate, String toDate, Integer genreID) {
        String sql = "SELECT COUNT(DISTINCT o.orderID) AS totalOrders "
                + "FROM [Order] o "
                + buildOrderDetailJoin(genreID)
                + "WHERE 1 = 1 "
                + buildDateFilter()
                + buildGenreFilter(genreID);

        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            setCommonParams(ps, fromDate, toDate, genreID);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt("totalOrders");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
>>>>>>> Stashed changes
        return 0;
    }

    public int getTotalCustomers(String fromDate, String toDate, Integer genreID) {
<<<<<<< Updated upstream
        // TODO: implement
=======
        String sql = "SELECT COUNT(DISTINCT o.customerID) AS totalCustomers "
                + "FROM [Order] o "
                + buildOrderDetailJoin(genreID)
                + "WHERE LOWER(LTRIM(RTRIM(o.status))) = 'completed' "
                + buildDateFilter()
                + buildGenreFilter(genreID);

        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            setCommonParams(ps, fromDate, toDate, genreID);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt("totalCustomers");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
>>>>>>> Stashed changes
        return 0;
    }

    public int getTotalBooks(Integer genreID) {
<<<<<<< Updated upstream
        // TODO: implement
=======
        String sql = "SELECT COUNT(*) AS totalBooks FROM Book b WHERE 1 = 1 "
            + (genreID != null ? "AND EXISTS (SELECT 1 FROM BookGenre bg "
            + "WHERE bg.bookID = b.bookID AND bg.genreID = ?) " : "");

        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            if (genreID != null) {
                ps.setInt(1, genreID);
            }
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt("totalBooks");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
>>>>>>> Stashed changes
        return 0;
    }

    public int getTotalSoldBooks(String fromDate, String toDate, Integer genreID) {
<<<<<<< Updated upstream
        // TODO: implement
=======
        String sql = "SELECT ISNULL(SUM(od.quantity), 0) AS totalSold "
                + "FROM [Order] o "
                + "JOIN OrderDetail od ON od.orderID = o.orderID "
                + "JOIN Book b ON b.bookID = od.bookID "
                + "WHERE LOWER(LTRIM(RTRIM(o.status))) = 'completed' "
                + buildDateFilter()
                + buildGenreFilter(genreID);

        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            setCommonParams(ps, fromDate, toDate, genreID);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt("totalSold");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
>>>>>>> Stashed changes
        return 0;
    }

    /**
     * LÃƒÂ¡Ã‚ÂºÃ‚Â¥y toÃƒÆ’Ã‚Â n bÃƒÂ¡Ã‚Â»Ã¢â€žÂ¢ trÃƒÂ¡Ã‚ÂºÃ‚Â¡ng thÃƒÆ’Ã‚Â¡i Ãƒâ€žÃ¢â‚¬ËœÃƒâ€ Ã‚Â¡n hÃƒÆ’Ã‚Â ng Ãƒâ€žÃ¢â‚¬Ëœang tÃƒÂ¡Ã‚Â»Ã¢â‚¬Å“n tÃƒÂ¡Ã‚ÂºÃ‚Â¡i trong database.
     * KhÃƒÆ’Ã‚Â´ng hard-code pending, processing, shipping, completed...
     */
    public Map<String, Integer> getOrderStatusSummary(
            String fromDate, String toDate, Integer genreID) {
<<<<<<< Updated upstream
        // TODO: implement
        return new HashMap<>();
    }

    public List<Map<String, Object>> getRevenueByCategory(String fromDate, String toDate, Integer genreID) {
        // TODO: implement
        return new ArrayList<Map<String, Object>>();
    }

    public List<Map<String, Object>> getTopSellingBooks(String fromDate, String toDate, Integer genreID) {
        // TODO: implement
        return new ArrayList<Map<String, Object>>();
=======

        Map<String, Integer> result = new LinkedHashMap<>();

        String sql = "SELECT "
                + "CASE "
                + "WHEN o.status IS NULL OR LTRIM(RTRIM(o.status)) = '' THEN 'unknown' "
                + "ELSE LOWER(LTRIM(RTRIM(o.status))) "
                + "END AS statusName, "
                + "COUNT(DISTINCT o.orderID) AS total "
                + "FROM [Order] o "
                + buildOrderDetailJoin(genreID)
                + "WHERE 1 = 1 "
                + buildDateFilter()
                + buildGenreFilter(genreID)
                + "GROUP BY CASE "
                + "WHEN o.status IS NULL OR LTRIM(RTRIM(o.status)) = '' THEN 'unknown' "
                + "ELSE LOWER(LTRIM(RTRIM(o.status))) "
                + "END "
                + "ORDER BY statusName";

        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            setCommonParams(ps, fromDate, toDate, genreID);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    result.put(rs.getString("statusName"), rs.getInt("total"));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return result;
    }

    public List<Map<String, Object>> getRevenueByGenre(String fromDate, String toDate, Integer genreID) {
        List<Map<String, Object>> list = new ArrayList<>();
        String sql = "SELECT TOP 6 g.genre_name, ISNULL(SUM(od.quantity * od.unit_price), 0) AS revenue "
                + "FROM [Order] o "
                + "JOIN OrderDetail od ON od.orderID = o.orderID "
                + "JOIN Book b ON b.bookID = od.bookID "
                + "JOIN BookGenre bg ON bg.bookID = b.bookID "
                + "LEFT JOIN Genre g ON g.genreID = bg.genreID "
                + "WHERE LOWER(LTRIM(RTRIM(o.status))) = 'completed' "
                + buildDateFilter()
                + buildGenreFilter(genreID)
                + "GROUP BY g.genre_name "
                + "ORDER BY revenue DESC";

        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            setCommonParams(ps, fromDate, toDate, genreID);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Map<String, Object> row = new LinkedHashMap<>();
                row.put("genreName", rs.getString("genre_name") == null ? "Other" : rs.getString("genre_name"));
                row.put("revenue", rs.getBigDecimal("revenue"));
                list.add(row);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Map<String, Object>> getTopSellingBooks(String fromDate, String toDate, Integer genreID) {
        List<Map<String, Object>> list = new ArrayList<>();
        String sql = "SELECT TOP 5 b.bookID, b.title, g.genre_name, ISNULL(SUM(od.quantity), 0) AS soldQuantity, "
                + "ISNULL(SUM(od.quantity * od.unit_price), 0) AS revenue "
                + "FROM [Order] o "
                + "JOIN OrderDetail od ON od.orderID = o.orderID "
                + "JOIN Book b ON b.bookID = od.bookID "
                + "JOIN BookGenre bg ON bg.bookID = b.bookID "
                + "LEFT JOIN Genre g ON g.genreID = bg.genreID "
                + "WHERE LOWER(LTRIM(RTRIM(o.status))) = 'completed' "
                + buildDateFilter()
                + buildGenreFilter(genreID)
                + "GROUP BY b.bookID, b.title, g.genre_name "
                + "ORDER BY soldQuantity DESC, revenue DESC";

        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            setCommonParams(ps, fromDate, toDate, genreID);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Map<String, Object> row = new LinkedHashMap<>();
                row.put("bookID", rs.getInt("bookID"));
                row.put("title", rs.getString("title"));
                row.put("genreName", rs.getString("genre_name") == null ? "Other" : rs.getString("genre_name"));
                row.put("soldQuantity", rs.getInt("soldQuantity"));
                row.put("revenue", rs.getBigDecimal("revenue"));
                list.add(row);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Map<String, Object>> getRevenueTrend(String fromDate, String toDate) {
        List<Map<String, Object>> list = new ArrayList<>();
        String sql = "SELECT CAST(o.created_at AS DATE) AS saleDate, "
                + "ISNULL(SUM(o.total_price), 0) AS revenue "
                + "FROM [Order] o "
                + "WHERE LOWER(LTRIM(RTRIM(o.status))) = 'completed' "
                + buildDateFilter()
                + "GROUP BY CAST(o.created_at AS DATE) ORDER BY saleDate";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            setCommonParams(ps, fromDate, toDate, null);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> row = new LinkedHashMap<>();
                    row.put("saleDate", rs.getDate("saleDate"));
                    row.put("revenue", rs.getBigDecimal("revenue"));
                    list.add(row);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
>>>>>>> Stashed changes
    }

    /**
     * LÃƒÂ¡Ã‚ÂºÃ‚Â¥y toÃƒÆ’Ã‚Â n bÃƒÂ¡Ã‚Â»Ã¢â€žÂ¢ Ãƒâ€žÃ¢â‚¬ËœÃƒâ€ Ã‚Â¡n hÃƒÆ’Ã‚Â ng theo bÃƒÂ¡Ã‚Â»Ã¢â€žÂ¢ lÃƒÂ¡Ã‚Â»Ã‚Âc hiÃƒÂ¡Ã‚Â»Ã¢â‚¬Â¡n tÃƒÂ¡Ã‚ÂºÃ‚Â¡i.
     * Unlimited TOP 5 vÃƒÆ’Ã‚Â  khÃƒÆ’Ã‚Â´ng loÃƒÂ¡Ã‚ÂºÃ‚Â¡i bÃƒÂ¡Ã‚Â»Ã‚Â trÃƒÂ¡Ã‚ÂºÃ‚Â¡ng thÃƒÆ’Ã‚Â¡i completed/cancelled.
     */
    public List<Map<String, Object>> getAllOrders(String fromDate, String toDate, Integer genreID) {
<<<<<<< Updated upstream
        // TODO: implement
        return new ArrayList<Map<String, Object>>();
=======
        List<Map<String, Object>> list = new ArrayList<>();

        String sql = "SELECT DISTINCT o.orderID, o.created_at, o.total_price, o.status, c.fullname "
                + "FROM [Order] o "
                + "LEFT JOIN Customer c ON c.customerID = o.customerID "
                + buildOrderDetailJoin(genreID)
                + "WHERE 1 = 1 "
                + buildDateFilter()
                + buildGenreFilter(genreID)
                + "ORDER BY o.created_at DESC, o.orderID DESC";

        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            setCommonParams(ps, fromDate, toDate, genreID);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> row = new LinkedHashMap<>();
                    row.put("orderID", rs.getInt("orderID"));
                    row.put("createdAt", rs.getTimestamp("created_at"));
                    row.put("totalPrice", rs.getBigDecimal("total_price"));
                    row.put("status", rs.getString("status"));
                    row.put("customerName",
                            rs.getString("fullname") == null
                                    ? "Customer"
                                    : rs.getString("fullname"));
                    list.add(row);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
>>>>>>> Stashed changes
    }

    /**
     * GiÃƒÂ¡Ã‚Â»Ã‚Â¯ lÃƒÂ¡Ã‚ÂºÃ‚Â¡i Ãƒâ€žÃ¢â‚¬ËœÃƒÂ¡Ã‚Â»Ã†â€™ nhÃƒÂ¡Ã‚Â»Ã‚Â¯ng chÃƒÂ¡Ã‚Â»Ã¢â‚¬â€ code cÃƒâ€¦Ã‚Â© Ãƒâ€žÃ¢â‚¬Ëœang gÃƒÂ¡Ã‚Â»Ã‚Âi khÃƒÆ’Ã‚Â´ng bÃƒÂ¡Ã‚Â»Ã¢â‚¬Â¹ lÃƒÂ¡Ã‚Â»Ã¢â‚¬â€i biÃƒÆ’Ã‚Âªn dÃƒÂ¡Ã‚Â»Ã¢â‚¬Â¹ch.
     */
    public List<Map<String, Object>> getRecentOrders(String fromDate, String toDate, Integer genreID) {
<<<<<<< Updated upstream
        // TODO: implement
        return new ArrayList<Map<String, Object>>();
    }

    private String buildOrderDetailJoin(Integer genreID) {
        // TODO: implement
        return null;
=======
        return getAllOrders(fromDate, toDate, genreID);
    }

    private String buildOrderDetailJoin(Integer genreID) {
        if (genreID == null) {
            return "";
        }
        return "JOIN OrderDetail od ON od.orderID = o.orderID JOIN Book b ON b.bookID = od.bookID ";
>>>>>>> Stashed changes
    }

    private String buildDateFilter() {
        // TODO: implement
        return null;
    }

    private String buildGenreFilter(Integer genreID) {
<<<<<<< Updated upstream
        // TODO: implement
        return null;
    }

    private void setCommonParams(PreparedStatement ps, String fromDate, String toDate, Integer genreID) throws Exception {
        // TODO: implement
=======
        return genreID != null ? "AND EXISTS (SELECT 1 FROM BookGenre bg "
            + "WHERE bg.bookID = b.bookID AND bg.genreID = ?) " : "";
    }

    private void setCommonParams(PreparedStatement ps, String fromDate, String toDate, Integer genreID) throws Exception {
        Date from = parseDate(fromDate);
        Date to = parseDate(toDate);
        int index = 1;
        ps.setDate(index++, from);
        ps.setDate(index++, from);
        ps.setDate(index++, to);
        ps.setDate(index++, to);
        if (genreID != null) {
            ps.setInt(index, genreID);
        }
>>>>>>> Stashed changes
    }

    private Date parseDate(String value) {
        // TODO: implement
        return null;
    }
}