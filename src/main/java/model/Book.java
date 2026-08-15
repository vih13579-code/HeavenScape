/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

import java.math.BigDecimal;
import java.sql.Timestamp;
import java.util.List;

public class Book {

    private int bookID;
    private String title;
    private String description;
    private BigDecimal price;
    private int stockQuantity;
    private String thumbnail;
    private int totalPages;
    private String dimensions;
    private BigDecimal weight;
    private String status;

    // FK info
    private int genreID;
    private String genreName;
    private int contentID;
    private String contentName;
    private int seriesID;
    private String seriesName;
    private int originID;
    private String originName;


    private double avgRating;
    private int reviewCount;
    private boolean featured;

    private List<String> authors;

    private Timestamp createdAt;
    private Timestamp updatedAt;


    public int getBookID() {
        return bookID;
    }

    public void setBookID(int v) {
        this.bookID = v;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String v) {
        this.title = v;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String v) {
        this.description = v;
    }

    public BigDecimal getPrice() {
        return price;
    }

    public void setPrice(BigDecimal v) {
        this.price = v;
    }

    public int getStockQuantity() {
        return stockQuantity;
    }

    public void setStockQuantity(int v) {
        this.stockQuantity = v;
    }

    public String getThumbnail() {
        return thumbnail;
    }

    public void setThumbnail(String v) {
        this.thumbnail = v;
    }

    public int getTotalPages() {
        return totalPages;
    }

    public void setTotalPages(int v) {
        this.totalPages = v;
    }

    public String getDimensions() {
        return dimensions;
    }

    public void setDimensions(String v) {
        this.dimensions = v;
    }

    public BigDecimal getWeight() {
        return weight;
    }

    public void setWeight(BigDecimal v) {
        this.weight = v;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String v) {
        this.status = v;
    }

    public int getGenreID() {
        return genreID;
    }

    public void setGenreID(int v) {
        this.genreID = v;
    }

    public String getGenreName() {
        return genreName;
    }

    public void setGenreName(String v) {
        this.genreName = v;
    }

    public int getContentID() {
        return contentID;
    }

    public void setContentID(int v) {
        this.contentID = v;
    }

    public String getContentName() {
        return contentName;
    }

    public void setContentName(String v) {
        this.contentName = v;
    }

    public int getSeriesID() {
        return seriesID;
    }

    public void setSeriesID(int v) {
        this.seriesID = v;
    }

    public String getSeriesName() {
        return seriesName;
    }

    public void setSeriesName(String v) {
        this.seriesName = v;
    }

    public int getOriginID() {
        return originID;
    }

    public void setOriginID(int v) {
        this.originID = v;
    }

    public String getOriginName() {
        return originName;
    }

    public void setOriginName(String v) {
        this.originName = v;
    }

    public double getAvgRating() {
        return avgRating;
    }

    public void setAvgRating(double v) {
        this.avgRating = v;
    }

    public int getReviewCount() {
        return reviewCount;
    }

    public void setReviewCount(int v) {
        this.reviewCount = v;
    }

    public boolean isFeatured() {
        return featured;
    }

    public void setFeatured(boolean v) {
        this.featured = v;
    }

    public List<String> getAuthors() {
        return authors;
    }

    public void setAuthors(List<String> v) {
        this.authors = v;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp v) {
        this.createdAt = v;
    }

    public Timestamp getUpdatedAt() {
        return updatedAt;
    }

    public void setUpdatedAt(Timestamp v) {
        this.updatedAt = v;
    }

    public String getThumbnailFirst() {
        if (thumbnail == null || thumbnail.isEmpty()) {
            return "";
        }
        int idx = thumbnail.indexOf('|');
        return idx >= 0 ? thumbnail.substring(0, idx).trim() : thumbnail.trim();
    }


    public java.util.List<String> getAllImages() {
        java.util.List<String> list = new java.util.ArrayList<>();
        if (thumbnail == null || thumbnail.isEmpty()) {
            return list;
        }
        for (String s : thumbnail.split("\\|")) {
            String t = s.trim();
            if (!t.isEmpty()) {
                list.add(t);
            }
        }
        return list;
    }
}
