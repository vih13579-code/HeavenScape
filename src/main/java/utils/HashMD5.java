package utils;

import java.security.MessageDigest;

/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */

/**
 *
 * @author DUY MINH
 */
public class HashMD5 {
    public static String hash(String str) {
        try {
            MessageDigest mes = MessageDigest.getInstance("MD5");
            byte[] mesMD5 = mes.digest(str.getBytes("UTF-8"));
            StringBuilder result = new StringBuilder();
            for (byte b : mesMD5) {
                String c = String.format("%02x", b);
                result.append(c);
            }
            return result.toString();
        } catch (Exception e) {
        }
        return "";
    }
}
