package utils;

import com.cloudinary.Cloudinary;
import com.cloudinary.utils.ObjectUtils;
import java.io.File;
import java.util.HashMap;
import java.util.Map;

public class CloudinaryUtil {

    private static final String CLOUD_NAME = "duwjwn3lx";
    private static final String API_KEY = "936219846982452";
    private static final String API_SECRET = "KA2oDjHCqPVeP4qfr8BFLLap6Ao";

    private static Cloudinary cloudinary;

    static {
        Map<String, String> config = new HashMap<>();
        config.put("cloud_name", CLOUD_NAME);
        config.put("api_key", API_KEY);
        config.put("api_secret", API_SECRET);
        cloudinary = new Cloudinary(config);
    }

    public static String uploadImage(File file, String folder) {
        try {
            Map<String, Object> uploadParams = new HashMap<>();
            uploadParams.put("folder", folder);
            uploadParams.put("resource_type", "image");
            uploadParams.put("upload_preset", "unsigned_preset");
            Map<String, Object> result = cloudinary.uploader().upload(file, uploadParams);
            return (String) result.get("url");
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    public static String uploadImage(byte[] fileBytes, String fileName, String folder) {
        try {
            Map<String, Object> uploadParams = new HashMap<>();
            uploadParams.put("folder", folder);
            uploadParams.put("resource_type", "image");
            uploadParams.put("public_id", fileName);
            uploadParams.put("upload_preset", "unsigned_preset");
            Map<String, Object> result = cloudinary.uploader().upload(fileBytes, uploadParams);
            return (String) result.get("url");
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    public static void deleteImage(String publicId) {
        try {
            cloudinary.uploader().destroy(publicId, ObjectUtils.emptyMap());
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}