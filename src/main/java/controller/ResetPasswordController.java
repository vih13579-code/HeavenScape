package controller;

import dao.AccountDAO;
import dao.CustomerDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

public class ResetPasswordController extends HttpServlet {

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

    // Kiểm tra mật khẩu hợp lệ: 8–15 ký tự, có chữ hoa, chữ thường, số
    private boolean isValidPassword(String password) {
        // TODO: implement
        return false;
    }
    
    
}