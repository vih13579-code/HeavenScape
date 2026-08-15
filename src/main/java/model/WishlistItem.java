package model;

import java.math.BigDecimal;
import java.sql.Timestamp;

public class WishlistItem {

    private int wishlistItemID;
    private int wishlistID;
    private int bookID;
    private Timestamp addedAt;

    // Denormalized book info
    private String title;
    private String thumbnail;
    private BigDecimal price;
    private String authorsDisplay;
    private int stockQuantity;
    private String status;
    private double avgRating;
    private int reviewCount;

    public WishlistItem() {}

    public int getWishlistItemID() { return wishlistItemID; }
    public void setWishlistItemID(int v) { this.wishlistItemID = v; }

    public int getWishlistID() { return wishlistID; }
    public void setWishlistID(int v) { this.wishlistID = v; }

    public int getBookID() { return bookID; }
    public void setBookID(int v) { this.bookID = v; }

    public Timestamp getAddedAt() { return addedAt; }
    public void setAddedAt(Timestamp v) { this.addedAt = v; }

    public String getTitle() { return title; }
    public void setTitle(String v) { this.title = v; }

    public String getThumbnail() { return thumbnail; }
    public void setThumbnail(String v) { this.thumbnail = v; }

    public BigDecimal getPrice() { return price; }
    public void setPrice(BigDecimal v) { this.price = v; }

    public String getAuthorsDisplay() { return authorsDisplay; }
    public void setAuthorsDisplay(String v) { this.authorsDisplay = v; }

    public int getStockQuantity() { return stockQuantity; }
    public void setStockQuantity(int v) { this.stockQuantity = v; }

    public String getStatus() { return status; }
    public void setStatus(String v) { this.status = v; }

    public double getAvgRating() { return avgRating; }
    public void setAvgRating(double v) { this.avgRating = v; }

    public int getReviewCount() { return reviewCount; }
    public void setReviewCount(int v) { this.reviewCount = v; }

    public String getThumbnailFirst() {
        if (thumbnail == null || thumbnail.isEmpty()) return "";
        int idx = thumbnail.indexOf('|');
        return idx >= 0 ? thumbnail.substring(0, idx).trim() : thumbnail.trim();
    }
}
