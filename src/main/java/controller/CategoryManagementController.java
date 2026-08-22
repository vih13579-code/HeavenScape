package controller;

import dao.CategoryDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;
import model.Account;
import model.Category;

public class CategoryManagementController extends HttpServlet {

    private final CategoryDAO categoryDAO = new CategoryDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        String action = request.getParameter("action");
        boolean canManageCategory = canManageCategory(request);
        request.setAttribute("canManageCategory", canManageCategory);

        if ("create".equals(action)) {
            if (!canManageCategory) {
                setFlash(request, "error", "You do not have permission to add categories.");
                response.sendRedirect(request.getContextPath()
                        + "/dashboard/category-management");
                return;
            }

            request.setAttribute("pageTitle", "Add Category");
            request.setAttribute("formAction", "create");
            request.getRequestDispatcher("/views/category/form.jsp")
                    .forward(request, response);
            return;
        }

        if ("edit".equals(action)) {
            if (!canManageCategory) {
                setFlash(request, "error", "You do not have permission to update categories.");
                response.sendRedirect(request.getContextPath()
                        + "/dashboard/category-management");
                return;
            }

            int id = parseInt(request.getParameter("id"));
            Category category = categoryDAO.getCategoryById(id);

            if (category == null) {
                setFlash(request, "error", "Category not found.");
                response.sendRedirect(request.getContextPath()
                        + "/dashboard/category-management");
                return;
            }

            request.setAttribute("category", category);
            request.setAttribute("pageTitle", "Update Category");
            request.setAttribute("formAction", "update");
            request.getRequestDispatcher("/views/category/form.jsp")
                    .forward(request, response);
            return;
        }

        if ("detail".equals(action)) {
            int id = parseInt(request.getParameter("id"));
            Category category = categoryDAO.getCategoryById(id);

            if (category == null) {
                setFlash(request, "error", "Category not found.");
                response.sendRedirect(request.getContextPath()
                        + "/dashboard/category-management");
                return;
            }

            request.setAttribute("category", category);
            request.getRequestDispatcher("/views/category/detail.jsp")
                    .forward(request, response);
            return;
        }

        String keyword = clean(request.getParameter("keyword"));
        List<Category> categories = keyword.isEmpty()
                ? categoryDAO.getAllCategories()
                : categoryDAO.searchCategories(keyword);

        request.setAttribute("categories", categories);
        request.setAttribute("keyword", keyword);
        request.setAttribute("totalCategories", categories.size());
        request.getRequestDispatcher("/views/category/list.jsp")
                .forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        String action = request.getParameter("action");
        String redirectUrl = request.getContextPath()
                + "/dashboard/category-management";

        if (!canManageCategory(request)) {
            setFlash(request, "error", "You do not have permission to perform this action.");
            response.sendRedirect(redirectUrl);
            return;
        }

        if ("create".equals(action)) {
            String name = clean(request.getParameter("category_name"));

            String validationError = validateCategoryName(name);
            if (validationError != null) {
                setFlash(request, "error", validationError);
                response.sendRedirect(redirectUrl + "?action=create");
                return;
            }

            if (categoryDAO.isCategoryNameExists(name)) {
                setFlash(request, "error", "Category name already exists.");
                response.sendRedirect(redirectUrl + "?action=create");
                return;
            }

            boolean success = categoryDAO.insertCategory(name);
            setFlash(request, success ? "success" : "error",
                    success ? "Category added successfully." : "Could not add the category.");
            response.sendRedirect(redirectUrl + (success ? "" : "?action=create"));
            return;
        }

        if ("update".equals(action)) {
            int id = parseInt(request.getParameter("id"));
            String name = clean(request.getParameter("category_name"));

            if (id <= 0) {
                setFlash(request, "error", "Category Invalid ID.");
                response.sendRedirect(redirectUrl);
                return;
            }

            String validationError = validateCategoryName(name);
            if (validationError != null) {
                setFlash(request, "error", validationError);
                response.sendRedirect(redirectUrl + "?action=detail&id=" + id);
                return;
            }

            if (categoryDAO.isCategoryNameExists(name, id)) {
                setFlash(request, "error", "Category name already exists.");
                response.sendRedirect(redirectUrl + "?action=detail&id=" + id);
                return;
            }

            boolean success = categoryDAO.updateCategory(id, name);

            if (success) {
                setFlash(request, "success", "Category updated successfully.");
                response.sendRedirect(redirectUrl + "?action=detail&id=" + id);
            } else {
                setFlash(request, "error", "Could not update the category.");
                response.sendRedirect(redirectUrl + "?action=detail&id=" + id);
            }
            return;
        }

        if ("delete".equals(action)) {
            int id = parseInt(request.getParameter("id"));

            if (id <= 0) {
                setFlash(request, "error", "Category Invalid ID.");
                response.sendRedirect(redirectUrl);
                return;
            }

            int bookCount = categoryDAO.countBooksByCategory(id);
            if (bookCount > 0) {
                request.getSession().setAttribute(
                        "errorMessage", "A category containing books cannot be deleted.");
                response.sendRedirect(redirectUrl);
                return;
            }

            boolean success = categoryDAO.deleteCategory(id);
            setFlash(request, success ? "success" : "error",
                    success ? "Category deleted successfully." : "Could not delete the category.");
            response.sendRedirect(redirectUrl);
            return;
        }

        response.sendRedirect(redirectUrl);
    }

    private boolean canManageCategory(HttpServletRequest request) {
        HttpSession session = request.getSession(false);

        if (session == null) {
            return false;
        }

        Account account = (Account) session.getAttribute("account");

        if (account == null || account.getRole() == null) {
            return false;
        }

        String role = account.getRole().trim().toLowerCase();
        return "staff".equals(role) || "admin".equals(role);
    }

    private String validateCategoryName(String name) {
        if (name == null || name.isEmpty()) {
            return "Category name is required.";
        }

        if (name.length() > 100) {
            return "Category name cannot exceed 100 characters.";
        }

        if (!name.matches("^[\\p{L}\\s]+$")) {
            return "Category name may contain only letters and spaces, not numbers or special characters.";
        }

        return null;
    }

    private int parseInt(String value) {
        try {
            return Integer.parseInt(value);
        } catch (Exception e) {
            return 0;
        }
    }

    private String clean(String value) {
        return value == null ? "" : value.trim().replaceAll("\\s+", " ");
    }

    private void setFlash(HttpServletRequest request, String type, String message) {
        String attribute = "success".equals(type) ? "successMessage" : "errorMessage";
        request.getSession().setAttribute(attribute, message);
    }
}
