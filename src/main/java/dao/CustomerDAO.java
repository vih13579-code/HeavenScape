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
        String sql1 = "SELECT 1 FROM Customer WHERE email = ?";
        String sql2 = "SELECT 1 FROM Account WHERE email = ?";
        try (Connection conn = new DBContext().getConnection()) {
            try (PreparedStatement ps = conn.prepareStatement(sql1)) {
                ps.setString(1, email);
                if (ps.executeQuery().next()) {
                    return true;
                }
            }
            try (PreparedStatement ps = conn.prepareStatement(sql2)) {
                ps.setString(1, email);
                if (ps.executeQuery().next()) {
                    return true;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
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
        String sql = "INSERT INTO Customer (fullname, email, password, phone) VALUES (?, ?, ?, ?)";
        try (Connection conn = new DBContext().getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, fullname);
            ps.setString(2, email);
            ps.setString(3, HashMD5.hash(password));
            ps.setString(4, phone);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace(); // 
            System.out.println("REGISTER ERROR: " + e.getMessage()); // thêm dòng này
        }
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
        String sql = "UPDATE Customer SET email = ? WHERE customerID = ?";
        try (Connection conn = new DBContext().getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, newEmail);
            ps.setInt(2, id);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public Customer getCustomerById(int id) {
        String sql = "SELECT customerID, fullname, email, password, " + "phone, role, status, gender, dob " + "FROM Customer " + "WHERE customerID = ?";

        try (Connection conn = new DBContext().getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return new Customer(
                        rs.getInt("customerID"),
                        rs.getString("fullname"),
                        rs.getString("email"),
                        rs.getString("password"),
                        rs.getString("phone"),
                        rs.getString("role"),
                        rs.getString("status"),
                        null,
                        rs.getString("gender"),
                        rs.getDate("dob")
                );
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return null;
    }
public boolean checkCurrentPassword(
        int customerId,
        String currentPassword
) {
    String sql = "SELECT 1 FROM Customer "
            + "WHERE customerID = ? AND password = ?";

    try (Connection conn = new DBContext().getConnection();
         PreparedStatement ps = conn.prepareStatement(sql)) {

        ps.setInt(1, customerId);
        ps.setString(2, HashMD5.hash(currentPassword));

        try (ResultSet rs = ps.executeQuery()) {
            return rs.next();
        }

    } catch (Exception e) {
        e.printStackTrace();
    }

    return false;
}
    // Đồng nhất với AccountDAO.changePassword(): thực hiện trong một câu UPDATE
    // duy nhất kèm điều kiện password cũ, tránh phải SELECT rồi so sánh riêng.
    public boolean changePassword(
            int customerId,
            String currentPassword,
            String newPassword) {

        String sql = "UPDATE Customer "
                + "SET password = ? "
                + "WHERE customerID = ? "
                + "AND password = ?";

        try (Connection conn = new DBContext().getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, HashMD5.hash(newPassword));
            ps.setInt(2, customerId);
            ps.setString(3, HashMD5.hash(currentPassword));

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public List<Customer> getAllCustomers() {
        List<Customer> list = new ArrayList<>();
        String sql = "SELECT * FROM Customer";
        try (Connection conn = new DBContext().getConnection(); PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Customer c = new Customer();
                c.setCustomerID(rs.getInt("customerID"));
                c.setFullname(rs.getString("fullname"));
                c.setEmail(rs.getString("email"));
                c.setPhone(rs.getString("phone"));
                c.setRole(rs.getString("role"));
                c.setStatus(rs.getString("status"));
                list.add(c);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    private static final java.util.Set<String> VALID_CUSTOMER_STATUSES
            = java.util.Set.of("active", "inactive");

    public boolean toggleCustomerStatus(int customerID, String status) {

        if (status == null || !VALID_CUSTOMER_STATUSES.contains(status.toLowerCase())) {
            System.out.println("toggleCustomerStatus: invalid status = " + status);
            return false;
        }

        String sql = "UPDATE Customer SET status = ? WHERE customerID = ?";

        try (Connection conn = new DBContext().getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, status);
            ps.setInt(2, customerID);

            int rows = ps.executeUpdate();

            System.out.println("customerID = " + customerID);
            System.out.println("status = " + status);
            System.out.println("rows = " + rows);

            return rows > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public int countCustomers() {

        String sql = "SELECT COUNT(*) FROM Customer";
        try (Connection conn = new DBContext().getConnection(); PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    public List<Customer> getCustomersPaging(int offset, int pageSize) {
        List<Customer> list = new ArrayList<>();
        String sql = "SELECT * FROM (" + " SELECT *, ROW_NUMBER() OVER(ORDER BY customerID DESC) AS rn " + " FROM Customer " + ") t " + "WHERE rn > ? AND rn <= ?";

        try (Connection conn = new DBContext().getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, offset);
            ps.setInt(2, offset + pageSize);

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Customer c = new Customer();

                c.setCustomerID(rs.getInt("customerID"));
                c.setFullname(rs.getString("fullname"));
                c.setEmail(rs.getString("email"));
                c.setPhone(rs.getString("phone"));
                c.setRole(rs.getString("role"));
                c.setStatus(rs.getString("status"));
                list.add(c);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public boolean updateCustomerByAdmin(int id, String fullname, String phone, String status) {
        String sql = "UPDATE Customer SET fullname=?, phone=?, status=? WHERE customerID=?";
        try (Connection conn = new DBContext().getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, fullname);
            ps.setString(2, phone);
            ps.setString(3, status);
            ps.setInt(4, id);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean resetPasswordByEmail(String email, String newPassword) {
        String sql = "UPDATE Customer SET password = ? WHERE email = ?";
        try (Connection conn = new DBContext().getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, HashMD5.hash(newPassword));
            ps.setString(2, email);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public Account getAccountByEmail(String email) {
        String sql = "SELECT customerID, fullname, email, phone, role, status "
                + "FROM Customer WHERE email = ?";
        try (Connection conn = new DBContext().getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, email);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return new Account(
                        rs.getInt("customerID"),
                        rs.getString("fullname"),
                        rs.getString("email"),
                        rs.getString("phone") != null ? rs.getString("phone") : "",
                        "customer",
                        rs.getString("status")
                );
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public List<Customer> searchCustomers(
            String keyword,
            String status,
            int offset,
            int pageSize) {

        List<Customer> list = new ArrayList<>();

        String sql
                = "SELECT * FROM ("
                + " SELECT *, ROW_NUMBER() OVER(ORDER BY customerID DESC) rn "
                + " FROM Customer "
                + " WHERE fullname LIKE ? "
                + " OR email LIKE ? "
                + ") t "
                + " WHERE rn > ? AND rn <= ?";

        if (!status.isEmpty()) {
            sql
                    = "SELECT * FROM ("
                    + " SELECT *, ROW_NUMBER() OVER(ORDER BY customerID DESC) rn "
                    + " FROM Customer "
                    + " WHERE (fullname LIKE ? OR email LIKE ?) "
                    + " AND status = ? "
                    + ") t "
                    + " WHERE rn > ? AND rn <= ?";
        }

        try (Connection conn = new DBContext().getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, "%" + keyword + "%");
            ps.setString(2, "%" + keyword + "%");

            if (!status.isEmpty()) {
                ps.setString(3, status);
                ps.setInt(4, offset);
                ps.setInt(5, offset + pageSize);
            } else {
                ps.setInt(3, offset);
                ps.setInt(4, offset + pageSize);
            }

            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Customer c = new Customer();

                c.setCustomerID(rs.getInt("customerID"));
                c.setFullname(rs.getString("fullname"));
                c.setEmail(rs.getString("email"));
                c.setPhone(rs.getString("phone"));
                c.setRole(rs.getString("role"));
                c.setStatus(rs.getString("status"));

                list.add(c);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    public int countCustomersFiltered(
            String keyword,
            String status) {

        String sql
                = "SELECT COUNT(*) "
                + "FROM Customer "
                + "WHERE (fullname LIKE ? OR email LIKE ?)";

        if (!status.isEmpty()) {
            sql += " AND status = ?";
        }

        try (Connection conn = new DBContext().getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, "%" + keyword + "%");
            ps.setString(2, "%" + keyword + "%");

            if (!status.isEmpty()) {
                ps.setString(3, status);
            }

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                return rs.getInt(1);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return 0;
    }

}
