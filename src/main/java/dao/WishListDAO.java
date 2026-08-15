package dao;

import model.WishlistItem;
import utils.DBContext;

import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class WishListDAO {


    public int getOrCreateWishlist(int customerID) {
        // TODO: implement
        return 0;
    }


    public List<WishlistItem> getWishlistItems(int customerID) {
        // TODO: implement
        return new ArrayList<WishlistItem>();
    }


    public boolean isInWishlist(int customerID, int bookID) {
        // TODO: implement
        return false;
    }


    public boolean addToWishlist(int customerID, int bookID) {
        // TODO: implement
        return false;
    }

    
    public boolean removeFromWishlist(int customerID, int bookID) {
        // TODO: implement
        return false;
    }


    public int countWishlistItems(int customerID) {
        // TODO: implement
        return 0;
    }


    public boolean moveToCart(int customerID, int bookID) {
        // TODO: implement
        return false;
    }

    public boolean moveToCart(int customerID, int bookID, int quantity) {
        // TODO: implement
        return false;
    }
}
