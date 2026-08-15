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
        // TODO: implement
    }

    public List<CartItem> getCartItems(int customerID) {
        // TODO: implement
        return new ArrayList<CartItem>();
    }

    public int getOrCreateCart(int customerID) {
        // TODO: implement
        return 0;
    }

    public boolean addToCart(int customerID, int bookID, int quantity) {
        // TODO: implement
        return false;
    }

    public int countCartItems(int customerID) {
        // TODO: implement
        return 0;
    }

    public BigDecimal calcSubtotal(List<CartItem> items) {
        // TODO: implement
        return null;
    }

    public boolean updateQuantity(int cartItemID, int customerID, int newQty) {
        // TODO: implement
        return false;
    }

    public boolean removeItem(int cartItemID, int customerID) {
        // TODO: implement
        return false;
    }

    public int getStockByCartItemID(int cartItemID) {
        // TODO: implement
        return 0;
    }

    public int getStockByBookID(int bookID) {
        // TODO: implement
        return 0;
    }

    public int getCurrentCartQty(int customerID, int bookID) {
        // TODO: implement
        return 0;
    }
}
