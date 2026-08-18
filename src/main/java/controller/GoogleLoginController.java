package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.math.BigInteger;
import java.security.SecureRandom;
import java.net.URLEncoder;

public class GoogleLoginController extends HttpServlet {

    private static String CLIENT_ID;
    private static String CLIENT_SECRET;

    @Override
    public void init() throws ServletException {
        CLIENT_ID     = getServletContext().getInitParameter("GOOGLE_CLIENT_ID");
        CLIENT_SECRET = getServletContext().getInitParameter("GOOGLE_CLIENT_SECRET");

        if (isMissingConfig(CLIENT_ID, "YOUR_GOOGLE_CLIENT_ID")
                || isMissingConfig(CLIENT_SECRET, "YOUR_GOOGLE_CLIENT_SECRET")) {
            throw new ServletException(
                "Missing GOOGLE_CLIENT_ID or GOOGLE_CLIENT_SECRET in context.xml");
        }
    }

    private static boolean isMissingConfig(String value, String placeholder) {
        return value == null || value.isBlank() || placeholder.equals(value.trim());
    }

    public static String getClientId()     { return CLIENT_ID; }
    public static String getClientSecret() { return CLIENT_SECRET; }

    private static String buildRedirectUri(HttpServletRequest request) {
        StringBuilder uri = new StringBuilder()
                .append(request.getScheme())
                .append("://")
                .append(request.getServerName());

        int port = request.getServerPort();
        boolean defaultPort = ("http".equalsIgnoreCase(request.getScheme()) && port == 80)
                || ("https".equalsIgnoreCase(request.getScheme()) && port == 443);
        if (!defaultPort) {
            uri.append(':').append(port);
        }

        return uri.append(request.getContextPath())
                .append("/auth/google/callback")
                .toString();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Tạo state ngẫu nhiên để chống CSRF
        String state = new BigInteger(130, new SecureRandom()).toString(32);
        HttpSession session = request.getSession();
        session.setAttribute("google_oauth_state", state);

        String redirectUri = buildRedirectUri(request);
        session.setAttribute("google_oauth_redirect_uri", redirectUri);

        // Tạo URL redirect tới Google
        String googleAuthUrl = "https://accounts.google.com/o/oauth2/v2/auth"
                + "?client_id="    + URLEncoder.encode(CLIENT_ID,    "UTF-8")
                + "&redirect_uri=" + URLEncoder.encode(redirectUri, "UTF-8")
                + "&response_type=code"
                + "&scope="        + URLEncoder.encode("openid email profile", "UTF-8")
                + "&state="        + URLEncoder.encode(state,        "UTF-8")
                + "&access_type=online";

        response.sendRedirect(googleAuthUrl);
    }
}
