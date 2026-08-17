package dao;

import java.sql.*;
import java.util.*;
import model.Address;
import utils.DBContext;

/**
 * Tầng truy xuất dữ liệu bảng Address.
 * Controller không viết SQL trực tiếp; mọi CRUD địa chỉ đi qua class này.
 *
 * Soft-delete: nếu DELETE bị FK chặn (địa chỉ đã gắn Order),
 * cập nhật country = '__DELETED__' để ẩn khỏi list nhưng vẫn giữ bản ghi cho lịch sử đơn.
 */
public class AddressDAO {

    DBContext db = new DBContext();

    /** Lấy tất cả địa chỉ (ít dùng trên UI customer; chủ yếu tiện debug/admin). */
    public List<Address> getAllAddresses() {
        List<Address> list = new ArrayList<>();
        String sql = "SELECT addressID, customerID, street, district, city, country, is_default, recipient_name, recipient_phone FROM Address ORDER BY addressID DESC";

        try (Connection conn = db.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                list.add(mapAddress(rs));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    /**
     * View Address List theo 1 customer.
     * Lọc bỏ bản ghi soft-delete (country = '__DELETED__').
     * Sắp xếp: địa chỉ mặc định lên đầu, rồi ID mới hơn.
     */
    public List<Address> getAddressesByCustomerId(int customerID) {
        List<Address> list = new ArrayList<>();

        String sql = "SELECT addressID, customerID, street, district, city, country, is_default, recipient_name, recipient_phone "
                + "FROM Address "
                + "WHERE customerID = ? AND (country IS NULL OR country <> '__DELETED__') "
                + "ORDER BY is_default DESC, addressID DESC";

        try (Connection conn = db.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, customerID);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapAddress(rs));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    public Address getAddressById(int id) {
        String sql = "SELECT addressID, customerID, street, district, city, country, is_default, recipient_name, recipient_phone FROM Address WHERE addressID=?";

        try (Connection conn = db.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, id);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapAddress(rs);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return null;
    }

    /** Lấy 1 địa chỉ và kiểm tra luôn thuộc đúng customer + chưa bị xóa mềm. */
    public Address getAddressByIdAndCustomer(int addressID, int customerID) {
        String sql = "SELECT addressID, customerID, street, district, city, country, "
                + "is_default, recipient_name, recipient_phone "
                + "FROM Address WHERE addressID=? AND customerID=? "
                + "AND (country IS NULL OR country <> '__DELETED__')";

        try (Connection conn = db.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, addressID);
            ps.setInt(2, customerID);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapAddress(rs);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return null;
    }

    public void insertAddress(Address a) {
        insertAddressAndReturnId(a);
    }

    /**
     * Create Address.
     * Nếu đây là địa chỉ đầu tiên của user → tự set is_default = 1.
     * Trả về addressID mới (generated key); thất bại trả -1.
     */
    public int insertAddressAndReturnId(Address a) {
        String countSql = "SELECT COUNT(*) FROM Address WHERE customerID=? AND (country IS NULL OR country <> '__DELETED__')";
        String insertSql = "INSERT INTO Address(customerID, street, district, city, country, is_default, recipient_name, recipient_phone) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";

        try (Connection conn = db.getConnection()) {
            boolean isFirstAddress = false;

            try (PreparedStatement countPs = conn.prepareStatement(countSql)) {
                countPs.setInt(1, a.getCustomerID());
                try (ResultSet rs = countPs.executeQuery()) {
                    if (rs.next()) {
                        isFirstAddress = rs.getInt(1) == 0;
                    }
                }
            }

            boolean makeDefault = isFirstAddress || a.isDefault();

            if (makeDefault) {
                resetDefault(conn, a.getCustomerID()); // chỉ 1 địa chỉ default tại 1 thời điểm
            }

            try (PreparedStatement ps = conn.prepareStatement(insertSql, Statement.RETURN_GENERATED_KEYS)) {
                ps.setInt(1, a.getCustomerID());
                ps.setString(2, a.getStreet());
                ps.setString(3, a.getDistrict());
                ps.setString(4, a.getCity());
                ps.setString(5, a.getCountry());
                ps.setBoolean(6, makeDefault);
                ps.setString(7, emptyToNull(a.getRecipientName()));
                ps.setString(8, emptyToNull(a.getRecipientPhone()));
                ps.executeUpdate();

                try (ResultSet rs = ps.getGeneratedKeys()) {
                    if (rs.next()) {
                        return rs.getInt(1);
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return -1;
    }

    /**
     * Update Address: chỉ sửa street/district/city.
     * WHERE addressID + customerID để user không sửa địa chỉ của người khác.
     */
    public boolean updateAddressByCustomer(int addressID, int customerID, String street, String district, String city) {
        String sql = "UPDATE Address SET street=?, district=?, city=?, country=? WHERE addressID=? AND customerID=?";

        try (Connection conn = db.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, street);
            ps.setString(2, district);
            ps.setString(3, city);
            ps.setString(4, "Vietnam");
            ps.setInt(5, addressID);
            ps.setInt(6, customerID);

            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }

    /**
     * Delete Address.
     * 1) Kiểm tra địa chỉ tồn tại và thuộc customer.
     * 2) Thử DELETE thật.
     * 3) Nếu SQLException FK (đơn hàng đang trỏ addressID) → UPDATE country='__DELETED__'
     *    để ẩn khỏi profile/checkout nhưng Order detail vẫn JOIN được địa chỉ cũ.
     * 4) Nếu xóa địa chỉ default → gán default cho địa chỉ còn lại mới nhất.
     */
    public boolean deleteAddressByCustomer(int addressID, int customerID) {
        String checkSql = "SELECT is_default FROM Address WHERE addressID=? AND customerID=?";
        String deleteSql = "DELETE FROM Address WHERE addressID=? AND customerID=?";

        try (Connection conn = db.getConnection()) {
            boolean wasDefault;

            try (PreparedStatement check = conn.prepareStatement(checkSql)) {
                check.setInt(1, addressID);
                check.setInt(2, customerID);

                try (ResultSet rs = check.executeQuery()) {
                    if (!rs.next()) {
                        return false; // không tồn tại hoặc không thuộc user
                    }
                    wasDefault = rs.getBoolean("is_default");
                }
            }

            try (PreparedStatement ps = conn.prepareStatement(deleteSql)) {
                ps.setInt(1, addressID);
                ps.setInt(2, customerID);

                if (ps.executeUpdate() > 0) {
                    if (wasDefault) {
                        setNewestAddressDefault(conn, customerID);
                    }
                    return true;
                }
            } catch (SQLException fkError) {
                // Nếu địa chỉ đã từng gắn với đơn hàng, DB có thể chặn DELETE vì khóa ngoại.
                // Fallback: bỏ địa chỉ khỏi danh sách của user để checkout/profile không hiện nữa.
                String detachSql = "UPDATE Address SET is_default=0, country='__DELETED__' WHERE addressID=? AND customerID=?";
                try (PreparedStatement detach = conn.prepareStatement(detachSql)) {
                    detach.setInt(1, addressID);
                    detach.setInt(2, customerID);

                    if (detach.executeUpdate() > 0) {
                        if (wasDefault) {
                            setNewestAddressDefault(conn, customerID);
                        }
                        return true;
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }

    /**
     * Set default: tắt is_default tất cả địa chỉ của user, rồi bật địa chỉ được chọn.
     * Có check ownership trước khi update.
     */
    public void setDefaultAddress(int addressID, int customerID) {
        try (Connection conn = db.getConnection()) {
            try (PreparedStatement check = conn.prepareStatement(
                    "SELECT addressID FROM Address WHERE addressID=? AND customerID=?")) {
                check.setInt(1, addressID);
                check.setInt(2, customerID);

                try (ResultSet rs = check.executeQuery()) {
                    if (!rs.next()) {
                        return;
                    }
                }
            }

            resetDefault(conn, customerID);

            try (PreparedStatement ps = conn.prepareStatement(
                    "UPDATE Address SET is_default=1 WHERE addressID=? AND customerID=?")) {
                ps.setInt(1, addressID);
                ps.setInt(2, customerID);
                ps.executeUpdate();
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    /** Đặt is_default = 0 cho mọi địa chỉ của customer. */
    private void resetDefault(Connection conn, int customerID) throws SQLException {
        try (PreparedStatement ps = conn.prepareStatement(
                "UPDATE Address SET is_default=0 WHERE customerID=?")) {
            ps.setInt(1, customerID);
            ps.executeUpdate();
        }
    }

    /** Sau khi xóa default, chọn địa chỉ còn lại mới nhất làm default. */
    private void setNewestAddressDefault(Connection conn, int customerID) throws SQLException {
        String sql = "UPDATE Address SET is_default=1 "
                + "WHERE addressID = (SELECT TOP 1 addressID FROM Address WHERE customerID=? AND (country IS NULL OR country <> '__DELETED__') ORDER BY addressID DESC)";

        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, customerID);
            ps.executeUpdate();
        }
    }

    /** Map 1 dòng ResultSet → object Address. */
    private Address mapAddress(ResultSet rs) throws SQLException {
        return new Address(
                rs.getInt("addressID"),
                rs.getInt("customerID"),
                rs.getString("street"),
                rs.getString("district"),
                rs.getString("city"),
                rs.getString("country"),
                rs.getBoolean("is_default"),
                rs.getString("recipient_name"),
                rs.getString("recipient_phone")
        );
    }

    private String emptyToNull(String value) {
        if (value == null || value.trim().isEmpty()) {
            return null;
        }
        return value.trim();
    }
}
