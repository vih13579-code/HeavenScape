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

/**
 * Address Management (SWP391 – Iteration 1)
 *
 * Servlet xử lý CRUD địa chỉ giao hàng của CUSTOMER.
 * URL mapping: /profile/address (xem web.xml)
 *
 * GET  → View Address List: lấy danh sách địa chỉ theo customer đang đăng nhập, forward sang list.jsp
 * POST → theo param "action":
 *   - addAddressAjax     : Create Address (trả JSON, không reload trang)
 *   - updateAddressAjax  : Update Address (trả JSON)
 *   - deleteAddress      : Delete Address (redirect + flash message)
 *   - setDefaultAddress  : đặt địa chỉ mặc định (redirect)
 *
 * Luồng: Browser → Controller (validate + phân quyền) → AddressDAO (SQL) → SQL Server
 */
public class AddressManagementController extends HttpServlet {

    // DAO dùng chung cho mọi request của servlet này
    private final AddressDAO addressDAO = new AddressDAO();

    /**
     * View Address List.
     * 1. Kiểm tra đã login và role = customer.
     * 2. Lấy hồ sơ Customer (để biết tên/SĐT khi tạo địa chỉ).
     * 3. Lấy list Address theo customerID (bỏ địa chỉ soft-delete).
     * 4. Đẩy data vào request rồi forward JSP.
     */
    @Override
    protected void doGet(HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        Account account = getLoggedInCustomer(request, response);
        if (account == null) {
            return; // đã redirect login hoặc trả 403
        }

        CustomerDAO customerDAO = new CustomerDAO();
        Customer customer = customerDAO.getCustomerById(account.getId());
        List<Address> addresses = addressDAO.getAddressesByCustomerId(account.getId());

        request.setAttribute("customer", customer);
        request.setAttribute("addresses", addresses);
        request.getRequestDispatcher("/views/address/list.jsp")
                .forward(request, response);
    }

    /**
     * Nhận form/AJAX từ list.jsp.
     * Đọc "action" rồi gọi đúng hàm nghiệp vụ.
     */
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
                // action lạ → quay lại danh sách, tránh crash
                response.sendRedirect(request.getContextPath() + "/profile/address");
        }
    }

    /**
     * Create Address (AJAX).
     * Nhận street, district (phường/xã), city (tỉnh/thành) từ modal.
     * Tên người nhận + SĐT lấy từ Customer profile (không nhập trên form địa chỉ).
     * Validate xong thì INSERT, trả JSON {success, message} cho JS xử lý toast.
     */
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
        address.setDefault(false); // địa chỉ đầu tiên sẽ được DAO tự set default
        address.setRecipientName(recipientName);
        address.setRecipientPhone(recipientPhone);

        int newId = addressDAO.insertAddressAndReturnId(address);
        writeJson(response, newId > 0,
                newId > 0 ? "Address added successfully" : "Could not add the address");
    }

    /**
     * Update Address (AJAX).
     * Chỉ cho sửa street/district/city của địa chỉ thuộc ĐÚNG customer đang login
     * (DAO có điều kiện WHERE customerID = ? để chống sửa địa chỉ người khác).
     */
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

    /**
     * Delete Address.
     * Form POST thường (không AJAX): xong thì redirect về list + set session message.
     * DAO sẽ hard-delete; nếu bị khóa ngoại (địa chỉ đã dùng trong Order) thì soft-delete.
     */
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

    /**
     * Đặt 1 địa chỉ thành mặc định (dùng lúc checkout ưu tiên chọn sẵn).
     * DAO sẽ tắt default các địa chỉ khác rồi bật địa chỉ này.
     */
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

    /**
     * Bảo vệ endpoint: chưa login → /login; không phải customer → 403 Forbidden.
     * Trả về Account nếu hợp lệ, null nếu đã ghi response.
     */
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

    /**
     * Validate địa chỉ phía server (không tin hoàn toàn JS trên trình duyệt).
     * city, district bắt buộc chọn; street tối thiểu 5 ký tự và phải có chữ cái.
     */
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

        return null; // hợp lệ
    }

    /**
     * Họ tên: ít nhất 2 từ, chỉ chữ + khoảng trắng, độ dài 2–50.
     */
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

    /**
     * SĐT VN: 10 số, đầu 03/05/07/08/09.
     */
    private boolean isValidPhone(String phone) {
        return phone != null && phone.matches("^(0[35789])\\d{8}$");
    }

    /** Parse số nguyên dương; sai format hoặc ≤0 thì null. */
    private Integer parsePositiveInt(String value) {
        try {
            int number = Integer.parseInt(value);
            return number > 0 ? number : null;
        } catch (Exception e) {
            return null;
        }
    }

    /** Trim an toàn khi param null. */
    private String safeTrim(String value) {
        return value == null ? "" : value.trim();
    }

    /** Ghi JSON thủ công (project không dùng Jackson). Escape ký tự đặc biệt để JSON không vỡ. */
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
