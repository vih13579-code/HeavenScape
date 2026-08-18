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

        resp.setContentType("application/json");
        resp.setCharacterEncoding("UTF-8");

        Account account = RoleGuard.requireStaff(req, resp);
        if (account == null) {
            return;
        }

        String type = req.getParameter("type");
        String name = req.getParameter("name");

        if (type == null || type.isBlank() || name == null || name.isBlank()) {
            writeJson(resp, false, -1, name, "Missing item type or name");
            return;
        }

        int id = lookupDAO.insertLookup(type, name);
        if (id <= 0) {
            writeJson(resp, false, -1, name, "Could not add the new item");
            return;
        }

        writeJson(resp, true, id, name.trim(), "Added successfully");
    }

    private void writeJson(HttpServletResponse resp, boolean ok, int id, String name, String message)
            throws IOException {
        PrintWriter out = resp.getWriter();
        out.print("{\"ok\":"
                + ok
                + ",\"id\":"
                + id
                + ",\"name\":\""
                + escapeJson(name == null ? "" : name.trim())
                + "\",\"message\":\""
                + escapeJson(message)
                + "\"}");
        out.flush();
    }

    private String escapeJson(String value) {
        return value
                .replace("\\", "\\\\")
                .replace("\"", "\\\"")
                .replace("\n", "\\n")
                .replace("\r", "\\r");
    }
}
