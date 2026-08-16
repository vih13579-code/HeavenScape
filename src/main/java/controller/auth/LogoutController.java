/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.auth;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

/**
 *
 * @author DUY MINH
 */
public class LogoutController extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Cancel session
        HttpSession session = request.getSession(false);
        if (session != null) {
            session.invalidate();
        }

        // Delete cookie
        Cookie emailCookie = new Cookie("savedEmail", "");
        emailCookie.setMaxAge(0);
        emailCookie.setHttpOnly(true);
        emailCookie.setPath("/");
        response.addCookie(emailCookie);

        // Redirect về home
        response.sendRedirect(request.getContextPath() + "/home");
    }
}
