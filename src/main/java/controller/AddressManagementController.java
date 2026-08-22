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

        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        Account account = getLoggedInCustomer(request, response);
        if (account == null) {
            return;
        }

        CustomerDAO customerDAO = new CustomerDAO();
        Customer customer = customerDAO.getCustomerById(account.getId());
        List<Address> addresses = addressDAO.getAddressesByCustomerId(account.getId());

        request.setAttribute("customer", customer);
        request.setAttribute("addresses", addresses);
        request.getRequestDispatcher("/views/address/list.jsp")
                .forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        Account account = getLoggedInCustomer(request, response);
        if (account == null) {
            return;
        }

        String action = safeTrim(request.getParameter("action"));

        switch (action) {
            case "addAddressAjax":
                addAddressAjax(request, response, account.getId());
                return;

            case "updateAddressAjax":
                updateAddressAjax(request, response, account.getId());
                return;

            case "deleteAddress":
                deleteAddress(request, response, account.getId());
                return;

            case "setDefaultAddress":
                setDefaultAddress(request, response, account.getId());
                return;

            default:
                response.sendRedirect(request.getContextPath() + "/profile/address");
        }
    }

    private void addAddressAjax(HttpServletRequest request,
            HttpServletResponse response,
            int customerID) throws IOException {

        String street = safeTrim(request.getParameter("street"));
        String district = safeTrim(request.getParameter("district"));
        String city = safeTrim(request.getParameter("city"));

        String addressError = validateAddress(street, district, city);
        if (addressError != null) {
            writeJson(response, false, addressError);
            return;
        }

        Customer customer = new CustomerDAO().getCustomerById(customerID);
        if (customer == null) {
            writeJson(response, false, "Customer information not found");
            return;
        }

        String recipientName = safeTrim(customer.getFullname());
        String recipientPhone = safeTrim(customer.getPhone());

        // Dùng cùng Business Rule với RegisterController để kiểm tra họ tên và SĐT.
        // Trường hợp đăng nhập Google chưa cập nhật đủ hồ sơ thì không cho lưu địa chỉ.
        if (!isValidFullName(recipientName)) {
            writeJson(response, false,
                    "Update your profile with a valid full name before adding an address");
            return;
        }

        if (!isValidPhone(recipientPhone)) {
            writeJson(response, false,
                    "Update your profile with a valid phone number before adding an address");
            return;
        }

        Address address = new Address();
        address.setCustomerID(customerID);
        address.setStreet(street);
        address.setDistrict(district);
        address.setCity(city);
        address.setCountry("Vietnam");
        address.setDefault(false);
        address.setRecipientName(recipientName);
        address.setRecipientPhone(recipientPhone);

        int newId = addressDAO.insertAddressAndReturnId(address);
        writeJson(response, newId > 0,
                newId > 0 ? "Address added successfully" : "Could not add the address");
    }

    private void updateAddressAjax(HttpServletRequest request,
            HttpServletResponse response,
            int customerID) throws IOException {

        Integer addressID = parsePositiveInt(request.getParameter("addressID"));
        String street = safeTrim(request.getParameter("street"));
        String district = safeTrim(request.getParameter("district"));
        String city = safeTrim(request.getParameter("city"));

        if (addressID == null) {
            writeJson(response, false, "Invalid address");
            return;
        }

        String addressError = validateAddress(street, district, city);
        if (addressError != null) {
            writeJson(response, false, addressError);
            return;
        }

        boolean success = addressDAO.updateAddressByCustomer(
                addressID,
                customerID,
                street,
                district,
                city
        );

        writeJson(response, success,
                success ? "Address updated successfully" : "Address not found");
    }

    private void deleteAddress(HttpServletRequest request,
            HttpServletResponse response,
            int customerID) throws IOException {

        Integer addressID = parsePositiveInt(request.getParameter("addressID"));
        HttpSession session = request.getSession();

        if (addressID == null) {
            session.setAttribute("error", "Invalid address!");
        } else if (addressDAO.deleteAddressByCustomer(addressID, customerID)) {
            session.setAttribute("message", "Address deleted successfully!");
        } else {
            session.setAttribute("error", "Could not delete the address!");
        }

        response.sendRedirect(request.getContextPath() + "/profile/address");
    }

    private void setDefaultAddress(HttpServletRequest request,
            HttpServletResponse response,
            int customerID) throws IOException {

        Integer addressID = parsePositiveInt(request.getParameter("addressID"));
        HttpSession session = request.getSession();

        if (addressID == null) {
            session.setAttribute("error", "Invalid address!");
        } else {
            addressDAO.setDefaultAddress(addressID, customerID);
            session.setAttribute("message", "Default address set!");
        }

        response.sendRedirect(request.getContextPath() + "/profile/address");
    }

    private Account getLoggedInCustomer(HttpServletRequest request,
            HttpServletResponse response) throws IOException {

        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("account") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return null;
        }

        Account account = (Account) session.getAttribute("account");

        if (!"customer".equalsIgnoreCase(account.getRole())) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN);
            return null;
        }

        return account;
    }

    private String validateAddress(String street, String district, String city) {
        if (city == null || city.trim().isEmpty()) {
            return "Please select a province or city.";
        }

        if (district == null || district.trim().isEmpty()) {
            return "Please select a ward or commune.";
        }

        if (street == null || street.trim().isEmpty()) {
            return "Please enter a street address.";
        }

        String trimmedStreet = street.trim();
        if (trimmedStreet.length() < 5
                || !trimmedStreet.matches(".*[a-zA-ZÀ-ỹ].*")) {
            return "The address is invalid. Please provide a clear house number and street name.";
        }

        return null;
    }

    private boolean isValidFullName(String fullname) {
        if (fullname == null || fullname.isEmpty()) {
            return false;
        }

        String[] nameParts = fullname.trim().split("\\s+");
        if (nameParts.length < 2) {
            return false;
        }

        if (!fullname.matches("^[\\p{L}\\s]+$")) {
            return false;
        }

        return fullname.length() >= 2 && fullname.length() <= 50;
    }

    private boolean isValidPhone(String phone) {
        return phone != null && phone.matches("^(0[35789])\\d{8}$");
    }

    private Integer parsePositiveInt(String value) {
        try {
            int number = Integer.parseInt(value);
            return number > 0 ? number : null;
        } catch (Exception e) {
            return null;
        }
    }

    private String safeTrim(String value) {
        return value == null ? "" : value.trim();
    }

    private void writeJson(HttpServletResponse response,
            boolean success,
            String message) throws IOException {

        response.setContentType("application/json;charset=UTF-8");

        try (PrintWriter out = response.getWriter()) {
            out.print("{\"success\":" + success
                    + ",\"message\":\"" + escapeJson(message) + "\"}");
        }
    }

    private String escapeJson(String value) {
        return value.replace("\\", "\\\\")
                .replace("\"", "\\\"")
                .replace("\r", "\\r")
                .replace("\n", "\\n");
    }
}