package model;

import java.sql.Timestamp;

public class Voucher {

    private int voucherID;
    private String code;
    private double discountPercent;
    private Integer quantity;
    private Timestamp startDate;
    private Timestamp endDate;
    private String status;
    private int usedCount;
    private boolean deleted;
    private Double minOrderValue;      // đơn hàng tối thiểu (null = không giới hạn)
    private Double maxDiscountValue;   // số tiền giảm tối đa (null = không giới hạn)

    public Voucher() {
    }

    public Voucher(int voucherID, String code, double discountPercent, Integer quantity,
            Timestamp startDate, Timestamp endDate, String status,
            int usedCount, boolean deleted,
            Double minOrderValue, Double maxDiscountValue) {
        this.voucherID = voucherID;
        this.code = code;
        this.discountPercent = discountPercent;
        this.quantity = quantity;
        this.startDate = startDate;
        this.endDate = endDate;
        this.status = status;
        this.usedCount = usedCount;
        this.deleted = deleted;
        this.minOrderValue = minOrderValue;
        this.maxDiscountValue = maxDiscountValue;
    }

    public int getVoucherID() {
        return voucherID;
    }

    public void setVoucherID(int voucherID) {
        this.voucherID = voucherID;
    }

    public String getCode() {
        return code;
    }

    public void setCode(String code) {
        this.code = code;
    }

    public double getDiscountPercent() {
        return discountPercent;
    }

    public void setDiscountPercent(double v) {
        this.discountPercent = v;
    }

    public Integer getQuantity() {
        return quantity;
    }

    public void setQuantity(Integer quantity) {
        this.quantity = quantity;
    }

    public Timestamp getStartDate() {
        return startDate;
    }

    public void setStartDate(Timestamp startDate) {
        this.startDate = startDate;
    }

    public Timestamp getEndDate() {
        return endDate;
    }

    public void setEndDate(Timestamp endDate) {
        this.endDate = endDate;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public int getUsedCount() {
        return usedCount;
    }

    public void setUsedCount(int usedCount) {
        this.usedCount = usedCount;
    }

    public boolean isDeleted() {
        return deleted;
    }

    public void setDeleted(boolean deleted) {
        this.deleted = deleted;
    }

    public Double getMinOrderValue() {
        return minOrderValue;
    }

    public void setMinOrderValue(Double minOrderValue) {
        this.minOrderValue = minOrderValue;
    }

    public Double getMaxDiscountValue() {
        return maxDiscountValue;
    }

    public void setMaxDiscountValue(Double maxDiscountValue) {
        this.maxDiscountValue = maxDiscountValue;
    }
}
