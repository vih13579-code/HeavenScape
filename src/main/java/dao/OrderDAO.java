package dao;

import model.CartItem;
import model.CheckoutIssue;
import model.CheckoutResult;
import model.CheckoutSnapshot;
import model.Order;
import model.OrderDetail;
import utils.DBContext;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.Comparator;
import java.util.List;
import java.util.Locale;
import java.util.Objects;

public class OrderDAO {

    private static final String CANCELLED_BY_NAME_SELECT
            = "CASE "
            + "WHEN LOWER(LTRIM(RTRIM(o.cancelled_by))) = 'system' THEN 'System' "
            + "WHEN LOWER(LTRIM(RTRIM(o.cancelled_by))) = 'staff' THEN 'Staff' "
            + "WHEN LOWER(LTRIM(RTRIM(o.cancelled_by))) = 'user' THEN c.fullname "
            + "WHEN LOWER(LTRIM(RTRIM(o.status))) = 'cancelled' AND o.processed_by IS NOT NULL THEN 'Staff' "
            + "WHEN LOWER(LTRIM(RTRIM(o.status))) = 'cancelled' THEN c.fullname "
            + "ELSE NULL END AS cancelledByName, ";

    private static final String BASE_SELECT_ORDER
            = "SELECT o.orderID, o.customerID, o.addressID, o.processed_by, o.status, "
            + "       o.payment_method, o.payment_status, o.total_price, o.created_at, o.cancel_reason, "
            + "       o.cancelled_by, o.voucherID, "
            + CANCELLED_BY_NAME_SELECT
            + "       a.street, a.district, a.city, a.recipient_name, a.recipient_phone "
            + "FROM [Order] o "
            + "LEFT JOIN Address a ON a.addressID = o.addressID "
            + "LEFT JOIN Customer c ON c.customerID = o.customerID ";

    public int createOrder(int customerID, int addressID,
            String paymentMethod, BigDecimal totalPrice) {

        String sql = "INSERT INTO [Order] (customerID, addressID, status, payment_method, "
                + "payment_status, total_price, created_at) "
                + "VALUES (?, ?, N'pending', ?, ?, ?, GETDATE())";

        String paymentStatus = "unpaid";

        try (Connection conn = new DBContext().getConnection(); PreparedStatement ps = conn.prepareStatement(sql, PreparedStatement.RETURN_GENERATED_KEYS)) {

            ps.setInt(1, customerID);
            ps.setInt(2, addressID);
            ps.setString(3, paymentMethod);
            ps.setString(4, paymentStatus);
            ps.setBigDecimal(5, totalPrice);
            ps.executeUpdate();

            ResultSet rs = ps.getGeneratedKeys();
            if (rs.next()) {
                return rs.getInt(1);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return -1;
    }

    public boolean createOrderDetails(int orderID, List<CartItem> cartItems) {
        String sql = "INSERT INTO OrderDetail (orderID, bookID, quantity, unit_price) "
                + "VALUES (?, ?, ?, ?)";

        try (Connection conn = new DBContext().getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            for (CartItem item : cartItems) {
                ps.setInt(1, orderID);
                ps.setInt(2, item.getBookID());
                ps.setInt(3, item.getQuantity());
                ps.setBigDecimal(4, item.getPrice());
                ps.addBatch();
            }

            ps.executeBatch();
            return true;

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }

    public boolean clearCart(int customerID) {
        String sqlDeleteItems = "DELETE CartItem FROM CartItem "
                + "JOIN Cart ON Cart.cartID = CartItem.cartID "
                + "WHERE Cart.customerID = ? AND Cart.status = 'active'";

        String sqlCloseCart = "UPDATE Cart SET status = 'checked_out' "
                + "WHERE customerID = ? AND status = 'active'";

        try (Connection conn = new DBContext().getConnection()) {

            try (PreparedStatement ps = conn.prepareStatement(sqlDeleteItems)) {
                ps.setInt(1, customerID);
                ps.executeUpdate();
            }

            try (PreparedStatement ps = conn.prepareStatement(sqlCloseCart)) {
                ps.setInt(1, customerID);
                ps.executeUpdate();
            }

            return true;

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }

    public Order getOrderByID(int orderID) {
        String sql = "SELECT o.orderID, o.customerID, o.addressID, o.processed_by, o.status, "
                + "       o.payment_method, o.payment_status, o.total_price, o.created_at, o.cancel_reason, "
                + "       o.cancelled_by, o.voucherID, "
                + CANCELLED_BY_NAME_SELECT
                + "       a.street, a.district, a.city, a.recipient_name, a.recipient_phone, "
                + "       c.fullname AS customerName, "
                + "       c.email AS customerEmail, c.phone AS customerPhone "
                + "FROM [Order] o "
                + "LEFT JOIN Address a ON a.addressID = o.addressID "
                + "LEFT JOIN Customer c ON c.customerID = o.customerID "
                + "WHERE o.orderID = ?";

        try (Connection conn = new DBContext().getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, orderID);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Order order = mapOrder(rs);
                    order.setCustomerName(rs.getString("customerName"));
                    order.setCustomerEmail(rs.getString("customerEmail"));
                    order.setCustomerPhone(rs.getString("customerPhone"));
                    order.setRecipientName(rs.getString("recipient_name"));
                    order.setRecipientPhone(rs.getString("recipient_phone"));
                    return order;
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return null;
    }

    public int countOrdersByCustomerFiltered(int customerID, String status) {
        boolean isPendingRefund = "pending_refund".equalsIgnoreCase(status);
        boolean isRefunded = "refunded".equalsIgnoreCase(status);
        boolean isRefundStatus = isPendingRefund || isRefunded;
        boolean statusIsNull = (status == null);
        boolean statusIsEmpty;
        if (statusIsNull) {
            statusIsEmpty = false;
        } else {
            statusIsEmpty = status.trim().isEmpty();
        }
        boolean statusIsAll = "all".equalsIgnoreCase(status);
        boolean noFilter = statusIsNull || statusIsEmpty || statusIsAll;
        String normalizedStatus;
        if (noFilter) {
            normalizedStatus = null;
        } else {
            normalizedStatus = status.trim();
        }

        String sql;
        if (isRefundStatus) {
            sql = "SELECT COUNT(*) FROM [Order] WHERE customerID = ? AND (? IS NULL OR payment_status = ?)";
        } else {
            sql = "SELECT COUNT(*) FROM [Order] WHERE customerID = ? AND (? IS NULL OR status = ?)";
        }

        try (Connection conn = new DBContext().getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, customerID);
            ps.setString(2, normalizedStatus);
            ps.setString(3, normalizedStatus);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    public List<Order> getOrdersByCustomerFiltered(int customerID, String status, int offset, int pageSize) {
        List<Order> orders = new ArrayList<>();
        boolean isPendingRefund = "pending_refund".equalsIgnoreCase(status);
        boolean isRefunded = "refunded".equalsIgnoreCase(status);
        boolean isRefundStatus = isPendingRefund || isRefunded;
        boolean statusIsNull = (status == null);
        boolean statusIsEmpty;
        if (statusIsNull) {
            statusIsEmpty = false;
        } else {
            statusIsEmpty = status.trim().isEmpty();
        }
        boolean statusIsAll = "all".equalsIgnoreCase(status);
        boolean noFilter = statusIsNull || statusIsEmpty || statusIsAll;
        String normalizedStatus;
        if (noFilter) {
            normalizedStatus = null;
        } else {
            normalizedStatus = status.trim();
        }

        String sql;
        if (isRefundStatus) {
            sql = BASE_SELECT_ORDER
                    + "WHERE o.customerID = ? "
                    + "AND (? IS NULL OR o.payment_status = ?) "
                    + "ORDER BY o.created_at DESC "
                    + "OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";
        } else {
            sql = BASE_SELECT_ORDER
                    + "WHERE o.customerID = ? "
                    + "AND (? IS NULL OR o.status = ?) "
                    + "ORDER BY o.created_at DESC "
                    + "OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";
        }

        try (Connection conn = new DBContext().getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, customerID);
            ps.setString(2, normalizedStatus);
            ps.setString(3, normalizedStatus);
            ps.setInt(4, offset);
            ps.setInt(5, pageSize);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                orders.add(mapOrder(rs));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return orders;
    }

    public List<OrderDetail> getOrderDetails(int orderID) {
        List<OrderDetail> details = new ArrayList<>();

        String sql = "SELECT od.orderDetailID, od.orderID, od.bookID, od.quantity, od.unit_price, "
                + "       b.title, b.thumbnail, "
                + "       (SELECT STRING_AGG(a.fullname, ', ') "
                + "        FROM BookAuthor ba "
                + "        JOIN Author a ON a.authorID = ba.authorID "
                + "        WHERE ba.bookID = b.bookID) AS authors "
                + "FROM OrderDetail od "
                + "JOIN Book b ON b.bookID = od.bookID "
                + "WHERE od.orderID = ?";

        try (Connection conn = new DBContext().getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, orderID);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                OrderDetail d = new OrderDetail();
                d.setOrderDetailID(rs.getInt("orderDetailID"));
                d.setOrderID(rs.getInt("orderID"));
                d.setBookID(rs.getInt("bookID"));
                d.setQuantity(rs.getInt("quantity"));
                d.setUnitPrice(rs.getBigDecimal("unit_price"));
                d.setTitle(rs.getString("title"));
                d.setThumbnail(rs.getString("thumbnail"));
                d.setAuthorsDisplay(rs.getString("authors"));
                details.add(d);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return details;
    }

    public boolean cancelOrder(int orderID, int customerID, String cancelReason) {
        String sql = "UPDATE [Order] SET status = 'cancelled', cancel_reason = ?, cancelled_by = 'user' "
                + "WHERE orderID = ? AND customerID = ? AND status = 'pending'";

        try (Connection conn = new DBContext().getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, cancelReason);
            ps.setInt(2, orderID);
            ps.setInt(3, customerID);
            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }

    public boolean requestCodRefund(int orderID, int customerID, String refundReason) {
        String sql = "UPDATE [Order] "
                + "SET status = 'cancelled', payment_status = 'pending_refund', cancel_reason = ?, cancelled_by = 'user' "
                + "WHERE orderID = ? AND customerID = ? "
                + "AND status = 'completed' AND payment_method = 'cod' AND payment_status = 'paid'";

        Connection conn = null;
        try {
            conn = new DBContext().getConnection();
            conn.setAutoCommit(false);

            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setString(1, refundReason);
                ps.setInt(2, orderID);
                ps.setInt(3, customerID);

                if (ps.executeUpdate() == 0) {
                    conn.rollback();
                    return false;
                }
            }

            if (!restoreStock(conn, orderID)) {
                conn.rollback();
                return false;
            }

            conn.commit();
            return true;
        } catch (Exception e) {
            if (conn != null) {
                try {
                    conn.rollback();
                } catch (Exception ignored) {
                }
            }
            e.printStackTrace();
        } finally {
            if (conn != null) {
                try {
                    conn.setAutoCommit(true);
                    conn.close();
                } catch (Exception ignored) {
                }
            }
        }
        return false;
    }

    private Order mapOrder(ResultSet rs) throws Exception {
        Order order = new Order();
        order.setOrderID(rs.getInt("orderID"));
        order.setCustomerID(rs.getInt("customerID"));
        order.setAddressID(rs.getInt("addressID"));
        order.setStatus(rs.getString("status"));
        order.setPaymentMethod(rs.getString("payment_method"));
        order.setPaymentStatus(rs.getString("payment_status"));
        order.setTotalPrice(rs.getBigDecimal("total_price"));
        order.setCreatedAt(rs.getTimestamp("created_at"));
        order.setStreet(rs.getString("street"));
        order.setDistrict(rs.getString("district"));
        order.setCity(rs.getString("city"));
        order.setRecipientName(rs.getString("recipient_name"));
        order.setRecipientPhone(rs.getString("recipient_phone"));
        int processedByVal = rs.getInt("processed_by");
        if (!rs.wasNull()) {
            order.setProcessedBy(processedByVal);
        } else {
            order.setProcessedBy(null);
        }
        try {
            order.setCancelReason(rs.getString("cancel_reason"));
        } catch (Exception ignored) {
        }
        try {
            order.setCancelledBy(rs.getString("cancelled_by"));
        } catch (Exception ignored) {
        }
        try {
            order.setCancelledByName(rs.getString("cancelledByName"));
        } catch (Exception ignored) {
        }
        try {
            int voucherID = rs.getInt("voucherID");
            order.setVoucherID(rs.wasNull() ? null : voucherID);
        } catch (Exception ignored) {
        }
        return order;
    }

    public boolean updatePaymentStatus(int orderID, String paymentStatus) {
        String sql = "UPDATE [Order] SET payment_status = ? WHERE orderID = ?";
        try (Connection conn = new DBContext().getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, paymentStatus);
            ps.setInt(2, orderID);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean confirmRefund(int orderID) {
        String sql = "UPDATE [Order] SET payment_status = 'refunded' "
                + "WHERE orderID = ? AND payment_method = 'cod' AND payment_status = 'pending_refund'";
        try (Connection conn = new DBContext().getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, orderID);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public List<Order> getAllOrders(String status, int offset, int pageSize) {
        List<Order> list = new ArrayList<>();

        String sqlGetOverdue = "SELECT orderID FROM [Order] "
                + "WHERE status = 'pending' "
                + "AND created_at < DATEADD(DAY, -2, GETDATE())";
        try (Connection conn = new DBContext().getConnection(); PreparedStatement psGet = conn.prepareStatement(sqlGetOverdue); ResultSet rsGet = psGet.executeQuery()) {

            while (rsGet.next()) {
                int overdueOrderID = rsGet.getInt("orderID");
                Order overdueOrder = getOrderByID(overdueOrderID);
                if (overdueOrder != null) {
                    boolean isCod = "cod".equalsIgnoreCase(overdueOrder.getPaymentMethod());
                    boolean isPaid = "paid".equalsIgnoreCase(overdueOrder.getPaymentStatus());
                    if (isCod && isPaid) {
                        String autoCancelReason = "Order was not approved within two days";
                        String sqlAutoCancel = "UPDATE [Order] SET status = 'cancelled', cancel_reason = ?, cancelled_by = 'system' WHERE orderID = ?";
                        try (Connection connAC = new DBContext().getConnection(); PreparedStatement psAC = connAC.prepareStatement(sqlAutoCancel)) {
                            psAC.setString(1, autoCancelReason);
                            psAC.setInt(2, overdueOrderID);
                            psAC.executeUpdate();
                        } catch (Exception eAC) {
                            eAC.printStackTrace();
                        }
                        updatePaymentStatus(overdueOrderID, "pending_refund");

                        final Order finalOrder = overdueOrder;
                        new Thread(new Runnable() {
                            @Override
                            public void run() {
                                try {
                                    utils.EmailUtil.sendRefundPendingEmail(finalOrder.getCustomerEmail(), finalOrder);
                                } catch (Exception e) {
                                    e.printStackTrace();
                                }
                            }
                        }).start();
                    } else {
                        String autoCancelReason = "Order was not approved within two days";
                        String sqlAutoCancel = "UPDATE [Order] SET status = 'cancelled', cancel_reason = ?, cancelled_by = 'system' WHERE orderID = ?";
                        try (Connection connAC = new DBContext().getConnection(); PreparedStatement psAC = connAC.prepareStatement(sqlAutoCancel)) {
                            psAC.setString(1, autoCancelReason);
                            psAC.setInt(2, overdueOrderID);
                            psAC.executeUpdate();
                        } catch (Exception eAC) {
                            eAC.printStackTrace();
                        }

                        final Order finalOverdueOrder = overdueOrder;
                        final String finalReason = autoCancelReason;
                        new Thread(new Runnable() {
                            @Override
                            public void run() {
                                try {
                                    utils.EmailUtil.sendOrderCancelledEmail(finalOverdueOrder.getCustomerEmail(), finalOverdueOrder, finalReason);
                                } catch (Exception e) {
                                    e.printStackTrace();
                                }
                            }
                        }).start();
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        boolean isPendingRefund = "pending_refund".equalsIgnoreCase(status);
        boolean isRefunded = "refunded".equalsIgnoreCase(status);
        boolean isRefundStatus = isPendingRefund || isRefunded;
        boolean statusIsNull = (status == null);
        boolean statusIsEmpty;
        if (statusIsNull) {
            statusIsEmpty = false;
        } else {
            statusIsEmpty = status.trim().isEmpty();
        }
        boolean statusIsAll = "all".equalsIgnoreCase(status);
        boolean noFilter = statusIsNull || statusIsEmpty || statusIsAll;
        String normalizedStatus;
        if (noFilter) {
            normalizedStatus = null;
        } else {
            normalizedStatus = status.trim();
        }

        String sql;
        if (isRefundStatus) {
            sql = "SELECT o.orderID, o.customerID, o.addressID, o.processed_by, o.status, "
                    + "       o.payment_method, o.payment_status, o.total_price, o.created_at, o.cancel_reason, "
                    + "       o.cancelled_by, o.voucherID, "
                    + CANCELLED_BY_NAME_SELECT
                    + "       a.street, a.district, a.city, a.recipient_name, a.recipient_phone, "
                    + "       c.fullname AS customerName, "
                    + "       c.email AS customerEmail, c.phone AS customerPhone "
                    + "FROM [Order] o "
                    + "LEFT JOIN Address a ON a.addressID = o.addressID "
                    + "LEFT JOIN Customer c ON c.customerID = o.customerID "
                    + "WHERE (? IS NULL OR o.payment_status = ?) "
                    + "ORDER BY o.created_at DESC OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";
        } else {
            sql = "SELECT o.orderID, o.customerID, o.addressID, o.processed_by, o.status, "
                    + "       o.payment_method, o.payment_status, o.total_price, o.created_at, o.cancel_reason, "
                    + "       o.cancelled_by, o.voucherID, "
                    + CANCELLED_BY_NAME_SELECT
                    + "       a.street, a.district, a.city, a.recipient_name, a.recipient_phone, "
                    + "       c.fullname AS customerName, "
                    + "       c.email AS customerEmail, c.phone AS customerPhone "
                    + "FROM [Order] o "
                    + "LEFT JOIN Address a ON a.addressID = o.addressID "
                    + "LEFT JOIN Customer c ON c.customerID = o.customerID "
                    + "WHERE (? IS NULL OR o.status = ?) "
                    + "ORDER BY o.created_at DESC OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";
        }

        try (Connection conn = new DBContext().getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, normalizedStatus);
            ps.setString(2, normalizedStatus);
            ps.setInt(3, offset);
            ps.setInt(4, pageSize);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Order order = mapOrder(rs);
                    order.setCustomerName(rs.getString("customerName"));
                    order.setCustomerEmail(rs.getString("customerEmail"));
                    order.setCustomerPhone(rs.getString("customerPhone"));
                    order.setRecipientName(rs.getString("recipient_name"));
                    order.setRecipientPhone(rs.getString("recipient_phone"));
                    list.add(order);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public int countFilteredOrders(String status) {
        boolean isPendingRefund = "pending_refund".equalsIgnoreCase(status);
        boolean isRefunded = "refunded".equalsIgnoreCase(status);
        boolean isRefundStatus = isPendingRefund || isRefunded;
        boolean statusIsNull = (status == null);
        boolean statusIsEmpty;
        if (statusIsNull) {
            statusIsEmpty = false;
        } else {
            statusIsEmpty = status.trim().isEmpty();
        }
        boolean statusIsAll = "all".equalsIgnoreCase(status);
        boolean noFilter = statusIsNull || statusIsEmpty || statusIsAll;
        String normalizedStatus;
        if (noFilter) {
            normalizedStatus = null;
        } else {
            normalizedStatus = status.trim();
        }

        String sql;
        if (isRefundStatus) {
            sql = "SELECT COUNT(*) FROM [Order] o "
                    + "LEFT JOIN Customer c ON c.customerID = o.customerID "
                    + "WHERE (? IS NULL OR o.payment_status = ?)";
        } else {
            sql = "SELECT COUNT(*) FROM [Order] o "
                    + "LEFT JOIN Customer c ON c.customerID = o.customerID "
                    + "WHERE (? IS NULL OR o.status = ?)";
        }

        try (Connection conn = new DBContext().getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, normalizedStatus);
            ps.setString(2, normalizedStatus);

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

    public int countOrdersByStatus(String status) {
        String sql;
        if ("pending_refund".equalsIgnoreCase(status) || "refunded".equalsIgnoreCase(status)) {
            sql = "SELECT COUNT(*) FROM [Order] WHERE payment_status = ?";
        } else {
            sql = "SELECT COUNT(*) FROM [Order] WHERE status = ?";
        }
        try (Connection conn = new DBContext().getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, status);
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

    public boolean updateOrderStatusAndStaff(int orderID, String status, int staffID) {
        String sql = "UPDATE [Order] SET status = ?, processed_by = ? WHERE orderID = ?";
        try (Connection conn = new DBContext().getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setInt(2, staffID);
            ps.setInt(3, orderID);
            boolean updated = ps.executeUpdate() > 0;
            if (updated && "completed".equalsIgnoreCase(status)) {
                new VoucherDAO().recordUsageForCompletedOrder(orderID);
            }
            return updated;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean updateOrderStatusAndStaff(int orderID, String status, int staffID, String cancelReason) {
        String sql = "UPDATE [Order] SET status = ?, processed_by = ?, cancel_reason = ?, cancelled_by = 'staff' WHERE orderID = ?";
        try (Connection conn = new DBContext().getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setInt(2, staffID);
            ps.setString(3, cancelReason);
            ps.setInt(4, orderID);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public int getTotalOrdersByCustomer(int customerId) {
        // Chỉ đếm đơn đã được xác nhận trở đi ko lấy status pending vì chưa chắc chắn, cancelled vì đã hủy
        String sql = "SELECT COUNT(*) FROM [Order] "
                + "WHERE customerID = ? "
                + "AND status IN ('confirmed', 'shipping', 'completed')";

        try (Connection conn = new DBContext().getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, customerId);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                return rs.getInt(1);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return 0;
    }

    public double getTotalSpentByCustomer(int customerId) {
        // Chỉ tính tiền của đơn đã hoàn tất và đã thanh toán thành công
        String sql
                = "SELECT ISNULL(SUM(total_price),0) "
                + "FROM [Order] "
                + "WHERE customerID = ? "
                + "AND status = 'completed' "
                + "AND payment_status = 'paid'";

        try (Connection conn = new DBContext().getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, customerId);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                return rs.getDouble(1);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return 0;
    }

    /**
     * Final COD validation and Order creation. The snapshot is only the set of
     * values previously shown to the customer. All official prices and totals
     * are recalculated from locked database rows in this transaction.
     */
    public CheckoutResult createCodOrderWithRevalidation(int customerID, int addressID,
            CheckoutSnapshot expected) {

        if (expected == null || expected.getItems().isEmpty()) {
            return CheckoutResult.error();
        }

        Connection conn = null;
        try {
            conn = new DBContext().getConnection();
            conn.setAutoCommit(false);
            conn.setTransactionIsolation(Connection.TRANSACTION_SERIALIZABLE);

            List<CheckoutIssue> issues = new ArrayList<>();
            validateAddress(conn, addressID, customerID, issues);

            List<CartItem> currentItems = validateBooks(conn, expected, issues);
            BigDecimal currentSubtotal = calculateSubtotal(currentItems);
            VoucherState voucher = validateVoucher(
                    conn, customerID, expected, currentSubtotal, issues);

            BigDecimal currentDiscount = voucher == null
                    ? BigDecimal.ZERO : voucher.discount;
            BigDecimal currentTotal = currentSubtotal.subtract(currentDiscount).max(BigDecimal.ZERO);

            CheckoutSnapshot current = buildCurrentSnapshot(
                    currentItems, voucher, currentSubtotal, currentDiscount, currentTotal);

            CheckoutResult.Status changedStatus = determineChangedStatus(issues);
            if (changedStatus != null) {
                conn.rollback();
                return CheckoutResult.changed(changedStatus, current, issues);
            }

            int orderID = insertValidatedOrder(
                    conn, customerID, addressID, currentTotal, currentItems,
                    voucher == null ? null : voucher.voucherID);
            if (orderID <= 0) {
                conn.rollback();
                return CheckoutResult.error();
            }

            conn.commit();
            return CheckoutResult.valid(orderID, current);
        } catch (Exception e) {
            if (conn != null) {
                try {
                    conn.rollback();
                } catch (SQLException ignored) {
                }
            }
            e.printStackTrace();
            return CheckoutResult.error();
        } finally {
            if (conn != null) {
                try {
                    conn.setAutoCommit(true);
                    conn.close();
                } catch (SQLException ignored) {
                }
            }
        }
    }

    private void validateAddress(Connection conn, int addressID, int customerID,
            List<CheckoutIssue> issues) throws SQLException {
        String sql = "SELECT customerID, street, district, city, country, "
                + "recipient_name, recipient_phone "
                + "FROM Address WITH (UPDLOCK, HOLDLOCK) WHERE addressID = ?";

        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, addressID);
            try (ResultSet rs = ps.executeQuery()) {
                if (!rs.next()
                        || rs.getInt("customerID") != customerID
                        || "__DELETED__".equals(rs.getString("country"))) {
                    issues.add(new CheckoutIssue(
                            "ADDRESS_NOT_FOUND",
                            CheckoutIssue.Severity.BLOCKED,
                            "The selected shipping address no longer exists. Please choose another shipping address."));
                    return;
                }

                String phone = rs.getString("recipient_phone");
                boolean valid = isNotBlank(rs.getString("street"))
                        && isNotBlank(rs.getString("district"))
                        && isNotBlank(rs.getString("city"))
                        && isNotBlank(rs.getString("recipient_name"))
                        && phone != null && phone.matches("^0\\d{9}$");
                if (!valid) {
                    issues.add(new CheckoutIssue(
                            "ADDRESS_INVALID",
                            CheckoutIssue.Severity.BLOCKED,
                            "The selected shipping address is no longer valid. Please review or select another shipping address."));
                }
            }
        }
    }

    private List<CartItem> validateBooks(Connection conn, CheckoutSnapshot expected,
            List<CheckoutIssue> issues) throws SQLException {
        String sql = "SELECT title, price, stock_quantity, status "
                + "FROM Book WITH (UPDLOCK, HOLDLOCK) WHERE bookID = ?";
        List<CheckoutSnapshot.Item> expectedItems = new ArrayList<>(expected.getItems());
        expectedItems.sort(Comparator.comparingInt(CheckoutSnapshot.Item::getBookID));
        List<CartItem> currentItems = new ArrayList<>();

        for (CheckoutSnapshot.Item oldItem : expectedItems) {
            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setInt(1, oldItem.getBookID());
                try (ResultSet rs = ps.executeQuery()) {
                    if (!rs.next()) {
                        issues.add(new CheckoutIssue(
                                "BOOK_NOT_FOUND",
                                CheckoutIssue.Severity.BLOCKED,
                                "'" + oldItem.getTitle() + "' no longer exists. Please review your cart."));
                        continue;
                    }

                    String currentTitle = rs.getString("title");
                    BigDecimal currentPrice = rs.getBigDecimal("price");
                    int currentStock = rs.getInt("stock_quantity");
                    String currentStatus = rs.getString("status");

                    CartItem currentItem = new CartItem();
                    currentItem.setBookID(oldItem.getBookID());
                    currentItem.setTitle(currentTitle);
                    currentItem.setQuantity(oldItem.getQuantity());
                    currentItem.setPrice(currentPrice);
                    currentItem.setStockQuantity(currentStock);
                    currentItem.setStatus(currentStatus);
                    currentItems.add(currentItem);

                    if (!"available".equalsIgnoreCase(currentStatus)) {
                        issues.add(new CheckoutIssue(
                                "BOOK_INACTIVE",
                                CheckoutIssue.Severity.BLOCKED,
                                "'" + currentTitle + "' is no longer available for sale. Please review your cart."));
                    }

                    if (oldItem.getQuantity() < 1 || currentStock < oldItem.getQuantity()) {
                        issues.add(new CheckoutIssue(
                                "INSUFFICIENT_STOCK",
                                CheckoutIssue.Severity.BLOCKED,
                                "'" + currentTitle + "' only has " + currentStock
                                        + " item(s) left, which is not enough for your requested quantity ("
                                        + oldItem.getQuantity() + "). Please update your cart."));
                    }

                    if (!sameMoney(oldItem.getUnitPrice(), currentPrice)) {
                        issues.add(new CheckoutIssue(
                                "BOOK_PRICE_CHANGED",
                                CheckoutIssue.Severity.REVIEW_REQUIRED,
                                "The price of '" + currentTitle + "' has changed from "
                                        + formatMoney(oldItem.getUnitPrice()) + " VND to "
                                        + formatMoney(currentPrice)
                                        + " VND. Your order total has been updated. Please review your order before continuing."));
                    }
                }
            }
        }
        return currentItems;
    }

    private VoucherState validateVoucher(Connection conn, int customerID,
            CheckoutSnapshot expected, BigDecimal subtotal,
            List<CheckoutIssue> issues) throws SQLException {
        if (expected.getVoucherID() == null) {
            return null;
        }

        String sql = "SELECT v.voucherID, v.code, v.discount_percent, v.quantity, "
                + "v.start_date, v.end_date, v.status, v.is_deleted, "
                + "v.min_order_value, v.max_discount_value, "
                + "(SELECT COUNT(*) FROM [Order] usedOrder WITH (UPDLOCK, HOLDLOCK) "
                + " WHERE usedOrder.voucherID = v.voucherID "
                + " AND LOWER(LTRIM(RTRIM(usedOrder.status))) = 'completed') AS used_count, "
                + "(SELECT COUNT(*) FROM [Order] own WITH (UPDLOCK, HOLDLOCK) "
                + " WHERE own.voucherID = v.voucherID AND own.customerID = ? "
                + " AND LOWER(LTRIM(RTRIM(own.status))) = 'completed') AS customer_used "
                + "FROM Voucher v WITH (UPDLOCK, HOLDLOCK) WHERE v.voucherID = ?";

        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, customerID);
            ps.setInt(2, expected.getVoucherID());
            try (ResultSet rs = ps.executeQuery()) {
                if (!rs.next() || rs.getBoolean("is_deleted")) {
                    addRemovedVoucherIssue(issues, "VOUCHER_DELETED",
                            "Voucher '" + expected.getVoucherCode()
                                    + "' is no longer available and has been removed from your order.",
                            expected, subtotal);
                    return null;
                }

                VoucherState current = mapVoucherState(rs, subtotal);
                Timestamp now = new Timestamp(System.currentTimeMillis());

                if (!"active".equalsIgnoreCase(rs.getString("status"))) {
                    addRemovedVoucherIssue(issues, "VOUCHER_INACTIVE",
                            "Voucher '" + current.code
                                    + "' is no longer active and has been removed from your order.",
                            expected, subtotal);
                    return null;
                }
                if (current.startDate != null && current.startDate.after(now)) {
                    addRemovedVoucherIssue(issues, "VOUCHER_NOT_STARTED",
                            "Voucher '" + current.code
                                    + "' is not active yet and has been removed from your order.",
                            expected, subtotal);
                    return null;
                }
                if (current.endDate != null && current.endDate.before(now)) {
                    addRemovedVoucherIssue(issues, "VOUCHER_EXPIRED",
                            "Voucher '" + current.code
                                    + "' has expired and has been removed from your order.",
                            expected, subtotal);
                    return null;
                }
                if (current.minOrderValue != null
                        && subtotal.compareTo(current.minOrderValue) < 0) {
                    addRemovedVoucherIssue(issues, "VOUCHER_MINIMUM_CHANGED",
                            "The minimum order requirement for voucher '" + current.code
                                    + "' has changed. Your order is no longer eligible for this voucher.",
                            expected, subtotal);
                    return null;
                }
                if ((current.quantity != null && rs.getInt("used_count") >= current.quantity)
                        || rs.getInt("customer_used") > 0) {
                    addRemovedVoucherIssue(issues, "VOUCHER_INELIGIBLE",
                            "Your order no longer meets the requirements for voucher '"
                                    + current.code + "'. The voucher has been removed from your order.",
                            expected, subtotal);
                    return null;
                }

                compareVoucherTerms(expected, current, subtotal, issues);
                return current;
            }
        }
    }

    private VoucherState mapVoucherState(ResultSet rs, BigDecimal subtotal) throws SQLException {
        VoucherState current = new VoucherState();
        current.voucherID = rs.getInt("voucherID");
        current.code = rs.getString("code");
        current.discountPercent = rs.getBigDecimal("discount_percent");
        current.quantity = rs.getObject("quantity") == null ? null : rs.getInt("quantity");
        current.startDate = rs.getTimestamp("start_date");
        current.endDate = rs.getTimestamp("end_date");
        current.minOrderValue = rs.getBigDecimal("min_order_value");
        current.maxDiscountValue = rs.getBigDecimal("max_discount_value");
        current.discount = subtotal.multiply(current.discountPercent)
                .divide(BigDecimal.valueOf(100), 2, RoundingMode.HALF_UP);
        if (current.maxDiscountValue != null) {
            current.discount = current.discount.min(current.maxDiscountValue);
        }
        current.discount = current.discount.min(subtotal).max(BigDecimal.ZERO);
        return current;
    }

    private void compareVoucherTerms(CheckoutSnapshot expected, VoucherState current,
            BigDecimal subtotal, List<CheckoutIssue> issues) {
        BigDecimal newTotal = subtotal.subtract(current.discount).max(BigDecimal.ZERO);

        if (!sameMoney(expected.getVoucherDiscountPercent(), current.discountPercent)) {
            issues.add(new CheckoutIssue(
                    "VOUCHER_DISCOUNT_CHANGED",
                    CheckoutIssue.Severity.REVIEW_REQUIRED,
                    "The discount for voucher '" + current.code + "' has changed from "
                            + formatMoney(expected.getDiscount()) + " VND to "
                            + formatMoney(current.discount) + " VND. Your payment total has been updated from "
                            + formatMoney(expected.getTotal()) + " VND to "
                            + formatMoney(newTotal)
                            + " VND. Please review your order before continuing."));
        }

        if (!sameNullableMoney(expected.getVoucherMinOrderValue(), current.minOrderValue)) {
            issues.add(new CheckoutIssue(
                    "VOUCHER_MINIMUM_CHANGED",
                    CheckoutIssue.Severity.REVIEW_REQUIRED,
                    "The minimum order requirement for voucher '" + current.code
                            + "' has changed. Your order total has been recalculated. Please review your order before continuing."));
        }

        if (!sameNullableMoney(expected.getVoucherMaxDiscountValue(), current.maxDiscountValue)) {
            issues.add(new CheckoutIssue(
                    "VOUCHER_MAX_DISCOUNT_CHANGED",
                    CheckoutIssue.Severity.REVIEW_REQUIRED,
                    "The maximum discount for voucher '" + current.code
                            + "' has changed. Your discount amount and payment total have been recalculated. Please review your order before continuing."));
        }

        boolean otherTermsChanged = !Objects.equals(expected.getVoucherCode(), current.code)
                || !Objects.equals(expected.getVoucherQuantity(), current.quantity)
                || !Objects.equals(expected.getVoucherStartDate(), current.startDate)
                || !Objects.equals(expected.getVoucherEndDate(), current.endDate);
        if (otherTermsChanged) {
            issues.add(new CheckoutIssue(
                    "VOUCHER_TERMS_CHANGED",
                    CheckoutIssue.Severity.REVIEW_REQUIRED,
                    "The conditions for voucher '" + current.code
                            + "' have changed. Your payment total has been recalculated. Please review your order before continuing."));
        }
    }

    private void addRemovedVoucherIssue(List<CheckoutIssue> issues, String code,
            String reason, CheckoutSnapshot expected, BigDecimal subtotal) {
        issues.add(new CheckoutIssue(
                code,
                CheckoutIssue.Severity.REVIEW_REQUIRED,
                reason + " Your payment total has changed from "
                        + formatMoney(expected.getTotal()) + " VND to "
                        + formatMoney(subtotal)
                        + " VND. Please review your order before continuing."));
    }

    private CheckoutSnapshot buildCurrentSnapshot(List<CartItem> items,
            VoucherState voucher, BigDecimal subtotal, BigDecimal discount,
            BigDecimal total) {
        List<CheckoutSnapshot.Item> snapshotItems = new ArrayList<>();
        for (CartItem item : items) {
            snapshotItems.add(new CheckoutSnapshot.Item(
                    item.getBookID(), item.getTitle(), item.getQuantity(), item.getPrice()));
        }

        return new CheckoutSnapshot(
                snapshotItems,
                voucher == null ? null : voucher.voucherID,
                voucher == null ? null : voucher.code,
                voucher == null ? null : voucher.discountPercent,
                voucher == null ? null : voucher.quantity,
                voucher == null ? null : voucher.startDate,
                voucher == null ? null : voucher.endDate,
                voucher == null ? null : voucher.minOrderValue,
                voucher == null ? null : voucher.maxDiscountValue,
                subtotal, discount, total);
    }

    private CheckoutResult.Status determineChangedStatus(List<CheckoutIssue> issues) {
        boolean reviewRequired = false;
        for (CheckoutIssue issue : issues) {
            if (issue.getSeverity() == CheckoutIssue.Severity.BLOCKED) {
                return CheckoutResult.Status.BLOCKED;
            }
            reviewRequired = true;
        }
        return reviewRequired ? CheckoutResult.Status.REVIEW_REQUIRED : null;
    }

    private int insertValidatedOrder(Connection conn, int customerID, int addressID,
            BigDecimal total, List<CartItem> items, Integer voucherID) throws SQLException {
        String sqlOrder = "INSERT INTO [Order] (customerID, addressID, status, payment_method, "
                + "payment_status, total_price, created_at, voucherID) "
                + "VALUES (?, ?, N'pending', 'cod', 'unpaid', ?, GETDATE(), ?)";
        String sqlDetail = "INSERT INTO OrderDetail (orderID, bookID, quantity, unit_price) "
                + "VALUES (?, ?, ?, ?)";

        int orderID = -1;
        try (PreparedStatement ps = conn.prepareStatement(
                sqlOrder, PreparedStatement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, customerID);
            ps.setInt(2, addressID);
            ps.setBigDecimal(3, total);
            if (voucherID == null) {
                ps.setNull(4, java.sql.Types.INTEGER);
            } else {
                ps.setInt(4, voucherID);
            }
            ps.executeUpdate();
            try (ResultSet rs = ps.getGeneratedKeys()) {
                if (rs.next()) {
                    orderID = rs.getInt(1);
                }
            }
        }

        if (orderID <= 0) {
            return -1;
        }

        try (PreparedStatement ps = conn.prepareStatement(sqlDetail)) {
            for (CartItem item : items) {
                ps.setInt(1, orderID);
                ps.setInt(2, item.getBookID());
                ps.setInt(3, item.getQuantity());
                ps.setBigDecimal(4, item.getPrice());
                ps.addBatch();
            }
            ps.executeBatch();
        }
        return orderID;
    }

    private BigDecimal calculateSubtotal(List<CartItem> items) {
        BigDecimal subtotal = BigDecimal.ZERO;
        for (CartItem item : items) {
            if (item.getPrice() != null && item.getQuantity() > 0) {
                subtotal = subtotal.add(
                        item.getPrice().multiply(BigDecimal.valueOf(item.getQuantity())));
            }
        }
        return subtotal;
    }

    private boolean isNotBlank(String value) {
        return value != null && !value.trim().isEmpty();
    }

    private boolean sameMoney(BigDecimal left, BigDecimal right) {
        return left != null && right != null && left.compareTo(right) == 0;
    }

    private boolean sameNullableMoney(BigDecimal left, BigDecimal right) {
        return left == null ? right == null : right != null && left.compareTo(right) == 0;
    }

    private String formatMoney(BigDecimal amount) {
        if (amount == null) {
            return "0";
        }
        return String.format(Locale.US, "%,.0f", amount.setScale(0, RoundingMode.HALF_UP));
    }

    private static class VoucherState {

        private int voucherID;
        private String code;
        private BigDecimal discountPercent;
        private Integer quantity;
        private Timestamp startDate;
        private Timestamp endDate;
        private BigDecimal minOrderValue;
        private BigDecimal maxDiscountValue;
        private BigDecimal discount;
    }

    public int createOrderWithStockCheck(int customerID, int addressID, String paymentMethod,
            BigDecimal totalPrice, List<CartItem> cartItems) {

        return createOrderWithStockCheck(customerID, addressID, paymentMethod,
                totalPrice, cartItems, null);
    }

    public int createOrderWithStockCheck(int customerID, int addressID, String paymentMethod,
            BigDecimal totalPrice, List<CartItem> cartItems, Integer voucherID) {

        String sqlCheckAddress = "SELECT 1 FROM Address WITH (UPDLOCK, HOLDLOCK) "
                + "WHERE addressID = ? AND customerID = ? AND (country IS NULL OR country <> '__DELETED__') "
                + "AND NULLIF(LTRIM(RTRIM(street)), '') IS NOT NULL "
                + "AND NULLIF(LTRIM(RTRIM(district)), '') IS NOT NULL "
                + "AND NULLIF(LTRIM(RTRIM(city)), '') IS NOT NULL "
                + "AND NULLIF(LTRIM(RTRIM(recipient_name)), '') IS NOT NULL "
                + "AND recipient_phone LIKE '0[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'";
        String sqlCheckStock = "SELECT stock_quantity, status FROM Book WITH (UPDLOCK, HOLDLOCK) WHERE bookID = ?";
        String sqlCheckVoucher = "SELECT v.status, v.start_date, v.end_date, v.quantity, v.min_order_value, "
                + "(SELECT COUNT(*) FROM [Order] usedOrder WITH (UPDLOCK, HOLDLOCK) WHERE usedOrder.voucherID = v.voucherID AND LOWER(LTRIM(RTRIM(usedOrder.status))) = 'completed') AS used_count, "
                + "(SELECT COUNT(*) FROM [Order] own WITH (UPDLOCK, HOLDLOCK) WHERE own.voucherID = v.voucherID AND own.customerID = ? AND LOWER(LTRIM(RTRIM(own.status))) = 'completed') AS customer_used "
                + "FROM Voucher v WITH (UPDLOCK, HOLDLOCK) WHERE v.voucherID = ? AND v.is_deleted = 0";
        String sqlOrder = "INSERT INTO [Order] (customerID, addressID, status, payment_method, "
                + "payment_status, total_price, created_at, voucherID) "
                + "VALUES (?, ?, N'pending', ?, 'unpaid', ?, GETDATE(), ?)";
        String sqlDetail = "INSERT INTO OrderDetail (orderID, bookID, quantity, unit_price) "
                + "VALUES (?, ?, ?, ?)";

        Connection conn = null;
        try {
            conn = new DBContext().getConnection();
            conn.setAutoCommit(false);
            conn.setTransactionIsolation(Connection.TRANSACTION_SERIALIZABLE);

            try (PreparedStatement psAddress = conn.prepareStatement(sqlCheckAddress)) {
                psAddress.setInt(1, addressID);
                psAddress.setInt(2, customerID);
                try (ResultSet rs = psAddress.executeQuery()) {
                    if (!rs.next()) {
                        conn.rollback();
                        return -3;
                    }
                }
            }

            for (CartItem item : cartItems) {
                try (PreparedStatement psCheck = conn.prepareStatement(sqlCheckStock)) {
                    psCheck.setInt(1, item.getBookID());
                    try (ResultSet rs = psCheck.executeQuery()) {
                        if (rs.next()) {
                            int currentStock = rs.getInt("stock_quantity");
                            if (currentStock < item.getQuantity()
                                    || item.getQuantity() < 1
                                    || !"available".equalsIgnoreCase(rs.getString("status"))) {
                                conn.rollback();
                                return -2;
                            }
                        } else {
                            conn.rollback();
                            return -2;
                        }
                    }
                }
            }

            if (voucherID != null) {
                BigDecimal subtotal = BigDecimal.ZERO;
                for (CartItem item : cartItems) {
                    subtotal = subtotal.add(item.getPrice().multiply(BigDecimal.valueOf(item.getQuantity())));
                }
                java.sql.Timestamp now = new java.sql.Timestamp(System.currentTimeMillis());
                try (PreparedStatement psVoucher = conn.prepareStatement(sqlCheckVoucher)) {
                    psVoucher.setInt(1, customerID);
                    psVoucher.setInt(2, voucherID);
                    try (ResultSet rs = psVoucher.executeQuery()) {
                        boolean invalid = !rs.next();
                        if (!invalid) {
                            invalid = !"active".equalsIgnoreCase(rs.getString("status"))
                                    || (rs.getTimestamp("start_date") != null && rs.getTimestamp("start_date").after(now))
                                    || (rs.getTimestamp("end_date") != null && rs.getTimestamp("end_date").before(now))
                                    || (rs.getObject("quantity") != null && rs.getInt("used_count") >= rs.getInt("quantity"))
                                    || rs.getInt("customer_used") > 0
                                    || (rs.getBigDecimal("min_order_value") != null
                                        && subtotal.compareTo(rs.getBigDecimal("min_order_value")) < 0);
                        }
                        if (invalid) {
                            conn.rollback();
                            return -4;
                        }
                    }
                }
            }

            int orderID = -1;
            try (PreparedStatement psOrder = conn.prepareStatement(sqlOrder, PreparedStatement.RETURN_GENERATED_KEYS)) {
                psOrder.setInt(1, customerID);
                psOrder.setInt(2, addressID);
                psOrder.setString(3, paymentMethod);
                psOrder.setBigDecimal(4, totalPrice);
                if (voucherID == null) {
                    psOrder.setNull(5, java.sql.Types.INTEGER);
                } else {
                    psOrder.setInt(5, voucherID);
                }
                psOrder.executeUpdate();

                try (ResultSet rs = psOrder.getGeneratedKeys()) {
                    if (rs.next()) {
                        orderID = rs.getInt(1);
                    }
                }
            }

            if (orderID == -1) {
                conn.rollback();
                return -1;
            }

            for (CartItem item : cartItems) {
                try (PreparedStatement psDetail = conn.prepareStatement(sqlDetail)) {
                    psDetail.setInt(1, orderID);
                    psDetail.setInt(2, item.getBookID());
                    psDetail.setInt(3, item.getQuantity());
                    psDetail.setBigDecimal(4, item.getPrice());
                    psDetail.executeUpdate();
                }
            }

            conn.commit();
            return orderID;

        } catch (Exception e) {
            if (conn != null) {
                try {
                    conn.rollback();
                } catch (Exception ignored) {
                }
            }
            e.printStackTrace();
        } finally {
            if (conn != null) {
                try {
                    conn.setAutoCommit(true);
                    conn.close();
                } catch (Exception ignored) {
                }
            }
        }
        return -1;
    }

    public boolean deductStock(int orderID) {
        String sqlGetDetails = "SELECT bookID, quantity FROM OrderDetail WHERE orderID = ?";
        String sqlUpdateStock = "UPDATE Book SET stock_quantity = stock_quantity - ? "
                + "WHERE bookID = ? AND stock_quantity >= ?";
        String sqlUpdateStatus = "UPDATE Book SET status = 'out_of_stock' "
                + "WHERE bookID = ? AND stock_quantity <= 0 AND (status IS NULL OR status <> 'discontinued')";

        Connection conn = null;
        try {
            conn = new DBContext().getConnection();
            conn.setAutoCommit(false);

            List<OrderDetail> details = new ArrayList<>();
            try (PreparedStatement psGet = conn.prepareStatement(sqlGetDetails)) {
                psGet.setInt(1, orderID);
                try (ResultSet rs = psGet.executeQuery()) {
                    while (rs.next()) {
                        OrderDetail d = new OrderDetail();
                        d.setBookID(rs.getInt("bookID"));
                        d.setQuantity(rs.getInt("quantity"));
                        details.add(d);
                    }
                }
            }

            if (details.isEmpty()) {
                conn.rollback();
                return false;
            }

            for (OrderDetail d : details) {
                try (PreparedStatement psUpdate = conn.prepareStatement(sqlUpdateStock)) {
                    psUpdate.setInt(1, d.getQuantity());
                    psUpdate.setInt(2, d.getBookID());
                    psUpdate.setInt(3, d.getQuantity());
                    int rows = psUpdate.executeUpdate();
                    if (rows == 0) {
                        conn.rollback();
                        return false;
                    }
                }

                try (PreparedStatement psStatus = conn.prepareStatement(sqlUpdateStatus)) {
                    psStatus.setInt(1, d.getBookID());
                    psStatus.executeUpdate();
                }
            }

            conn.commit();
            return true;
        } catch (Exception e) {
            if (conn != null) {
                try {
                    conn.rollback();
                } catch (Exception ignored) {
                }
            }
            e.printStackTrace();
        } finally {
            if (conn != null) {
                try {
                    conn.setAutoCommit(true);
                    conn.close();
                } catch (Exception ignored) {
                }
            }
        }
        return false;
    }

    public boolean restoreStock(int orderID) {
        Connection conn = null;
        try {
            conn = new DBContext().getConnection();
            conn.setAutoCommit(false);

            if (!restoreStock(conn, orderID)) {
                conn.rollback();
                return false;
            }

            conn.commit();
            return true;
        } catch (Exception e) {
            if (conn != null) {
                try {
                    conn.rollback();
                } catch (Exception ignored) {
                }
            }

            e.printStackTrace();
        } finally {
            if (conn != null) {
                try {
                    conn.setAutoCommit(true);
                    conn.close();
                } catch (Exception ignored) {
                }
            }
        }
        return false;
    }

    public boolean cancelOrderBySystem(int orderID, String cancelReason) {
        String sql = "UPDATE [Order] SET status = 'cancelled', cancel_reason = ?, "
                + "cancelled_by = 'system' WHERE orderID = ? AND status <> 'completed'";
        try (Connection conn = new DBContext().getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, cancelReason);
            ps.setInt(2, orderID);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    private boolean restoreStock(Connection conn, int orderID) throws SQLException {
        String sqlRestore = "UPDATE b "
                + "SET stock_quantity = COALESCE(b.stock_quantity, 0) + RestoredItem.quantity "
                + "FROM Book AS b "
                + "INNER JOIN ("
                + "    SELECT bookID, SUM(quantity) AS quantity "
                + "    FROM OrderDetail WHERE orderID = ? GROUP BY bookID"
                + ") RestoredItem ON b.bookID = RestoredItem.bookID";

        String sqlUpdateStatus = "UPDATE b "
                + "SET status = 'available' "
                + "FROM Book AS b "
                + "INNER JOIN OrderDetail ON b.bookID = OrderDetail.bookID "
                + "WHERE OrderDetail.orderID = ? "
                + "AND b.stock_quantity > 0 "
                + "AND (b.status IS NULL OR b.status <> 'discontinued')";

        try (PreparedStatement ps1 = conn.prepareStatement(sqlRestore)) {
            ps1.setInt(1, orderID);
            if (ps1.executeUpdate() == 0) {
                return false;
            }
        }

        try (PreparedStatement ps2 = conn.prepareStatement(sqlUpdateStatus)) {
            ps2.setInt(1, orderID);
            ps2.executeUpdate();
        }
        return true;
    }

    public boolean updateOrderTotal(int orderID, java.math.BigDecimal newTotal) {
        String sql = "UPDATE [Order] SET total_price = ? WHERE orderID = ? AND status = 'pending'";
        try (Connection conn = new DBContext().getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setBigDecimal(1, newTotal);
            ps.setInt(2, orderID);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
}
