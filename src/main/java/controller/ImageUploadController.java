package controller;

import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;
import utils.CloudinaryUtil;
import utils.RoleGuard;
import model.Account;

@MultipartConfig
public class ImageUploadController extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // TODO: implement
    }

    private void sendJson(HttpServletResponse response, String json) throws IOException {
        // TODO: implement
    }
}