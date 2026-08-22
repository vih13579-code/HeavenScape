package utils;

import com.cloudinary.Cloudinary;
import com.cloudinary.utils.ObjectUtils;
import java.io.File;
import java.io.IOException;
import java.util.HashMap;
import java.util.Map;
import java.util.UUID;

public class CloudinaryUtil {

    private static final String CLOUD_NAME = "llfxqkny";
    private static final String API_KEY = "563459248983587";
    private static final String API_SECRET = "c9ypetmB_8oAkEypn_EZAyhJknM";

    private static final Cloudinary cloudinary;

    static {
        Map<String, String> config = new HashMap<>();
        config.put("cloud_name", CLOUD_NAME);
        config.put("api_key", API_KEY);
        config.put("api_secret", API_SECRET);
        cloudinary = new Cloudinary(config);
    }

    public static String uploadImage(File file, String folder) throws IOException {
        return upload(file, file.getName(), folder);
    }

    public static String uploadImage(byte[] fileBytes, String fileName, String folder)
            throws IOException {
        return upload(fileBytes, fileName, folder);
    }

    private static String upload(Object source, String fileName, String folder)
            throws IOException {
        Map<String, Object> uploadParams = new HashMap<>();
        uploadParams.put("folder", folder);
        uploadParams.put("resource_type", "image");
        uploadParams.put("public_id", buildPublicId(fileName));
        uploadParams.put("overwrite", false);

        // This is a server-side signed upload, so an unsigned upload preset is
        // neither required nor valid unless that preset exists in Cloudinary.
        Map<String, Object> result = cloudinary.uploader().upload(source, uploadParams);
        Object imageUrl = result.get("secure_url");
        if (imageUrl == null) {
            imageUrl = result.get("url");
        }
        if (imageUrl == null) {
            throw new IOException("Cloudinary did not return an image URL");
        }
        return imageUrl.toString();
    }

    private static String buildPublicId(String fileName) {
        String baseName = fileName == null ? "image" : fileName;
        baseName = baseName.replace('\\', '/');
        int slashIndex = baseName.lastIndexOf('/');
        if (slashIndex >= 0) {
            baseName = baseName.substring(slashIndex + 1);
        }
        int extensionIndex = baseName.lastIndexOf('.');
        if (extensionIndex > 0) {
            baseName = baseName.substring(0, extensionIndex);
        }
        baseName = baseName.replaceAll("[^a-zA-Z0-9_-]", "-")
                .replaceAll("-+", "-")
                .replaceAll("^-|-$", "");
        if (baseName.isEmpty()) {
            baseName = "image";
        }
        return baseName + "-" + UUID.randomUUID();
    }

    public static void deleteImage(String publicId) {
        try {
            cloudinary.uploader().destroy(publicId, ObjectUtils.emptyMap());
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
