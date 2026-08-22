package controller;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.Locale;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;
import utils.CloudinaryUtil;
import utils.RoleGuard;
import model.Account;

@MultipartConfig(
        maxFileSize = 10L * 1024 * 1024,
        maxRequestSize = 11L * 1024 * 1024
)
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
                sendError(response, HttpServletResponse.SC_BAD_REQUEST, "No file selected");
                return;
            }

            String contentType = filePart.getContentType();
            if (contentType == null
                    || !contentType.toLowerCase(Locale.ROOT).startsWith("image/")) {
                sendError(response, HttpServletResponse.SC_UNSUPPORTED_MEDIA_TYPE,
                        "Only image files are supported");
                return;
            }

            String fileName = filePart.getSubmittedFileName();
            byte[] fileBytes = filePart.getInputStream().readAllBytes();

            String folder = "heavenscape/products";
            String imageUrl = CloudinaryUtil.uploadImage(fileBytes, fileName, folder);

            sendJson(response, "{\"ok\":true,\"url\":\"" + escapeJson(imageUrl) + "\"}");
        } catch (IllegalStateException e) {
            sendError(response, HttpServletResponse.SC_REQUEST_ENTITY_TOO_LARGE,
                    "Image must not exceed 10 MB");
        } catch (Exception e) {
            e.printStackTrace();
            String message = e.getMessage();
            if (message == null || message.trim().isEmpty()) {
                message = "Cloudinary upload failed";
            }
            sendError(response, HttpServletResponse.SC_BAD_GATEWAY, message);
        }
    }

    private void sendError(HttpServletResponse response, int status, String message)
            throws IOException {
        response.setStatus(status);
        sendJson(response, "{\"ok\":false,\"message\":\""
                + escapeJson(message) + "\"}");
    }

    private String escapeJson(String value) {
        return value.replace("\\", "\\\\")
                .replace("\"", "\\\"")
                .replace("\r", "\\r")
                .replace("\n", "\\n");
    }

    private void sendJson(HttpServletResponse response, String json) throws IOException {
        PrintWriter out = response.getWriter();
        out.print(json);
    }
}
