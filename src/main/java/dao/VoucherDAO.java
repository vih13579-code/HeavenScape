package dao;

import model.Voucher;
import utils.DBContext;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class VoucherDAO {

    public int autoExpireVouchers() {
        String sql = "UPDATE Voucher SET status = 'expired' "
                + "WHERE end_date < GETDATE() "
                + "AND status NOT IN ('expired') "
                + "AND is_deleted = 0";
        try (Connection conn = new DBContext().getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            return ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    private String buildWhere(String keyword, String status) {
        StringBuilder w = new StringBuilder("WHERE v.is_deleted = 0 ");
        if (keyword != null && !keyword.trim().isEmpty()) {
            w.append("AND v.code LIKE ? ");
        }
        if (status != null && !status.trim().isEmpty()) {
            w.append("AND v.status = ? ");
        }
        return w.toString();
    }

    private int bindParams(PreparedStatement ps, String keyword, String status, int idx)
            throws SQLException {
        if (keyword != null && !keyword.trim().isEmpty()) {
            ps.setString(idx++, "%" + keyword.trim() + "%");
        }
        if (status != null && !status.trim().isEmpty()) {
            ps.setString(idx++, status.trim());
        }
        return idx;
    }

    public List<Voucher> getAllVouchers(String keyword, String status, int offset, int pageSize) {
        List<Voucher> list = new ArrayList<>();
        String sql = "SELECT voucherID, code, discount_percent, quantity, "
                + "start_date, end_date, status, is_deleted, usedCount, "
                + "min_order_value, max_discount_value "
                + "FROM ("
                + "  SELECT v.voucherID, v.code, v.discount_percent, v.quantity,"
                + "         v.start_date, v.end_date, v.status, v.is_deleted,"
                + "         v.min_order_value, v.max_discount_value,"
                + "         COUNT(cv.customerVoucherID) AS usedCount,"
                + "         ROW_NUMBER() OVER (ORDER BY v.voucherID DESC) AS rn"
                + "  FROM Voucher v"
                + "  LEFT JOIN CustomerVoucher cv "
                + "       ON v.voucherID = cv.voucherID AND cv.is_used = 1"
                + "  " + buildWhere(keyword, status)
                + "  GROUP BY v.voucherID, v.code, v.discount_percent, v.quantity,"
                + "           v.start_date, v.end_date, v.status, v.is_deleted,"
                + "           v.min_order_value, v.max_discount_value"
                + ") t "
                + "WHERE t.rn > ? AND t.rn <= ?";

        try (Connection conn = new DBContext().getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            int idx = bindParams(ps, keyword, status, 1);
            ps.setInt(idx++, offset);
            ps.setInt(idx, offset + pageSize);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapRow(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public int countFiltered(String keyword, String status) {
        String sql = "SELECT COUNT(*) FROM Voucher v " + buildWhere(keyword, status);
        try (Connection conn = new DBContext().getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            bindParams(ps, keyword, status, 1);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    public boolean addVoucher(String code, double discountPercent, Integer quantity,
            Timestamp startDate, Timestamp endDate, String status,
            Double minOrderValue, Double maxDiscountValue) {
        String sql = "INSERT INTO Voucher "
                + "(code, discount_percent, quantity, start_date, end_date, status, "
                + " min_order_value, max_discount_value)"
                + " VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = new DBContext().getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, code.toUpperCase().trim());
            ps.setDouble(2, discountPercent);
            setQuantityParam(ps, 3, quantity);
            ps.setTimestamp(4, startDate);
            ps.setTimestamp(5, endDate);
            ps.setString(6, status);
            setDoubleParam(ps, 7, minOrderValue);
            setDoubleParam(ps, 8, maxDiscountValue);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean updateVoucher(int voucherID, String code, double discountPercent,
            Integer quantity, Timestamp startDate, Timestamp endDate,
            String status, Double minOrderValue, Double maxDiscountValue) {
        if (isCodeExistsForOther(code, voucherID)) {
            return false;
        }

        String sql = "UPDATE Voucher SET code=?, discount_percent=?, quantity=?,"
                + " start_date=?, end_date=?, status=?,"
                + " min_order_value=?, max_discount_value=?"
                + " WHERE voucherID=? AND is_deleted=0";
        try (Connection conn = new DBContext().getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, code.toUpperCase().trim());
            ps.setDouble(2, discountPercent);
            setQuantityParam(ps, 3, quantity);
            ps.setTimestamp(4, startDate);
            ps.setTimestamp(5, endDate);
            ps.setString(6, status);
            setDoubleParam(ps, 7, minOrderValue);
            setDoubleParam(ps, 8, maxDiscountValue);
            ps.setInt(9, voucherID);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    private boolean isCodeExistsForOther(String code, int excludeVoucherID) {
        String sql = "SELECT COUNT(*) FROM Voucher "
                + "WHERE UPPER(code) = ? AND voucherID != ? AND is_deleted = 0";
        try (Connection conn = new DBContext().getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, code.toUpperCase().trim());
            ps.setInt(2, excludeVoucherID);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public int deleteVoucher(int voucherID) {
        String checkUsed = "SELECT COUNT(*) FROM CustomerVoucher WHERE voucherID = ? AND is_used = 1";
        String doDelete = "UPDATE Voucher SET is_deleted = 1 WHERE voucherID = ? AND is_deleted = 0";

        Connection conn = null;
        try {
            conn = new DBContext().getConnection();
            conn.setAutoCommit(false);

            try (PreparedStatement psCheck = conn.prepareStatement(checkUsed)) {
                psCheck.setInt(1, voucherID);
                try (ResultSet rs = psCheck.executeQuery()) {
                    if (rs.next() && rs.getInt(1) > 0) {
                        conn.rollback();
                        return -1;
                    }
                }
            }

            try (PreparedStatement psDel = conn.prepareStatement(doDelete)) {
                psDel.setInt(1, voucherID);
                int rows = psDel.executeUpdate();
                conn.commit();
                return rows > 0 ? 1 : 0;
            }
        } catch (SQLException e) {
            e.printStackTrace();
            if (conn != null) {
                try {
                    conn.rollback();
                } catch (SQLException ex) {
                    ex.printStackTrace();
                }
            }
        } finally {
            if (conn != null) {
                try {
                    conn.setAutoCommit(true);
                    conn.close();
                } catch (SQLException ex) {
                    ex.printStackTrace();
                }
            }
        }
        return 0;
    }

    public boolean toggleStatus(int voucherID, String newStatus) {
        String sql = "UPDATE Voucher SET status=? "
                + "WHERE voucherID=? AND is_deleted=0 AND status != 'expired'";
        try (Connection conn = new DBContext().getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, newStatus);
            ps.setInt(2, voucherID);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public int countTotal() {
        return countBySQL("SELECT COUNT(*) FROM Voucher WHERE is_deleted = 0");
    }

    public int countActive() {
        return countBySQL(
                "SELECT COUNT(*) FROM Voucher v "
                        + "WHERE v.is_deleted = 0 AND v.status = 'active' "
                        + "AND (v.start_date IS NULL OR v.start_date <= GETDATE()) "
                        + "AND (v.end_date   IS NULL OR v.end_date   >= GETDATE()) "
                        + "AND (v.quantity IS NULL OR v.quantity > ("
                        + "      SELECT COUNT(*) FROM CustomerVoucher cv "
                        + "      WHERE cv.voucherID = v.voucherID AND cv.is_used = 1"
                        + "    ))");
    }

    public int countExpired() {
        return countBySQL(
                "SELECT COUNT(*) FROM Voucher WHERE is_deleted = 0 AND status = 'expired'");
    }

    public int countTotalUsed() {
        return countBySQL("SELECT COUNT(*) FROM CustomerVoucher WHERE is_used = 1");
    }

    private int countBySQL(String sql) {
        try (Connection conn = new DBContext().getConnection();
                PreparedStatement ps = conn.prepareStatement(sql);
                ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    private Voucher mapRow(ResultSet rs) throws SQLException {
        double minOrd = rs.getDouble("min_order_value");
        Double minOrderValue = rs.wasNull() ? null : minOrd;

        double maxDisc = rs.getDouble("max_discount_value");
        Double maxDiscountValue = rs.wasNull() ? null : maxDisc;

        return new Voucher(
                rs.getInt("voucherID"),
                rs.getString("code"),
                rs.getDouble("discount_percent"),
                rs.getObject("quantity") != null ? rs.getInt("quantity") : null,
                rs.getTimestamp("start_date"),
                rs.getTimestamp("end_date"),
                rs.getString("status"),
                rs.getInt("usedCount"),
                rs.getBoolean("is_deleted"),
                minOrderValue,
                maxDiscountValue);
    }

    // =================================================================
    // Dữ liệu thuần phục vụ áp voucher ở trang checkout
    // (KHÔNG chứa business logic — mọi kiểm tra điều kiện nằm ở Controller)
    // =================================================================
    /**
     * Lấy voucher theo code (chưa bị xoá mềm). Trả về null nếu không tồn tại.
     */
    public Voucher getVoucherByCode(String code) {
        // Add "0 AS usedCount" để tái dùng mapRow() chung, tránh lặp lại logic map thủ
        // công (DRY)
        String sql = "SELECT voucherID, code, discount_percent, quantity, start_date, end_date, "
                + "status, is_deleted, min_order_value, max_discount_value, 0 AS usedCount "
                + "FROM Voucher WHERE UPPER(code) = ? AND is_deleted = 0";
        try (Connection conn = new DBContext().getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, code.trim().toUpperCase());
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapRow(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    /**
     * Số lượt voucher đã được sử dụng (is_used = 1), dùng để so với quantity
     * giới hạn.
     */
    public int getUsedCount(int voucherID) {
        String sql = "SELECT COUNT(*) FROM CustomerVoucher WHERE voucherID = ? AND is_used = 1";
        try (Connection conn = new DBContext().getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, voucherID);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    /**
     * Customer này đã sử dụng voucher này (is_used = 1) hay chưa.
     */
    public boolean hasCustomerUsedVoucher(int customerID, int voucherID) {
        String sql = "SELECT COUNT(*) FROM CustomerVoucher WHERE customerID = ? AND voucherID = ? AND is_used = 1";
        try (Connection conn = new DBContext().getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, customerID);
            ps.setInt(2, voucherID);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Lấy danh sách voucher khả dụng để hiển thị ở modal "Store Vouchers"
     * trên trang checkout. Điều kiện: đang active, trong thời hạn, còn lượt, và
     * khách hàng này chưa dùng.
     *
     * @param customerID ID khách đang xem checkout (dùng để lọc voucher đã dùng
     *                   rồi)
     */
    public List<Voucher> getActiveVouchers(int customerID) {
        List<Voucher> list = new ArrayList<>();
        String sql = "SELECT v.voucherID, v.code, v.discount_percent, v.quantity, "
                + "       v.start_date, v.end_date, v.status, v.is_deleted, "
                + "       v.min_order_value, v.max_discount_value, "
                + "       COUNT(cv.customerVoucherID) AS usedCount "
                + "FROM Voucher v "
                + "LEFT JOIN CustomerVoucher cv "
                + "       ON v.voucherID = cv.voucherID AND cv.is_used = 1 "
                + "WHERE v.is_deleted = 0 "
                + "  AND v.status = 'active' "
                + "  AND (v.start_date IS NULL OR v.start_date <= GETDATE()) "
                + "  AND (v.end_date IS NULL OR v.end_date >= GETDATE()) "
                // Loại bỏ voucher khách hàng này đã sử dụng rồi
                + "  AND NOT EXISTS ( "
                + "      SELECT 1 FROM CustomerVoucher used "
                + "      WHERE used.voucherID = v.voucherID "
                + "        AND used.customerID = ? "
                + "        AND used.is_used = 1 "
                + "  ) "
                + "GROUP BY v.voucherID, v.code, v.discount_percent, v.quantity, "
                + "         v.start_date, v.end_date, v.status, v.is_deleted, "
                + "         v.min_order_value, v.max_discount_value "
                // Chỉ lấy voucher còn lượt (quantity NULL = không giới hạn)
                + "HAVING v.quantity IS NULL OR COUNT(cv.customerVoucherID) < v.quantity "
                + "ORDER BY v.end_date ASC";

        try (Connection conn = new DBContext().getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, customerID);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapRow(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    /**
     * Mã trả về của {@link #insertVoucherUsage}.
     */
    public static final int USAGE_OK = 1;
    public static final int USAGE_ALREADY_USED = 0;
    public static final int USAGE_OUT_OF_QUANTITY = -1;
    public static final int USAGE_ERROR = -2;

    /**
     * Ghi nhận voucher đã được khách hàng sử dụng (gọi sau khi tạo đơn hàng
     * thành công).
     *
     * FIX race condition: bước kiểm tra (đã dùng chưa / còn lượt không) và bước
     * ghi nhận được gộp vào CÙNG MỘT transaction, dùng khóa đọc (UPDLOCK,
     * HOLDLOCK) trên các dòng liên quan để đảm bảo không có request nào khác
     * chen vào giữa lúc kiểm tra và lúc ghi. Kết hợp thêm UNIQUE constraint
     * (customerID, voucherID) ở DB làm lưới an toàn thứ 2: nếu do lý do nào đó
     * 2 transaction vẫn đụng nhau, DB sẽ chặn và ném lỗi vi phạm unique, được
     * bắt ở catch bên dưới và coi như "đã dùng rồi" thay vì lỗi hệ thống.
     *
     * @param quantity giới hạn số lượt của voucher (null = không giới hạn)
     * @return USAGE_OK / USAGE_ALREADY_USED / USAGE_OUT_OF_QUANTITY /
     *         USAGE_ERROR
     */
    public int insertVoucherUsage(int customerID, int voucherID, Integer quantity) {
        String checkCustomerUsed = "SELECT COUNT(*) FROM CustomerVoucher WITH (UPDLOCK, HOLDLOCK) "
                + "WHERE customerID = ? AND voucherID = ? AND is_used = 1";
        String checkQuantity = "SELECT COUNT(*) FROM CustomerVoucher WITH (UPDLOCK, HOLDLOCK) "
                + "WHERE voucherID = ? AND is_used = 1";
        String insert = "INSERT INTO CustomerVoucher (customerID, voucherID, is_used) VALUES (?, ?, 1)";

        Connection conn = null;
        try {
            conn = new DBContext().getConnection();
            conn.setAutoCommit(false);
            conn.setTransactionIsolation(Connection.TRANSACTION_SERIALIZABLE);

            try (PreparedStatement ps = conn.prepareStatement(checkCustomerUsed)) {
                ps.setInt(1, customerID);
                ps.setInt(2, voucherID);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next() && rs.getInt(1) > 0) {
                        conn.rollback();
                        return USAGE_ALREADY_USED;
                    }
                }
            }

            if (quantity != null) {
                try (PreparedStatement ps = conn.prepareStatement(checkQuantity)) {
                    ps.setInt(1, voucherID);
                    try (ResultSet rs = ps.executeQuery()) {
                        if (rs.next() && rs.getInt(1) >= quantity) {
                            conn.rollback();
                            return USAGE_OUT_OF_QUANTITY;
                        }
                    }
                }
            }

            try (PreparedStatement ps = conn.prepareStatement(insert)) {
                ps.setInt(1, customerID);
                ps.setInt(2, voucherID);
                ps.executeUpdate();
            }

            conn.commit();
            return USAGE_OK;

        } catch (SQLException e) {
            e.printStackTrace();
            if (conn != null) {
                try {
                    conn.rollback();
                } catch (SQLException ex) {
                    ex.printStackTrace();
                }
            }
            // SQLState bắt đầu bằng "23" = integrity constraint violation (vi phạm UNIQUE)
            if (e.getSQLState() != null && e.getSQLState().startsWith("23")) {
                return USAGE_ALREADY_USED;
            }
            return USAGE_ERROR;
        } finally {
            if (conn != null) {
                try {
                    conn.setAutoCommit(true);
                    conn.close();
                } catch (SQLException ex) {
                    ex.printStackTrace();
                }
            }
        }
    }

    private void setQuantityParam(PreparedStatement ps, int idx, Integer quantity)
            throws SQLException {
        if (quantity == null) {
            ps.setNull(idx, Types.INTEGER);
        } else {
            ps.setInt(idx, quantity);
        }
    }

    private void setDoubleParam(PreparedStatement ps, int idx, Double value)
            throws SQLException {
        if (value == null) {
            ps.setNull(idx, Types.DECIMAL);
        } else {
            ps.setDouble(idx, value);
        }
    }
}
