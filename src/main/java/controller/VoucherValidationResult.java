package controller;

import model.Voucher;

/**
 * Represents the outcome of validating a voucher for checkout.
 */
final class VoucherValidationResult {

    boolean success;
    String message;
    Voucher voucher;
    double discountAmount;
}
