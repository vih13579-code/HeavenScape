package controller;

import java.sql.Timestamp;

/**
 * Holds validated input for voucher create and update operations.
 */
final class VoucherInput {

    String code;
    double discount;
    Integer quantity;
    Timestamp startDate;
    Timestamp endDate;
    String status;
    Double minOrderValue;
    Double maxDiscountValue;
    String errorField;
    String errorMsg;
}
