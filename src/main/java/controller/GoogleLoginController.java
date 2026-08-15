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
        // TODO: implement
    }

    private static boolean isMissingConfig(String value, String placeholder) {
        // TODO: implement
        return false;
    }

    public static String getClientId()     { return CLIENT_ID; }
    public static String getClientSecret() { return CLIENT_SECRET; }

    private static String buildRedirectUri(HttpServletRequest request) {
        // TODO: implement
        return null;
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // TODO: implement
    }
}
