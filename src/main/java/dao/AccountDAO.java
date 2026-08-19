package dao;

import utils.DBContext;
import utils.HashMD5;
import model.Account;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class AccountDAO {

    /**
     * Reloads the account represented by a session from its source table.
     * Customer IDs and staff/admin IDs can overlap, so the role is required to
     * select the correct table.
     */
    public Account getAccountById(int id, String role) {
        boolean customer = "customer".equalsIgnoreCase(role);
        String sql = customer
                ? "SELECT customerID AS id, fullname, email, phone, role, status FROM Customer WHERE customerID = ?"
                : "SELECT accountID AS id, fullname, email, phone, role, status FROM Account WHERE accountID = ?";

        try (Connection conn = new DBContext().getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return new Account(
                            rs.getInt("id"),
                            rs.getString("fullname"),
                            rs.getString("email"),
                            rs.getString("phone"),
                            customer ? "customer" : rs.getString("role"),
                            rs.getString("status")
                    );
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public Account checkLogin(String email, String password) {
        String hashedPassword = HashMD5.hash(password);
        DBContext db = new DBContext();

        // Kiểm tra bảng Customer
        String sqlCustomer = "SELECT customerID, fullname, email, phone, role, status "
                + "FROM Customer WHERE email = ? AND password = ?";
        try (Connection conn = db.getConnection(); PreparedStatement ps = conn.prepareStatement(sqlCustomer)) {
            ps.setString(1, email);
            ps.setString(2, hashedPassword);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return new Account(
                            rs.getInt("customerID"),
                            rs.getString("fullname"),
                            rs.getString("email"),
                            rs.getString("phone"),
                            "customer",
                            rs.getString("status")
                    );
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        // Kiểm tra bảng Account 
        String sqlAccount = "SELECT accountID, fullname, email, phone, role, status "
                + "FROM Account WHERE email = ? AND password = ?";
        try (Connection conn = db.getConnection(); PreparedStatement ps = conn.prepareStatement(sqlAccount)) {
            ps.setString(1, email);
            ps.setString(2, hashedPassword);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return new Account(
                            rs.getInt("accountID"),
                            rs.getString("fullname"),
                            rs.getString("email"),
                            rs.getString("phone"),
                            rs.getString("role"),
                            rs.getString("status")
                    );
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public List<Account> getAllStaffs() {
        List<Account> list = new ArrayList<>();
        String sql = "SELECT * FROM Account";
        try (Connection conn = new DBContext().getConnection(); PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(new Account(
                        rs.getInt("accountID"),
                        rs.getString("fullname"),
                        rs.getString("email"),
                        rs.getString("phone"),
                        rs.getString("role"),
                        rs.getString("status")
                ));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // Các giá trị status hợp lệ cho Account (staff/admin). Kiểm tra ở đây để
    // phòng trường hợp Controller gọi hàm này chưa validate (defense in depth).
    private static final java.util.Set<String> VALID_ACCOUNT_STATUSES
            = java.util.Set.of("active", "inactive");

    // cập nhật trạng thái của staff 
    public boolean toggleStaffStatus(int accountID, String status) {
        if (status == null || !VALID_ACCOUNT_STATUSES.contains(status.toLowerCase())) {
            System.out.println("toggleStaffStatus: invalid status = " + status);
            return false;
        }
        String sql = "UPDATE Account SET status = ? WHERE accountID = ?";
        try (Connection conn = new DBContext().getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setInt(2, accountID);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    // thêm phân trang
    public int countStaffs() {
        String sql = "SELECT COUNT(*) FROM Account";
        try (Connection conn = new DBContext().getConnection(); PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    public List<Account> getStaffsPaging(int offset, int pageSize) {
        List<Account> list = new ArrayList<>();
        String sql
                = "SELECT * FROM ("
                + " SELECT *, ROW_NUMBER() OVER(ORDER BY accountID DESC) AS rn "
                + " FROM Account "
                + ") t "
                + "WHERE rn > ? AND rn <= ?";

        try (Connection conn = new DBContext().getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, offset);
            ps.setInt(2, offset + pageSize);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(
                        new Account(
                                rs.getInt("accountID"),
                                rs.getString("fullname"),
                                rs.getString("email"),
                                rs.getString("phone"),
                                rs.getString("role"),
                                rs.getString("status")
                        )
                );
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public Account getStaffById(int id) {
        String sql = "SELECT * FROM Account WHERE accountID = ?";
        try (Connection conn = new DBContext().getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return new Account(
                        rs.getInt("accountID"),
                        rs.getString("fullname"),
                        rs.getString("email"),
                        rs.getString("phone"),
                        rs.getString("role"),
                        rs.getString("status")
                );
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return null;
    }

    // Update email sau khi đã xác thực OTP thành công (dùng cho cả staff và admin)
    public boolean updateEmail(int id, String newEmail) {
        String sql = "UPDATE Account SET email = ? WHERE accountID = ?";
        try (Connection conn = new DBContext().getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, newEmail);
            ps.setInt(2, id);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean isStaffEmailExists(String email) {
        String sql = "SELECT 1 FROM Account WHERE email = ?";
        try (Connection conn = new DBContext().getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, email);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean isEmailExists(String email) {
        String sql1 = "SELECT 1 FROM Account WHERE email = ?";
        try (Connection conn = new DBContext().getConnection(); PreparedStatement ps = conn.prepareStatement(sql1)) {
            ps.setString(1, email);
            if (ps.executeQuery().next()) {
                return true;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        String sql2 = "SELECT 1 FROM Customer WHERE email = ?";
        try (Connection conn = new DBContext().getConnection(); PreparedStatement ps = conn.prepareStatement(sql2)) {
            ps.setString(1, email);
            if (ps.executeQuery().next()) {
                return true;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }

    public boolean registerStaff(String fullname,
            String email,
            String phone,
            String password,
            String role,
            String status) {
        String sql = "INSERT INTO Account "
                + "(fullname, email, password, phone, role, status) "
                + "VALUES (?, ?, ?, ?, ?, ?)";
        try (Connection conn = new DBContext().getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, fullname);
            ps.setString(2, email);
            ps.setString(3, HashMD5.hash(password));
            ps.setString(4, phone);
            ps.setString(5, role);
            ps.setString(6, status);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean updateStaff(int id,
            String fullname,
            String email,
            String phone,
            String role) {
        String sql = "UPDATE Account "
                + "SET fullname = ?, "
                + "email = ?, "
                + "phone = ?, "
                + "role = ? "
                + "WHERE accountID = ?";
        try (Connection conn = new DBContext().getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, fullname);
            ps.setString(2, email);
            ps.setString(3, phone);
            ps.setString(4, role);
            ps.setInt(5, id);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean updateStaffByAdmin(int id, String fullname, String phone, String role, String status) {
        String sql = "UPDATE Account SET fullname=?, phone=?, role=?, status=? WHERE accountID=?";
        try (Connection conn = new DBContext().getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, fullname);
            ps.setString(2, phone);
            ps.setString(3, role);
            ps.setString(4, status);
            ps.setInt(5, id);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
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
        String sql = "UPDATE Account SET password = ? WHERE email = ?";
        try (Connection conn = new DBContext().getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, HashMD5.hash(newPassword));
            ps.setString(2, email);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean changePassword(
            int accountId,
            String currentPassword,
            String newPassword
    ) {
        String sql
                = "UPDATE Account "
                + "SET password = ? "
                + "WHERE accountID = ? "
                + "AND password = ?";

        try (
                Connection conn = new DBContext().getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, HashMD5.hash(newPassword));
            ps.setInt(2, accountId);
            ps.setString(3, HashMD5.hash(currentPassword));

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }

    public List<Account> searchStaffs(
            String keyword,
            String role,
            String status,
            int offset,
            int pageSize) {

        List<Account> list = new ArrayList<>();

        StringBuilder sql = new StringBuilder(
                "SELECT * FROM ("
                + " SELECT *, ROW_NUMBER() OVER(ORDER BY accountID DESC) rn "
                + " FROM Account "
                + " WHERE (fullname LIKE ? OR email LIKE ?) "
        );

        if (!role.isEmpty()) {
            sql.append(" AND role = ? ");
        }

        if (!status.isEmpty()) {
            sql.append(" AND status = ? ");
        }

        sql.append(") t WHERE rn > ? AND rn <= ?");

        try (Connection conn = new DBContext().getConnection(); PreparedStatement ps = conn.prepareStatement(sql.toString())) {

            int i = 1;

            ps.setString(i++, "%" + keyword + "%");
            ps.setString(i++, "%" + keyword + "%");

            if (!role.isEmpty()) {
                ps.setString(i++, role);
            }

            if (!status.isEmpty()) {
                ps.setString(i++, status);
            }

            ps.setInt(i++, offset);
            ps.setInt(i, offset + pageSize);

            ResultSet rs = ps.executeQuery();

            while (rs.next()) {

                list.add(
                        new Account(
                                rs.getInt("accountID"),
                                rs.getString("fullname"),
                                rs.getString("email"),
                                rs.getString("phone"),
                                rs.getString("role"),
                                rs.getString("status")
                        )
                );
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    public int countStaffsFiltered(
            String keyword,
            String role,
            String status) {

        StringBuilder sql = new StringBuilder(
                "SELECT COUNT(*) "
                + "FROM Account "
                + "WHERE (fullname LIKE ? OR email LIKE ?)"
        );

        if (!role.isEmpty()) {
            sql.append(" AND role = ?");
        }

        if (!status.isEmpty()) {
            sql.append(" AND status = ?");
        }

        try (Connection conn = new DBContext().getConnection(); PreparedStatement ps = conn.prepareStatement(sql.toString())) {

            int i = 1;

            ps.setString(i++, "%" + keyword + "%");
            ps.setString(i++, "%" + keyword + "%");

            if (!role.isEmpty()) {
                ps.setString(i++, role);
            }

            if (!status.isEmpty()) {
                ps.setString(i++, status);
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

    public Account getAccountByEmail(String email) {
        String sql = "SELECT accountID, fullname, email, phone, role, status "
                + "FROM Account WHERE email = ?";
        try (Connection conn = new DBContext().getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, email);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return new Account(
                            rs.getInt("accountID"),
                            rs.getString("fullname"),
                            rs.getString("email"),
                            rs.getString("phone") != null ? rs.getString("phone") : "",
                            rs.getString("role"),
                            rs.getString("status")
                    );
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }
}
