package dao;

import model.CartItem;
import utils.DBContext;

import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class CartDAO {

    public void deleteDiscontinuedCartItems(int customerID) {
        String sql = "DELETE CartItem FROM CartItem "
                + "JOIN Cart ON Cart.cartID = CartItem.cartID "
                + "JOIN Book ON Book.bookID = CartItem.bookID "
                + "WHERE Cart.customerID = ? AND Cart.status = 'active' AND Book.status = 'discontinued'";
        try (Connection conn = new DBContext().getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, customerID);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public List<CartItem> getCartItems(int customerID) {
        deleteDiscontinuedCartItems(customerID);
        List<CartItem> cartItemList = new ArrayList<>();

        String sql = "SELECT CartItem.cartItemID, CartItem.cartID, CartItem.bookID, CartItem.quantity, "
                + "Book.title, Book.thumbnail, Book.price, Book.stock_quantity, Book.status "
                + "FROM Cart "
                + "JOIN CartItem ON CartItem.cartID = Cart.cartID "
                + "JOIN Book ON Book.bookID = CartItem.bookID "
                + "WHERE Cart.customerID = ? AND Cart.status = 'active' "
                + "ORDER BY CartItem.added_at DESC";

        try (Connection conn = new DBContext().getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, customerID);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    CartItem item = new CartItem();
                    item.setCartItemID(rs.getInt("cartItemID"));
                    item.setCartID(rs.getInt("cartID"));
                    item.setBookID(rs.getInt("bookID"));
                    item.setQuantity(rs.getInt("quantity"));
                    item.setTitle(rs.getString("title"));
                    item.setThumbnail(rs.getString("thumbnail"));
                    item.setPrice(rs.getBigDecimal("price"));
                    item.setStockQuantity(rs.getInt("stock_quantity"));
                    item.setStatus(rs.getString("status"));
                    cartItemList.add(item);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        for (CartItem item : cartItemList) {
            String authorSql = "SELECT Author.fullname "
                    + "FROM BookAuthor"
                    + "JOIN Author ON Author.authorID = BookAuthor.authorID "
                    + "WHERE BookAuthor.bookID = ?";

            StringBuilder authorNames = new StringBuilder();

            try (Connection conn = new DBContext().getConnection(); PreparedStatement ps = conn.prepareStatement(authorSql)) {

                ps.setInt(1, item.getBookID());

                try (ResultSet rs = ps.executeQuery()) {
                    while (rs.next()) {
                        if (authorNames.length() > 0) {
                            authorNames.append(", ");
                        }
                        authorNames.append(rs.getString("fullname"));
                    }
                }
            } catch (Exception e) {
                e.printStackTrace();
            }

            if (authorNames.length() > 0) {
                item.setAuthorsDisplay(authorNames.toString());
            } else {
                item.setAuthorsDisplay("Updating");
            }
        }

        return cartItemList;
    }

    public int getOrCreateCart(int customerID) {
        String sqlFind = "SELECT cartID FROM Cart WHERE customerID = ? AND status = 'active'";
        try (Connection conn = new DBContext().getConnection(); PreparedStatement ps = conn.prepareStatement(sqlFind)) {
            ps.setInt(1, customerID);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt("cartID");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        String sqlReactivate
                = "UPDATE Cart "
                + "SET status = 'active' "
                + "OUTPUT INSERTED.cartID "
                + "WHERE cartID = ("
                + "  SELECT TOP 1 cartID FROM Cart "
                + "  WHERE customerID = ? AND status = 'checked_out' "
                + "  ORDER BY cartID DESC"
                + ")";
        try (Connection conn = new DBContext().getConnection(); PreparedStatement ps = conn.prepareStatement(sqlReactivate)) {
            ps.setInt(1, customerID);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt("cartID");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        String sqlInsert = "INSERT INTO Cart (customerID, status) VALUES (?, 'active')";
        try (Connection conn = new DBContext().getConnection(); PreparedStatement ps = conn.prepareStatement(sqlInsert,
                PreparedStatement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, customerID);
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

    public boolean addToCart(int customerID, int bookID, int quantity) {
        int cartID = getOrCreateCart(customerID);
        if (cartID == -1) {
            return false;
        }

        String sqlCheck = "SELECT CartItem.cartItemID, CartItem.quantity FROM CartItem WHERE CartItem.cartID = ? AND CartItem.bookID = ?";

        try (Connection conn = new DBContext().getConnection(); PreparedStatement ps = conn.prepareStatement(sqlCheck)) {

            ps.setInt(1, cartID);
            ps.setInt(2, bookID);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                int newQty = rs.getInt("quantity") + quantity;
                String sqlUpdate = "UPDATE CartItem SET CartItem.quantity = ? WHERE CartItem.cartItemID = ?";
                try (PreparedStatement ps2 = conn.prepareStatement(sqlUpdate)) {
                    ps2.setInt(1, newQty);
                    ps2.setInt(2, rs.getInt("cartItemID"));
                    return ps2.executeUpdate() > 0;
                }
            } else {
                String sqlInsert = "INSERT INTO CartItem (cartID, bookID, quantity) VALUES (?, ?, ?)";
                try (PreparedStatement ps2 = conn.prepareStatement(sqlInsert)) {
                    ps2.setInt(1, cartID);
                    ps2.setInt(2, bookID);
                    ps2.setInt(3, quantity);
                    return ps2.executeUpdate() > 0;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }

    public int countCartItems(int customerID) {
        String sql = "SELECT COALESCE(SUM(CartItem.quantity), 0) "
                + "FROM CartItem "
                + "JOIN Cart ON Cart.cartID = CartItem.cartID "
                + "WHERE Cart.customerID = ? AND Cart.status = 'active'";

        try (Connection conn = new DBContext().getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, customerID);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return 0;
    }

    public BigDecimal calcSubtotal(List<CartItem> items) {
        BigDecimal subtotal = BigDecimal.ZERO;
        for (CartItem item : items) {
            subtotal = subtotal.add(item.getSubtotal());
        }
        return subtotal;
    }

    public boolean updateQuantity(int cartItemID, int customerID, int newQty) {

        String sql = "UPDATE CartItem "
                + "SET CartItem.quantity = ? "
                + "FROM CartItem "
                + "JOIN Cart ON Cart.cartID = CartItem.cartID "
                + "WHERE CartItem.cartItemID = ? "
                + "AND Cart.customerID = ? "
                + "AND Cart.status = 'active'";

        try (Connection conn = new DBContext().getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, newQty);
            ps.setInt(2, cartItemID);
            ps.setInt(3, customerID);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }

    public boolean removeItem(int cartItemID, int customerID) {
        String sql = "DELETE CartItem FROM CartItem "
                + "JOIN Cart ON Cart.cartID = CartItem.cartID "
                + "WHERE CartItem.cartItemID = ? AND Cart.customerID = ? AND Cart.status = 'active'";

        try (Connection conn = new DBContext().getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, cartItemID);
            ps.setInt(2, customerID);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }

    public int getStockByCartItemID(int cartItemID) {
        String sql = "SELECT Book.stock_quantity FROM CartItem "
                + "JOIN Book ON Book.bookID = CartItem.bookID "
                + "WHERE CartItem.cartItemID = ?";

        try (Connection conn = new DBContext().getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, cartItemID);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt("stock_quantity");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return 0;
    }

    public int getStockByBookID(int bookID) {
        String sql = "SELECT stock_quantity FROM Book WHERE bookID = ?";

        try (Connection conn = new DBContext().getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, bookID);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt("stock_quantity");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return 0;
    }

    public int getCurrentCartQty(int customerID, int bookID) {
        String sql = "SELECT CartItem.quantity FROM CartItem "
                + "JOIN Cart ON Cart.cartID = CartItem.cartID "
                + "WHERE Cart.customerID = ? AND Cart.status = 'active' AND CartItem.bookID = ?";

        try (Connection conn = new DBContext().getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, customerID);
            ps.setInt(2, bookID);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt("quantity");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return 0;
    }
}
