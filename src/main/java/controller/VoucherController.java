package controller;

import dao.VoucherDAO;
import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.sql.Timestamp;
import java.text.SimpleDateFormat;
import java.time.LocalDate;
import model.Account;

public class VoucherController extends HttpServlet {

    private final VoucherDAO voucherDAO = new VoucherDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if (!hasAccess(request, response)) return;
        voucherDAO.autoExpireVouchers();

        String keyword = trimOrNull(request.getParameter("keyword"));
        String status  = trimOrNull(request.getParameter("status"));

        int pageSize    = 10;
        int currentPage = parseIntSafe(request.getParameter("page"), 1);
        if (currentPage < 1) currentPage = 1;

        int totalRecords = voucherDAO.countFiltered(keyword, status);
        int totalPages   = Math.max(1, (int) Math.ceil((double) totalRecords / pageSize));
        if (currentPage > totalPages) currentPage = totalPages;

        int offset = (currentPage - 1) * pageSize;

        request.setAttribute("voucherList",    voucherDAO.getAllVouchers(keyword, status, offset, pageSize));
        request.setAttribute("currentPage",    currentPage);
        request.setAttribute("totalPages",     totalPages);

        String encodedKeyword = keyword != null
                ? URLEncoder.encode(keyword, StandardCharsets.UTF_8.name()) : "";
        String encodedStatus  = status  != null
                ? URLEncoder.encode(status,  StandardCharsets.UTF_8.name()) : "";

        String baseUrl = request.getContextPath()
                + "/dashboard/voucher-management?keyword=" + encodedKeyword
                + "&status=" + encodedStatus;
        request.setAttribute("baseUrl", baseUrl);

        request.setAttribute("totalVouchers",   voucherDAO.countTotal());
        request.setAttribute("activeVouchers",  voucherDAO.countActive());
        request.setAttribute("expiredVouchers", voucherDAO.countExpired());
        request.setAttribute("totalUsed",       voucherDAO.countTotalUsed());

        request.getRequestDispatcher("/views/admin/voucher/voucher-management.jsp")
               .forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if (!hasAccess(request, response)) return;
        request.setCharacterEncoding("UTF-8");

        String action = request.getParameter("action");
        try {
            switch (action == null ? "" : action) {
                case "add":    handleAdd(request, response);    break;
                case "edit":   handleEdit(request, response);   break;
                case "delete": handleDelete(request, response); break;
                case "toggle": handleToggle(request, response); break;
                default:
                    response.sendRedirect(request.getContextPath() + "/dashboard/voucher-management");
            }
        } catch (Exception e) {
            e.printStackTrace();
            setFlash(request, false, null, "An error occurred. Please try again.");
            response.sendRedirect(request.getContextPath() + "/dashboard/voucher-management");
        }
    }

    private void handleAdd(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        VoucherInput input = validateVoucherInput(request, true);
        if (input.errorMsg != null) {
            setFlash(request, false, null, input.errorMsg);
            response.sendRedirect(request.getContextPath() + "/dashboard/voucher-management");
            return;
        }

        boolean ok = voucherDAO.addVoucher(
                input.code, input.discount, input.quantity,
                input.startDate, input.endDate,
                "active",                          // luôn active khi tạo mới
                input.minOrderValue, input.maxDiscountValue);

        setFlash(request, ok,
                "Voucher " + input.code.toUpperCase() + " added successfully!",
                "Could not add the voucher. The code may already exist.");
        response.sendRedirect(request.getContextPath() + "/dashboard/voucher-management");
    }

    private void handleEdit(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        int voucherID = parseIntSafe(request.getParameter("voucherID"), 0);
        if (voucherID <= 0) {
            setFlash(request, false, null, "Invalid voucher.");
            response.sendRedirect(request.getContextPath() + "/dashboard/voucher-management");
            return;
        }

        VoucherInput input = validateVoucherInput(request, false);
        if (input.errorMsg != null) {
            setFlash(request, false, null, input.errorMsg);
            response.sendRedirect(request.getContextPath() + "/dashboard/voucher-management");
            return;
        }

        boolean ok = voucherDAO.updateVoucher(
                voucherID, input.code, input.discount, input.quantity,
                input.startDate, input.endDate, input.status,
                input.minOrderValue, input.maxDiscountValue);

        setFlash(request, ok,
                "Voucher updated successfully!",
                "Update failed. The code may already exist or the voucher may no longer exist.");
        response.sendRedirect(request.getContextPath() + "/dashboard/voucher-management");
    }

    private void handleDelete(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        int voucherID = parseIntSafe(request.getParameter("voucherID"), 0);
        if (voucherID <= 0) {
            setFlash(request, false, null, "Invalid voucher.");
            response.sendRedirect(request.getContextPath() + "/dashboard/voucher-management");
            return;
        }

        int result = voucherDAO.deleteVoucher(voucherID);
        switch (result) {
            case  1: setFlash(request, true,  "Voucher deleted successfully!", null); break;
            case -1: setFlash(request, false, null, "A voucher that has already been used cannot be deleted."); break;
            default: setFlash(request, false, null, "Could not delete the voucher."); break;
        }
        response.sendRedirect(request.getContextPath() + "/dashboard/voucher-management");
    }

    private void handleToggle(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        int    voucherID = parseIntSafe(request.getParameter("voucherID"), 0);
        String newStatus = request.getParameter("newStatus");

        if (voucherID <= 0 || newStatus == null
                || (!newStatus.equals("active") && !newStatus.equals("inactive"))) {
            setFlash(request, false, null, "Invalid request.");
            response.sendRedirect(request.getContextPath() + "/dashboard/voucher-management");
            return;
        }

        boolean ok  = voucherDAO.toggleStatus(voucherID, newStatus);
        String  msg = "active".equals(newStatus) ? "Voucher activated." : "Voucher disabled.";
        setFlash(request, ok, msg, "Action failed. The voucher may have expired.");
        response.sendRedirect(request.getContextPath() + "/dashboard/voucher-management");
    }

    private static class VoucherInput {
        String    code;
        double    discount;
        Integer   quantity;
        Timestamp startDate;
        Timestamp endDate;
        String    status;
        Double    minOrderValue;
        Double    maxDiscountValue;
        String    errorMsg;
    }

    private VoucherInput validateVoucherInput(HttpServletRequest request, boolean isCreate) {
        VoucherInput v = new VoucherInput();

        String code = request.getParameter("code");
        if (code == null || code.trim().isEmpty()) {
            v.errorMsg = "Voucher code is required.";
            return v;
        }
        v.code = code.trim().toUpperCase();

        try {
            v.discount = Double.parseDouble(request.getParameter("discountPercent"));
        } catch (NumberFormatException e) {
            v.errorMsg = "Invalid discount value.";
            return v;
        }
        if (v.discount <= 0 || v.discount > 100) {
            v.errorMsg = "Discount must be greater than 0 and no more than 100%.";
            return v;
        }

        String quantityStr = request.getParameter("quantity");
        if (quantityStr != null && !quantityStr.trim().isEmpty()) {
            try {
                int q = Integer.parseInt(quantityStr.trim());
                if (q <= 0) {
                    v.errorMsg = "Quantity must be greater than 0. Leave it blank for no limit.";
                    return v;
                }
                v.quantity = q;
            } catch (NumberFormatException e) {
                v.errorMsg = "Invalid quantity.";
                return v;
            }
        }

        String minOrderStr = request.getParameter("minOrderValue");
        if (minOrderStr != null && !minOrderStr.trim().isEmpty()) {
            try {
                double minVal = Double.parseDouble(minOrderStr.trim());
                if (minVal < 0) {
                    v.errorMsg = "Minimum order value cannot be negative.";
                    return v;
                }
                v.minOrderValue = minVal;
            } catch (NumberFormatException e) {
                v.errorMsg = "Invalid minimum order value.";
                return v;
            }
        }

        String maxDiscStr = request.getParameter("maxDiscountValue");
        if (maxDiscStr != null && !maxDiscStr.trim().isEmpty()) {
            try {
                double maxVal = Double.parseDouble(maxDiscStr.trim());
                if (maxVal <= 0) {
                    v.errorMsg = "Maximum discount must be greater than 0. Leave it blank for no limit.";
                    return v;
                }
                v.maxDiscountValue = maxVal;
            } catch (NumberFormatException e) {
                v.errorMsg = "Invalid maximum discount value.";
                return v;
            }
        }

        v.startDate = parseDate(request.getParameter("startDate"));
        v.endDate   = parseDate(request.getParameter("endDate"));

        if (isCreate && v.startDate != null) {
            Timestamp today = Timestamp.valueOf(LocalDate.now().atStartOfDay());
            if (v.startDate.before(today)) {
                v.errorMsg = "Start date cannot be in the past.";
                return v;
            }
        }

        if (v.startDate != null && v.endDate != null && !v.startDate.before(v.endDate)) {
            v.errorMsg = "Start date must be before the end date.";
            return v;
        }

        if (!isCreate) {
            String statusParam = request.getParameter("status");
            if ("active".equals(statusParam) || "inactive".equals(statusParam)) {
                v.status = statusParam;
            } else {
                v.status = "on".equals(request.getParameter("statusToggle")) ? "active" : "inactive";
            }
        }

        return v;
    }

    private boolean hasAccess(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        HttpSession session = request.getSession(false);
        Account user = session != null ? (Account) session.getAttribute("account") : null;
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return false;
        }
        return true;
    }

    private Timestamp parseDate(String dateStr) {
        if (dateStr == null || dateStr.trim().isEmpty()) return null;
        try {
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
            sdf.setLenient(false);
            return new Timestamp(sdf.parse(dateStr.trim()).getTime());
        } catch (Exception e) {
            return null;
        }
    }

    private int parseIntSafe(String s, int defaultVal) {
        try { return Integer.parseInt(s); } catch (Exception e) { return defaultVal; }
    }

    private String trimOrNull(String s) {
        if (s == null || s.trim().isEmpty()) return null;
        return s.trim();
    }

    private void setFlash(HttpServletRequest request, boolean ok,
                          String successMsg, String errorMsg) {
        HttpSession session = request.getSession();
        if (ok) {
            if (successMsg != null) session.setAttribute("successMessage", successMsg);
        } else {
            if (errorMsg   != null) session.setAttribute("errorMessage",   errorMsg);
        }
    }
}