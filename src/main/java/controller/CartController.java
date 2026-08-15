package controller;

import dao.CartDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Account;
import model.CartItem;

import java.io.IOException;
import java.io.PrintWriter;
import java.math.BigDecimal;
import java.util.List;

public class CartController extends HttpServlet {

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

    private void handleAdd(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        // TODO: implement
    }

    private void handleUpdate(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        // TODO: implement
    }

    private void handleRemove(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        // TODO: implement
    }

    private boolean isCustomer(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        // TODO: implement
        return false;
    }

    private Account getAccount(HttpServletRequest request) {
        // TODO: implement
        return null;
    }

    private int calcTotalQuantity(List<CartItem> items) {
        // TODO: implement
        return 0;
    }

    private int toInt(String value, int defaultVal) {
        // TODO: implement
        return 0;
    }

    private void sendJson(HttpServletResponse response, String json) throws IOException {
        // TODO: implement
    }
}
