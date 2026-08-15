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

    public Account checkLogin(String email, String password) {
        // TODO: implement
        return null;
    }

    public List<Account> getAllStaffs() {
        // TODO: implement
        return new ArrayList<Account>();
    }

    // Các giá trị status hợp lệ cho Account (staff/admin). Kiểm tra ở đây để
    // phòng trường hợp Controller gọi hàm này chưa validate (defense in depth).
    private static final java.util.Set<String> VALID_ACCOUNT_STATUSES
            = java.util.Set.of("active", "inactive");

    // cập nhật trạng thái của staff 
    public boolean toggleStaffStatus(int accountID, String status) {
        // TODO: implement
        return false;
    }

    // thêm phân trang
    public int countStaffs() {
        // TODO: implement
        return 0;
    }

    public List<Account> getStaffsPaging(int offset, int pageSize) {
        // TODO: implement
        return new ArrayList<Account>();
    }

    public Account getStaffById(int id) {
        // TODO: implement
        return null;
    }

    // Update email sau khi đã xác thực OTP thành công (dùng cho cả staff và admin)
    public boolean updateEmail(int id, String newEmail) {
        // TODO: implement
        return false;
    }

    public boolean isStaffEmailExists(String email) {
        // TODO: implement
        return false;
    }

    public boolean isEmailExists(String email) {
        // TODO: implement
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
        // TODO: implement
        return false;
    }

    public boolean updateStaffByAdmin(int id, String fullname, String phone, String role, String status) {
        // TODO: implement
        return false;
    }

    public boolean updateCustomerByAdmin(int id, String fullname, String phone, String status) {
        // TODO: implement
        return false;
    }

    public boolean resetPasswordByEmail(String email, String newPassword) {
        // TODO: implement
        return false;
    }

    public boolean changePassword(
            int accountId,
            String currentPassword,
            String newPassword
    ) {
        // TODO: implement
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
        // TODO: implement
        return 0;
    }

    public Account getAccountByEmail(String email) {
        // TODO: implement
        return null;
    }
}
