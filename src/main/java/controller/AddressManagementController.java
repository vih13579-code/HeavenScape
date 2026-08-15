package controller;

import dao.AddressDAO;
import dao.CustomerDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;
import model.Account;
import model.Address;
import model.Customer;

public class AddressManagementController extends HttpServlet {

    private final AddressDAO addressDAO = new AddressDAO();

    @Override
    protected void doGet(HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {
        // TODO: implement
    }

    @Override
    protected void doPost(HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {
        // TODO: implement
    }

    private void addAddressAjax(HttpServletRequest request,
            HttpServletResponse response,
            int customerID) throws IOException {
        // TODO: implement
    }

    private void updateAddressAjax(HttpServletRequest request,
            HttpServletResponse response,
            int customerID) throws IOException {
        // TODO: implement
    }

    private void deleteAddress(HttpServletRequest request,
            HttpServletResponse response,
            int customerID) throws IOException {
        // TODO: implement
    }

    private void setDefaultAddress(HttpServletRequest request,
            HttpServletResponse response,
            int customerID) throws IOException {
        // TODO: implement
    }

    private Account getLoggedInCustomer(HttpServletRequest request,
            HttpServletResponse response) throws IOException {
        // TODO: implement
        return null;
    }

    private String validateAddress(String street, String district, String city) {
        // TODO: implement
        return null;
    }

    private boolean isValidFullName(String fullname) {
        // TODO: implement
        return false;
    }

    private boolean isValidPhone(String phone) {
        // TODO: implement
        return false;
    }

    private Integer parsePositiveInt(String value) {
        // TODO: implement
        return null;
    }

    private String safeTrim(String value) {
        // TODO: implement
        return null;
    }

    private void writeJson(HttpServletResponse response,
            boolean success,
            String message) throws IOException {
        // TODO: implement
    }

    private String escapeJson(String value) {
        // TODO: implement
        return null;
    }
}