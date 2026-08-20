package model;

import java.io.Serializable;
import java.math.BigDecimal;

public class CartItem implements Serializable {

    private static final long serialVersionUID = 1L;

    private int cartItemID;
    private int cartID;
    private int bookID;
    private int quantity;
    private int stockQuantity;
    private String title;
    private String thumbnail;
    private BigDecimal price;
    private String authorsDisplay;
    private String status;

    public CartItem() {
    }

    public int getCartItemID() {
        return cartItemID;
    }

    public void setCartItemID(int cartItemID) {
        this.cartItemID = cartItemID;
    }

    public int getCartID() {
        return cartID;
    }

    public void setCartID(int cartID) {
        this.cartID = cartID;
    }

    public int getBookID() {
        return bookID;
    }

    public void setBookID(int bookID) {
        this.bookID = bookID;
    }

    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }

    public int getStockQuantity() {
        return stockQuantity;
    }

    public void setStockQuantity(int stockQuantity) {
        this.stockQuantity = stockQuantity;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getThumbnail() {
        return thumbnail;
    }

    public void setThumbnail(String thumbnail) {
        this.thumbnail = thumbnail;
    }

    public BigDecimal getPrice() {
        return price;
    }

    public void setPrice(BigDecimal price) {
        this.price = price;
    }

    public String getAuthorsDisplay() {
        return authorsDisplay;
    }

    public void setAuthorsDisplay(String authorsDisplay) {
        this.authorsDisplay = authorsDisplay;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public BigDecimal getSubtotal() {
        if (price == null) {
            return BigDecimal.ZERO;
        }
        return price.multiply(BigDecimal.valueOf(quantity));
    }

    public String getThumbnailFirst() {
        if (thumbnail == null || thumbnail.isEmpty()) {
            return "";
        }
        int idx = thumbnail.indexOf('|');
        if (idx >= 0) {
            return thumbnail.substring(0, idx).trim();
        } else {
            return thumbnail.trim();
        }
    }
}