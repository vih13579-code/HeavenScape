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

public class CategoryManagementController extends HttpServlet {

    private final GenreDAO genreDAO = new GenreDAO();

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

    private boolean canManageCategory(HttpServletRequest request) {
        // TODO: implement
        return false;
    }

    private String validateGenreName(String name) {
        // TODO: implement
        return null;
    }

    private int parseInt(String value) {
        // TODO: implement
        return 0;
    }

    private String clean(String value) {
        // TODO: implement
        return null;
    }

    private void setFlash(HttpServletRequest request, String type, String message) {
        // TODO: implement
    }
}