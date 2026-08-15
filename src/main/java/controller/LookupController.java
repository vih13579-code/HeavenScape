package controller;

import dao.LookupDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Account;
import utils.RoleGuard;

import java.io.IOException;
import java.io.PrintWriter;

public class LookupController extends HttpServlet {

    private final LookupDAO lookupDAO = new LookupDAO();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        // TODO: implement
    }

    private void writeJson(HttpServletResponse resp, boolean ok, int id, String name, String message)
            throws IOException {
        // TODO: implement
    }

    private String escapeJson(String value) {
        // TODO: implement
        return null;
    }
}
