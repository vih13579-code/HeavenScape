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

    // Phần này tương ứng với backlog: "Address Management"
    // - Create Address
    // - View Address List
    // - Update Address
    // - Delete Address
    // - Set Default Address
    private final AddressDAO addressDAO = new AddressDAO();

    @Override
    protected void doGet(HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {
        // GET: hiển thị danh sách địa chỉ của khách hàng đang đăng nhập.
        // Giao diện sẽ lấy dữ liệu từ request attribute và render ra /views/address/list.jsp.

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
                // Tạo địa chỉ mới cho khách hàng.
                addAddressAjax(request, response, account.getId());
                return;

            case "updateAddressAjax":
                // Cập nhật địa chỉ đã có.
                updateAddressAjax(request, response, account.getId());
                return;

            case "deleteAddress":
                // Xóa địa chỉ, sau đó redirect lại trang quản lý địa chỉ.
                deleteAddress(request, response, account.getId());
                return;

            case "setDefaultAddress":
                // Đặt địa chỉ mặc định; logic ở DAO đảm bảo chỉ có 1 địa chỉ default cho customer.
                setDefaultAddress(request, response, account.getId());
                return;

            default:
                response.sendRedirect(request.getContextPath() + "/profile/address");
        }
    }

    private void addAddressAjax(HttpServletRequest request,
            HttpServletResponse response,
            int customerID) throws IOException {

        // Bước 1: đọc dữ liệu địa chỉ từ form AJAX.
        String street = safeTrim(request.getParameter("street"));
        String district = safeTrim(request.getParameter("district"));
        String city = safeTrim(request.getParameter("city"));

        // Bước 2: validate cơ bản dữ liệu đầu vào.
        // Nếu thiếu thành phần thì trả về JSON lỗi để frontend hiện thông báo.

        String addressError = validateAddress(street, district, city);
        if (addressError != null) {
            writeJson(response, false, addressError);
            return;
        }

        // Bước 3: lấy thông tin user để dùng làm tên người nhận và số điện thoại.
        // Điều này tránh khách hàng tạo địa chỉ thiếu thông tin nhận hàng.
        Customer customer = new CustomerDAO().getCustomerById(customerID);
        if (customer == null) {
            writeJson(response, false, "Customer information not found");
            return;
        }

        String recipientName = safeTrim(customer.getFullname());
        String recipientPhone = safeTrim(customer.getPhone());

        // Bước 4: kiểm tra business rule.
        // Nếu hồ sơ khách hàng chưa có họ tên hoặc số điện thoại hợp lệ thì không cho thêm địa chỉ.
        // Đây là logic bảo đảm địa chỉ nhận hàng luôn đầy đủ và đúng chuẩn.
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

        // Bước 5: tạo đối tượng Address và lưu xuống database.
        Address address = new Address();
        address.setCustomerID(customerID);
        address.setStreet(street);
        address.setDistrict(district);
        address.setCity(city);
        address.setCountry("Vietnam");
        address.setDefault(false);
        address.setRecipientName(recipientName);
        address.setRecipientPhone(recipientPhone);

        // DAO trả về id mới nếu lưu thành công, dùng để frontend biết thêm thành công/thất bại.
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

        // Logic đặt địa chỉ mặc định: chỉ cho phép một địa chỉ default cho mỗi customer.
        // DAO sẽ reset hết default cũ rồi bật default mới.
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
        // Kiểm tra dữ liệu địa chỉ trước khi lưu.
        // Mục tiêu: tránh lưu thông tin rỗng hoặc không hợp lệ trên giao diện và database.
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