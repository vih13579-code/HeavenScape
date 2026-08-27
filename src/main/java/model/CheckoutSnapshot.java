package model;

import java.io.Serializable;
import java.math.BigDecimal;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

/**
 * The checkout values that were last shown to the customer. These values are
 * only used for change detection; Order totals are always recalculated from DB.
 */
public class CheckoutSnapshot implements Serializable {

    private static final long serialVersionUID = 1L;

    private final List<Item> items;
    private final Integer voucherID;
    private final String voucherCode;
    private final BigDecimal voucherDiscountPercent;
    private final Integer voucherQuantity;
    private final Timestamp voucherStartDate;
    private final Timestamp voucherEndDate;
    private final BigDecimal voucherMinOrderValue;
    private final BigDecimal voucherMaxDiscountValue;
    private final BigDecimal subtotal;
    private final BigDecimal discount;
    private final BigDecimal total;

    public CheckoutSnapshot(List<Item> items, Integer voucherID, String voucherCode,
            BigDecimal voucherDiscountPercent, Integer voucherQuantity,
            Timestamp voucherStartDate, Timestamp voucherEndDate,
            BigDecimal voucherMinOrderValue, BigDecimal voucherMaxDiscountValue,
            BigDecimal subtotal, BigDecimal discount, BigDecimal total) {
        this.items = Collections.unmodifiableList(new ArrayList<>(items));
        this.voucherID = voucherID;
        this.voucherCode = voucherCode;
        this.voucherDiscountPercent = voucherDiscountPercent;
        this.voucherQuantity = voucherQuantity;
        this.voucherStartDate = voucherStartDate;
        this.voucherEndDate = voucherEndDate;
        this.voucherMinOrderValue = voucherMinOrderValue;
        this.voucherMaxDiscountValue = voucherMaxDiscountValue;
        this.subtotal = subtotal;
        this.discount = discount;
        this.total = total;
    }

    public List<Item> getItems() {
        return items;
    }

    public Integer getVoucherID() {
        return voucherID;
    }

    public String getVoucherCode() {
        return voucherCode;
    }

    public BigDecimal getVoucherDiscountPercent() {
        return voucherDiscountPercent;
    }

    public Integer getVoucherQuantity() {
        return voucherQuantity;
    }

    public Timestamp getVoucherStartDate() {
        return voucherStartDate;
    }

    public Timestamp getVoucherEndDate() {
        return voucherEndDate;
    }

    public BigDecimal getVoucherMinOrderValue() {
        return voucherMinOrderValue;
    }

    public BigDecimal getVoucherMaxDiscountValue() {
        return voucherMaxDiscountValue;
    }

    public BigDecimal getSubtotal() {
        return subtotal;
    }

    public BigDecimal getDiscount() {
        return discount;
    }

    public BigDecimal getTotal() {
        return total;
    }

    public static class Item implements Serializable {

        private static final long serialVersionUID = 1L;

        private final int bookID;
        private final String title;
        private final int quantity;
        private final BigDecimal unitPrice;

        public Item(int bookID, String title, int quantity, BigDecimal unitPrice) {
            this.bookID = bookID;
            this.title = title;
            this.quantity = quantity;
            this.unitPrice = unitPrice;
        }

        public int getBookID() {
            return bookID;
        }

        public String getTitle() {
            return title;
        }

        public int getQuantity() {
            return quantity;
        }

        public BigDecimal getUnitPrice() {
            return unitPrice;
        }
    }
}
