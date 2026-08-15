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
        // TODO: implement
        return null;
    }

    public int getTotalOrders(String fromDate, String toDate, Integer genreID) {
        // TODO: implement
        return 0;
    }

    public int getTotalCustomers(String fromDate, String toDate, Integer genreID) {
        // TODO: implement
        return 0;
    }

    public int getTotalBooks(Integer genreID) {
        // TODO: implement
        return 0;
    }

    public int getTotalSoldBooks(String fromDate, String toDate, Integer genreID) {
        // TODO: implement
        return 0;
    }

    /**
     * Lấy toàn bộ trạng thái đơn hàng đang tồn tại trong database.
     * Không hard-code pending, processing, shipping, completed...
     */
    public Map<String, Integer> getOrderStatusSummary(
            String fromDate, String toDate, Integer genreID) {
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
    }

    /**
     * Lấy toàn bộ đơn hàng theo bộ lọc hiện tại.
     * Unlimited TOP 5 và không loại bỏ trạng thái completed/cancelled.
     */
    public List<Map<String, Object>> getAllOrders(String fromDate, String toDate, Integer genreID) {
        // TODO: implement
        return new ArrayList<Map<String, Object>>();
    }

    /**
     * Giữ lại để những chỗ code cũ đang gọi không bị lỗi biên dịch.
     */
    public List<Map<String, Object>> getRecentOrders(String fromDate, String toDate, Integer genreID) {
        // TODO: implement
        return new ArrayList<Map<String, Object>>();
    }

    private String buildOrderDetailJoin(Integer genreID) {
        // TODO: implement
        return null;
    }

    private String buildDateFilter() {
        // TODO: implement
        return null;
    }

    private String buildGenreFilter(Integer genreID) {
        // TODO: implement
        return null;
    }

    private void setCommonParams(PreparedStatement ps, String fromDate, String toDate, Integer genreID) throws Exception {
        // TODO: implement
    }

    private Date parseDate(String value) {
        // TODO: implement
        return null;
    }
}