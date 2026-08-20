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

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        Account account = RoleGuard.requireStaff(request, response);
        if (account == null) {
            return;
        }

        try {
            Part filePart = request.getPart("file");
            if (filePart == null || filePart.getSize() == 0) {
                sendJson(response, "{\"ok\":false,\"message\":\"No file selected\"}");
                return;
            }

            String fileName = filePart.getSubmittedFileName();
            byte[] fileBytes = filePart.getInputStream().readAllBytes();

            String folder = "heavenscape/products";
            String imageUrl = CloudinaryUtil.uploadImage(fileBytes, fileName, folder);

            if (imageUrl != null) {
                sendJson(response, "{\"ok\":true,\"url\":\"" + imageUrl + "\"}");
            } else {
                sendJson(response, "{\"ok\":false,\"message\":\"Upload failed\"}");
            }
        } catch (Exception e) {
            e.printStackTrace();
            sendJson(response, "{\"ok\":false,\"message\":\"Error: " + e.getMessage() + "\"}");
        }
    }

    private void sendJson(HttpServletResponse response, String json) throws IOException {
        PrintWriter out = response.getWriter();
        out.print(json);
    }
}