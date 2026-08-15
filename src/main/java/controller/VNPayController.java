package controller;

import dao.BookDAO;
import dao.CartDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Account;
import model.CartItem;
import utils.VNPayConfig;

import java.io.IOException;
import java.math.BigDecimal;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.text.SimpleDateFormat;
import java.util.*;

public class VNPayController extends HttpServlet {

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

    private String buildVNPayUrl(HttpServletRequest request, String txnRef, BigDecimal total)
            throws IOException {
        // TODO: implement
        return null;
    }

    private boolean isEmpty(String value) {
        // TODO: implement
        return false;
    }
}
