package controller;

import dao.GenreDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;
import model.Account;
import model.Genre;

public class GenreManagementController extends HttpServlet {

    private final GenreDAO genreDAO = new GenreDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");
        boolean canManageGenre = canManageGenre(request);
        request.setAttribute("canManageGenre", canManageGenre);

        if ("create".equals(action)) {
            if (!canManageGenre) {
                setFlash(request, "error", "You do not have permission to add genres.");
                response.sendRedirect(request.getContextPath() + "/dashboard/genre-management");
                return;
            }
            request.setAttribute("pageTitle", "Add Genre");
            request.setAttribute("formAction", "create");
            request.getRequestDispatcher("/views/genre/form.jsp").forward(request, response);
            return;
        }

        if ("edit".equals(action) || "detail".equals(action)) {
            int id = parseInt(request.getParameter("id"));
            Genre genre = genreDAO.getGenreById(id);
            if (genre == null) {
                setFlash(request, "error", "Genre not found.");
                response.sendRedirect(request.getContextPath() + "/dashboard/genre-management");
                return;
            }
            request.setAttribute("genre", genre);
            if ("edit".equals(action)) {
                request.setAttribute("pageTitle", "Update Genre");
                request.setAttribute("formAction", "update");
                request.getRequestDispatcher("/views/genre/form.jsp").forward(request, response);
            } else {
                request.getRequestDispatcher("/views/genre/detail.jsp").forward(request, response);
            }
            return;
        }

        String keyword = clean(request.getParameter("keyword"));
        List<Genre> genres = keyword.isEmpty() ? genreDAO.getAllGenres() : genreDAO.searchGenres(keyword);
        request.setAttribute("genres", genres);
        request.setAttribute("keyword", keyword);
        request.setAttribute("totalGenres", genres.size());
        request.getRequestDispatcher("/views/genre/list.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");
        String redirectUrl = request.getContextPath() + "/dashboard/genre-management";
        if (!canManageGenre(request)) {
            setFlash(request, "error", "You do not have permission to perform this action.");
            response.sendRedirect(redirectUrl);
            return;
        }

        String name = clean(request.getParameter("genre_name"));
        if ("create".equals(action)) {
            String error = validateGenreName(name);
            if (error != null) {
                setFlash(request, "error", error);
                response.sendRedirect(redirectUrl + "?action=create");
                return;
            }
            if (genreDAO.isGenreNameExists(name)) {
                setFlash(request, "error", "Genre name already exists.");
                response.sendRedirect(redirectUrl + "?action=create");
                return;
            }
            boolean success = genreDAO.insertGenre(name);
            setFlash(request, success ? "success" : "error", success ? "Genre added successfully." : "Could not add the genre.");
            response.sendRedirect(redirectUrl + (success ? "" : "?action=create"));
            return;
        }

        int id = parseInt(request.getParameter("id"));
        if ("update".equals(action)) {
            String error = validateGenreName(name);
            if (id <= 0 || error != null || genreDAO.isGenreNameExists(name, id)) {
                setFlash(request, "error", error != null ? error : "Genre name already exists.");
                response.sendRedirect(redirectUrl + "?action=detail&id=" + id);
                return;
            }
            boolean success = genreDAO.updateGenre(id, name);
            setFlash(request, success ? "success" : "error", success ? "Genre updated successfully." : "Could not update the genre.");
            response.sendRedirect(redirectUrl + "?action=detail&id=" + id);
            return;
        }

        if ("delete".equals(action)) {
            if (id <= 0 || genreDAO.countBooksByGenre(id) > 0) {
                setFlash(request, "error", "A genre containing books cannot be deleted.");
            } else {
                boolean success = genreDAO.deleteGenre(id);
                setFlash(request, success ? "success" : "error", success ? "Genre deleted successfully." : "Could not delete the genre.");
            }
        }
        response.sendRedirect(redirectUrl);
    }

    private boolean canManageGenre(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session == null) return false;
        Account account = (Account) session.getAttribute("account");
        if (account == null || account.getRole() == null) return false;
        String role = account.getRole().trim().toLowerCase();
        return "staff".equals(role) || "admin".equals(role);
    }

    private String validateGenreName(String name) {
        if (name.isEmpty()) return "Genre name is required.";
        if (name.length() > 100) return "Genre name cannot exceed 100 characters.";
        if (!name.matches("^[\\p{L}\\s]+$")) return "Genre name may contain only letters and spaces, not numbers or special characters.";
        return null;
    }

    private int parseInt(String value) {
        try { return Integer.parseInt(value); } catch (Exception e) { return 0; }
    }

    private String clean(String value) {
        return value == null ? "" : value.trim().replaceAll("\\s+", " ");
    }

    private void setFlash(HttpServletRequest request, String type, String message) {
        request.getSession().setAttribute("success".equals(type) ? "successMessage" : "errorMessage", message);
    }
}
