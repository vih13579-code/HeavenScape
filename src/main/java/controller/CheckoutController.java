package controller;

import dao.CartDAO;
import dao.OrderDAO;
import dao.AddressDAO;
import dao.BookDAO;
import dao.VoucherDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Account;
import model.CartItem;
import model.Address;
import model.Voucher;

import java.io.IOException;
import java.math.BigDecimal;
import java.math.RoundingMode;
import java.sql.Timestamp;
import java.text.SimpleDateFormat;
import java.util.List;

public class CheckoutController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // TODO: implement
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // TODO: implement
    }

    private void deleteAddressAjax(HttpServletRequest request,
            HttpServletResponse response,
            Account account) throws IOException {
        // TODO: implement
    }

    private static final String SESSION_VOUCHER_ID = "appliedVoucherID";
    private static final String SESSION_VOUCHER_CODE = "appliedVoucherCode";
    private static final String SESSION_VOUCHER_DISCOUNT = "appliedVoucherDiscount";

    private VoucherValidationResult validateVoucher(String code, int customerID, BigDecimal orderTotal,
            VoucherDAO voucherDAO) {
        // TODO: implement
        return null;
    }

    private void handleApplyVoucher(HttpServletRequest request, HttpServletResponse response, Account account)
            throws IOException {
        // TODO: implement
    }

    private void handleRemoveVoucher(HttpServletRequest request, HttpServletResponse response) throws IOException {
        // TODO: implement
    }

    private void handleListVouchers(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        // TODO: implement
    }

    private String escapeJson(String s) {
        // TODO: implement
        return null;
    }

    private void saveAddressAjax(HttpServletRequest request, HttpServletResponse response, Account account)
            throws IOException {
        // TODO: implement
    }

    private boolean isCustomer(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        // TODO: implement
        return false;
    }

    private Account getAccount(HttpServletRequest request) {
        // TODO: implement
        return null;
    }

    private boolean isEmpty(String value) {
        // TODO: implement
        return false;
    }

    private boolean isValidAddressPart(String value) {
        // TODO: implement
        return false;
    }

    private boolean isValidRecipientName(String value) {
        // TODO: implement
        return false;
    }

    private boolean isValidPhone(String value) {
        // TODO: implement
        return false;
    }
}
