package dao;

import utils.DBContext;
import utils.HashMD5;
import model.Account;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Types;
import java.util.ArrayList;
import java.util.List;
import model.Customer;

public class CustomerDAO {

    // Kiểm tra email đã tồn tại trong Customer hoặc Account chưa
    public boolean isEmailExists(String email) {
        // TODO: implement
        return false;
    }

    // Add customer mới vào database
//    public boolean registerCustomer(String fullname, String email, String phone, String password) {
//        String sql = "INSERT INTO Customer (fullname, email, password, phone) VALUES (?, ?, ?, ?)";
//        try (Connection conn = new DBContext().getConnection();
//             PreparedStatement ps = conn.prepareStatement(sql)) {
//            ps.setString(1, fullname);
//            ps.setString(2, email);
//            ps.setString(3, HashMD5.hash(password));
//            ps.setString(4, phone);
//            return ps.executeUpdate() > 0;
//        } catch (Exception e) {
//            e.printStackTrace();
//        }
//        return false;
//    }
    public boolean registerCustomer(String fullname, String email, String phone, String password) {
        // TODO: implement
        return false;
    }

    public boolean updateCustomer(
            int id,
            String fullname,
            String phone,
            String gender,
            String dob) {

        String sql = "UPDATE Customer " + "SET fullname = ?, " + "phone = ?, " + "gender = ?, " + "dob = ? " + "WHERE customerID = ?";

        try (Connection conn = new DBContext().getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, fullname);
            ps.setString(2, phone);
            ps.setString(3, gender);
            if (dob != null && !dob.trim().isEmpty()) {
                ps.setDate(4, java.sql.Date.valueOf(dob));
            } else {
                ps.setNull(4, java.sql.Types.DATE);
            }
            ps.setInt(5, id);
            int row = ps.executeUpdate();
            System.out.println("Updated rows = " + row);
            return row > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    // Update email sau khi đã xác thực OTP thành công
    public boolean updateEmail(int id, String newEmail) {
        // TODO: implement
        return false;
    }

    public Customer getCustomerById(int id) {
        // TODO: implement
        return null;
    }

    // Đồng nhất với AccountDAO.changePassword(): thực hiện trong một câu UPDATE
    // duy nhất kèm điều kiện password cũ, tránh phải SELECT rồi so sánh riêng.
    public boolean changePassword(
            int customerId,
            String currentPassword,
            String newPassword) {
        // TODO: implement
        return false;
    }

    public List<Customer> getAllCustomers() {
        // TODO: implement
        return new ArrayList<Customer>();
    }

    private static final java.util.Set<String> VALID_CUSTOMER_STATUSES
            = java.util.Set.of("active", "inactive");

    public boolean toggleCustomerStatus(int customerID, String status) {
        // TODO: implement
        return false;
    }

    public int countCustomers() {
        // TODO: implement
        return 0;
    }

    public List<Customer> getCustomersPaging(int offset, int pageSize) {
        // TODO: implement
        return new ArrayList<Customer>();
    }

    public boolean updateCustomerByAdmin(int id, String fullname, String phone, String status) {
        // TODO: implement
        return false;
    }

    public boolean resetPasswordByEmail(String email, String newPassword) {
        // TODO: implement
        return false;
    }

    public Account getAccountByEmail(String email) {
        // TODO: implement
        return null;
    }

    public List<Customer> searchCustomers(
            String keyword,
            String status,
            int offset,
            int pageSize) {
        // TODO: implement
        return new ArrayList<Customer>();
    }

    public int countCustomersFiltered(
            String keyword,
            String status) {
        // TODO: implement
        return 0;
    }

}
