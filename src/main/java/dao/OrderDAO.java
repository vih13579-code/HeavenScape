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
        // TODO: implement
        return 0;
    }

    public boolean createOrderDetails(int orderID, List<CartItem> cartItems) {
        // TODO: implement
        return false;
    }

    public boolean clearCart(int customerID) {
        // TODO: implement
        return false;
    }

    public Order getOrderByID(int orderID) {
        // TODO: implement
        return null;
    }

    public int countOrdersByCustomerFiltered(int customerID, String status) {
        // TODO: implement
        return 0;
    }

    public List<Order> getOrdersByCustomerFiltered(int customerID, String status, int offset, int pageSize) {
        // TODO: implement
        return new ArrayList<Order>();
    }

    public List<OrderDetail> getOrderDetails(int orderID) {
        // TODO: implement
        return new ArrayList<OrderDetail>();
    }

    public boolean cancelOrder(int orderID, int customerID, String cancelReason) {
        // TODO: implement
        return false;
    }

    private Order mapOrder(ResultSet rs) throws Exception {
        // TODO: implement
        return null;
    }

    public boolean updatePaymentStatus(int orderID, String paymentStatus) {
        // TODO: implement
        return false;
    }

    public boolean confirmRefund(int orderID) {
        // TODO: implement
        return false;
    }

    public List<Order> getAllOrders(String status, int offset, int pageSize) {
        // TODO: implement
        return new ArrayList<Order>();
    }

    public int countFilteredOrders(String status) {
        // TODO: implement
        return 0;
    }

    public int countOrdersByStatus(String status) {
        // TODO: implement
        return 0;
    }

    public boolean updateOrderStatusAndStaff(int orderID, String status, int staffID) {
        // TODO: implement
        return false;
    }

    public boolean updateOrderStatusAndStaff(int orderID, String status, int staffID, String cancelReason) {
        // TODO: implement
        return false;
    }

    public int getTotalOrdersByCustomer(int customerId) {
        // TODO: implement
        return 0;
    }

    public double getTotalSpentByCustomer(int customerId) {
        // TODO: implement
        return 0;
    }

    public int createOrderWithStockCheck(int customerID, int addressID, String paymentMethod,
            BigDecimal totalPrice, List<CartItem> cartItems) {
        // TODO: implement
        return 0;
    }

    public boolean deductStock(int orderID) {
        // TODO: implement
        return false;
    }

    public boolean restoreStock(int orderID) {
        // TODO: implement
        return false;
    }

    public boolean updateOrderTotal(int orderID, java.math.BigDecimal newTotal) {
        // TODO: implement
        return false;
    }
}
