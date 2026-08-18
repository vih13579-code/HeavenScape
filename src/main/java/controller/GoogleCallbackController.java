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

        // 1. Kiểm tra state chống CSRF
        String returnedState = request.getParameter("state");
        HttpSession session = request.getSession();
        String savedState = (String) session.getAttribute("google_oauth_state");

        if (returnedState == null || !returnedState.equals(savedState)) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // A state value must only be accepted once.
        session.removeAttribute("google_oauth_state");

        String redirectUri = (String) session.getAttribute("google_oauth_redirect_uri");
        session.removeAttribute("google_oauth_redirect_uri");
        if (redirectUri == null || redirectUri.isBlank()) {
            redirectUri = request.getRequestURL().toString();
        }

        String oauthError = request.getParameter("error");
        if (oauthError != null) {
            request.setAttribute("errorMessage", "Google sign-in was cancelled or denied.");
            request.getRequestDispatcher("/views/auth/login.jsp").forward(request, response);
            return;
        }

        // 2. Lấy authorization code
        String code = request.getParameter("code");
        if (code == null) {
            request.setAttribute("errorMessage", "Google sign-in failed.");
            request.getRequestDispatcher("/views/auth/login.jsp").forward(request, response);
            return;
        }

        // 3. Đổi code → access_token
        String accessToken = exchangeCodeForToken(code, redirectUri);
        if (accessToken == null) {
            request.setAttribute("errorMessage", "Could not obtain a token from Google.");
            request.getRequestDispatcher("/views/auth/login.jsp").forward(request, response);
            return;
        }

        // 4. Lấy thông tin user từ Google
        String[] userInfo = getUserInfo(accessToken); // [0]=email, [1]=name
        if (userInfo == null) {
            request.setAttribute("errorMessage", "Could not retrieve Google account information.");
            request.getRequestDispatcher("/views/auth/login.jsp").forward(request, response);
            return;
        }

        String email = userInfo[0];
        String fullname = userInfo[1];

        // 5. Kiểm tra email trong DB
        CustomerDAO customerDAO = new CustomerDAO();
        AccountDAO accountDAO = new AccountDAO();

        Account acc = null;

// Tìm trong bảng Customer trước 
        acc = customerDAO.getAccountByEmail(email);

// Nếu không phải Customer, thử tìm trong bảng Account(Staff/Admin
        if (acc == null) {
            acc = accountDAO.getAccountByEmail(email);
        }

        if (acc == null) {
            request.setAttribute("errorMessage",
                    "No account exists for this email. Please register before signing in with Google.");
            request.getRequestDispatcher("/views/auth/login.jsp").forward(request, response);
            return;
        }

        // Account is locked (giống điều kiện chặn ở login truyền thống)
        if ("inactive".equalsIgnoreCase(acc.getStatus())) {
            request.setAttribute("errorMessage",
                    "Your account has been disabled. Please contact an administrator.");
            request.getRequestDispatcher("/views/auth/login.jsp").forward(request, response);
            return;
        }

// 6. Tạo session với account thật từ DB
        session.setAttribute("account", acc);
        session.setMaxInactiveInterval(30 * 60);
        session.setAttribute("successMessage", "Google sign-in successful! Welcome " + acc.getFullname() + ".");
        response.sendRedirect(request.getContextPath() + "/home");
    }

    // Đổi authorization code → access_token
    private String exchangeCodeForToken(String code, String redirectUri) {
        try {
            URL url = new URL("https://oauth2.googleapis.com/token");
            HttpURLConnection conn = (HttpURLConnection) url.openConnection();
            conn.setRequestMethod("POST");
            conn.setDoOutput(true);
            conn.setRequestProperty("Content-Type", "application/x-www-form-urlencoded");

            String body = "code=" + URLEncoder.encode(code, "UTF-8")
                    + "&client_id=" + URLEncoder.encode(GoogleLoginController.getClientId(), "UTF-8")
                    + "&client_secret=" + URLEncoder.encode(GoogleLoginController.getClientSecret(), "UTF-8")
                    + "&redirect_uri=" + URLEncoder.encode(redirectUri, "UTF-8")
                    + "&grant_type=authorization_code";

            try (OutputStream os = conn.getOutputStream()) {
                os.write(body.getBytes(StandardCharsets.UTF_8));
            }

            // Đọc response JSON
            BufferedReader br = new BufferedReader(
                    new InputStreamReader(conn.getInputStream(), StandardCharsets.UTF_8));
            StringBuilder sb = new StringBuilder();
            String line;
            while ((line = br.readLine()) != null) {
                sb.append(line);
            }

            // Parse access_token từ JSON thủ công (không cần thư viện)
            String json = sb.toString();
            return extractJsonValue(json, "access_token");

        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    // Dùng access_token lấy email + name từ Google
    private String[] getUserInfo(String accessToken) {
        try {
            URL url = new URL("https://www.googleapis.com/oauth2/v3/userinfo");
            HttpURLConnection conn = (HttpURLConnection) url.openConnection();
            conn.setRequestMethod("GET");
            conn.setRequestProperty("Authorization", "Bearer " + accessToken);

            BufferedReader br = new BufferedReader(
                    new InputStreamReader(conn.getInputStream(), StandardCharsets.UTF_8));
            StringBuilder sb = new StringBuilder();
            String line;
            while ((line = br.readLine()) != null) {
                sb.append(line);
            }

            String json = sb.toString();
            String email = extractJsonValue(json, "email");
            String name = extractJsonValue(json, "name");

            if (email == null) {
                return null;
            }
            return new String[]{email, name != null ? name : email};

        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    // Parse giá trị từ JSON string đơn giản (không dùng thư viện)
    private String extractJsonValue(String json, String key) {
        String search = "\"" + key + "\"";
        int idx = json.indexOf(search);
        if (idx == -1) {
            return null;
        }
        idx = json.indexOf(":", idx) + 1;
        // Bỏ qua khoảng trắng
        while (idx < json.length() && json.charAt(idx) == ' ') {
            idx++;
        }
        if (json.charAt(idx) == '"') {
            int start = idx + 1;
            int end = json.indexOf("\"", start);
            return json.substring(start, end);
        }
        return null;
    }
}
