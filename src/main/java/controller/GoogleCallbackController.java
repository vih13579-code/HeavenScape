package controller;

import dao.AccountDAO;
import dao.CustomerDAO;
import model.Account;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.*;
import java.net.*;
import java.nio.charset.StandardCharsets;

public class GoogleCallbackController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // TODO: implement
    }

    // Đổi authorization code → access_token
    private String exchangeCodeForToken(String code, String redirectUri) {
        // TODO: implement
        return null;
    }

    // Dùng access_token lấy email + name từ Google
    private String[] getUserInfo(String accessToken) {
        // TODO: implement
        return null;
    }

    // Parse giá trị từ JSON string đơn giản (không dùng thư viện)
    private String extractJsonValue(String json, String key) {
        // TODO: implement
        return null;
    }
}
