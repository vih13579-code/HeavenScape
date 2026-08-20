package dao;

import model.CartItem;
import model.Order;
import model.OrderDetail;
import utils.DBContext;

import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class OrderDAO {

    private static final String BASE_SELECT_ORDER
            = "SELECT o.orderID, o.customerID, o.addressID, o.processed_by, o.status, "
            + "       o.payment_method, o.payment_status, o.total_price, o.created_at, o.cancel_reason, "
            + "       a.street, a.district, a.city, a.recipient_name, a.recipient_phone "
            + "FROM [Order] o "
            + "LEFT JOIN Address a ON a.addressID = o.addressID ";

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
                + "       b.title, b.thumbnail "
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
                details.add(d);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return details;
    }

    public boolean cancelOrder(int orderID, int customerID, String cancelReason) {
        String sql = "UPDATE [Order] SET status = 'cancelled', cancel_reason = ? "
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
                + "WHERE orderID = ? AND payment_status = 'pending_refund'";
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
                    boolean isVnpay = "vnpay".equalsIgnoreCase(overdueOrder.getPaymentMethod());
                    boolean isPaid = "paid".equalsIgnoreCase(overdueOrder.getPaymentStatus());
                    if (isVnpay && isPaid) {
                        String autoCancelReason = "Order was not approved within two days";
                        String sqlAutoCancel = "UPDATE [Order] SET status = 'cancelled', cancel_reason = ? WHERE orderID = ?";
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
                        String sqlAutoCancel = "UPDATE [Order] SET status = 'cancelled', cancel_reason = ? WHERE orderID = ?";
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
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean updateOrderStatusAndStaff(int orderID, String status, int staffID, String cancelReason) {
        String sql = "UPDATE [Order] SET status = ?, processed_by = ?, cancel_reason = ? WHERE orderID = ?";
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

    public int createOrderWithStockCheck(int customerID, int addressID, String paymentMethod,
            BigDecimal totalPrice, List<CartItem> cartItems) {

        String sqlCheckStock = "SELECT stock_quantity FROM Book WHERE bookID = ?";
        String sqlOrder = "INSERT INTO [Order] (customerID, addressID, status, payment_method, "
                + "payment_status, total_price, created_at) "
                + "VALUES (?, ?, N'pending', ?, 'unpaid', ?, GETDATE())";
        String sqlDetail = "INSERT INTO OrderDetail (orderID, bookID, quantity, unit_price) "
                + "VALUES (?, ?, ?, ?)";

        Connection conn = null;
        try {
            conn = new DBContext().getConnection();
            conn.setAutoCommit(false);

            for (CartItem item : cartItems) {
                try (PreparedStatement psCheck = conn.prepareStatement(sqlCheckStock)) {
                    psCheck.setInt(1, item.getBookID());
                    try (ResultSet rs = psCheck.executeQuery()) {
                        if (rs.next()) {
                            int currentStock = rs.getInt("stock_quantity");
                            if (currentStock < item.getQuantity()) {
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

            int orderID = -1;
            try (PreparedStatement psOrder = conn.prepareStatement(sqlOrder, PreparedStatement.RETURN_GENERATED_KEYS)) {
                psOrder.setInt(1, customerID);
                psOrder.setInt(2, addressID);
                psOrder.setString(3, paymentMethod);
                psOrder.setBigDecimal(4, totalPrice);
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
        String sqlRestore = "UPDATE Book "
                + "SET Book.stock_quantity = Book.stock_quantity + OrderDetail.quantity "
                + "FROM Book "
                + "INNER JOIN OrderDetail ON Book.bookID = OrderDetail.bookID "
                + "WHERE OrderDetail.orderID = ?";

        String sqlUpdateStatus = "UPDATE Book "
                + "SET Book.status = 'available' "
                + "FROM Book "
                + "INNER JOIN OrderDetail ON Book.bookID = OrderDetail.bookID "
                + "WHERE OrderDetail.orderID = ? "
                + "AND Book.stock_quantity > 0 "
                + "AND (Book.status IS NULL OR Book.status <> 'discontinued')";

        try (Connection conn = new DBContext().getConnection()) {
            try (PreparedStatement ps1 = conn.prepareStatement(sqlRestore)) {
                ps1.setInt(1, orderID);
                int rows = ps1.executeUpdate();
                if (rows > 0) {
                    try (PreparedStatement ps2 = conn.prepareStatement(sqlUpdateStatus)) {
                        ps2.setInt(1, orderID);
                        ps2.executeUpdate();
                    }
                    return true;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
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
