package utils;

import jakarta.mail.*;
import jakarta.mail.internet.*;
import java.io.UnsupportedEncodingException;
import java.util.Properties;

/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
/**
 *
 * @author DUY MINH
 */
public class EmailUtil {

    private static final String FROM_EMAIL = "minhnldce181159@fpt.edu.vn";
    private static final String APP_PASSWORD = "ktue pxfq dwib djds";

    public static void sendOtp(String toEmail, String otp) throws MessagingException, UnsupportedEncodingException {
        Properties props = new Properties();
        props.put("mail.smtp.host", "smtp.gmail.com");
        props.put("mail.smtp.port", "587");
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");

        Session session = Session.getInstance(props, new Authenticator() {
            @Override
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(FROM_EMAIL, APP_PASSWORD);
            }
        });

        Message message = new MimeMessage(session);
        message.setFrom(new InternetAddress(FROM_EMAIL, "HeavenScape Support", "UTF-8"));
        message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(toEmail));
        message.setSubject("HeavenScape - Account Registration Verification Code");
        message.setContent(buildEmailHtml(otp), "text/html; charset=UTF-8");

        Transport.send(message);
    }

    private static String buildEmailHtml(String otp) {
        return "<div style=\"font-family: Arial, sans-serif; background-color: #f4f7f6; margin: 0; padding: 30px 0;\">"
                + "  <div style=\"max-width: 600px; margin: 0 auto; background-color: #ffffff; border-radius: 8px; overflow: hidden; border: 1px solid #e0e0e0;\">"
                // Header
                + "    <div style=\"background-color: #134aa4; padding: 20px; text-align: center;\">"
                + "      <div style=\"color: #ffffff; font-family: Arial, sans-serif; font-size: 28px; font-weight: 800; letter-spacing: 2px; text-align: center;\">HEAVENSCAPE</div>"
                + "    </div>"
                // Content
                + "    <div style=\"padding: 30px 40px;\">"
                + "      <h2 style=\"color: #333333; font-size: 20px; margin-top: 0;\">Verify Your Email Address</h2>"
                + "      <p style=\"color: #555555; font-size: 15px; line-height: 1.6;\">"
                + "        Hello,<br><br>"
                + "        Thank you for using HeavenScape. You requested to create an account. To complete registration, use the one-time password (OTP) below:"
                + "      </p>"
                // Mã OTP
                + "      <div style=\"text-align: center; margin: 35px 0;\">"
                + "        <span style=\"display: inline-block; font-size: 34px; font-weight: bold; color: #134aa4; background-color: #f0f5fa; padding: 15px 40px; border-radius: 6px; letter-spacing: 6px; border: 1px dashed #134aa4;\">"
                + otp
                + "        </span>"
                + "      </div>"
                + "      <p style=\"color: #555555; font-size: 15px; line-height: 1.6;\">"
                + "        <strong>Note:</strong> This verification code is valid for 5 minutes. Never share it with anyone."
                + "      </p>"
                + "      <div style=\"border-top: 1px solid #eeeeee; margin-top: 30px; padding-top: 20px;\">"
                + "        <p style=\"color: #888888; font-size: 13px; line-height: 1.5; margin: 0;\">"
                + "          If you did not make this request, ignore this email. The request will expire automatically and your account will remain secure."
                + "        </p>"
                + "      </div>"
                + "    </div>"
                // Footer
                + "    <div style=\"background-color: #f9f9f9; padding: 20px; text-align: center; border-top: 1px solid #eeeeee;\">"
                + "      <p style=\"color: #999999; font-size: 13px; margin: 0;\">"
                + "        &copy; 2026 HeavenScape. All rights reserved."
                + "      </p>"
                + "    </div>"
                + "  </div>"
                + "</div>";
    }

    public static void sendRefundPendingEmail(String toEmail, model.Order order)
            throws MessagingException, UnsupportedEncodingException {
        Properties props = new Properties();
        props.put("mail.smtp.host", "smtp.gmail.com");
        props.put("mail.smtp.port", "587");
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");

        Session session = Session.getInstance(props, new Authenticator() {
            @Override
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(FROM_EMAIL, APP_PASSWORD);
            }
        });

        Message message = new MimeMessage(session);
        message.setFrom(new InternetAddress(FROM_EMAIL, "HeavenScape Support", "UTF-8"));
        message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(toEmail));
        message.setSubject("HeavenScape - Order Cancellation and Refund Processing " + order.getOrderCode());
        message.setContent(buildRefundPendingEmailHtml(order), "text/html; charset=UTF-8");

        Transport.send(message);
    }

    public static void sendRefundConfirmedEmail(String toEmail, model.Order order)
            throws MessagingException, UnsupportedEncodingException {
        Properties props = new Properties();
        props.put("mail.smtp.host", "smtp.gmail.com");
        props.put("mail.smtp.port", "587");
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");

        Session session = Session.getInstance(props, new Authenticator() {
            @Override
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(FROM_EMAIL, APP_PASSWORD);
            }
        });

        Message message = new MimeMessage(session);
        message.setFrom(new InternetAddress(FROM_EMAIL, "HeavenScape Support", "UTF-8"));
        message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(toEmail));
        message.setSubject("HeavenScape - Refund Confirmation for Order " + order.getOrderCode());
        message.setContent(buildRefundConfirmedEmailHtml(order), "text/html; charset=UTF-8");

        Transport.send(message);
    }

    private static String buildRefundPendingEmailHtml(model.Order order) {
        java.text.NumberFormat nf = java.text.NumberFormat.getInstance(java.util.Locale.US);
        String formattedPrice = nf.format(order.getTotalPrice()) + " VND";

        return "<div style=\"font-family: Arial, sans-serif; background-color: #f4f7f6; margin: 0; padding: 30px 0;\">"
                + "  <div style=\"max-width: 600px; margin: 0 auto; background-color: #ffffff; border-radius: 8px; overflow: hidden; border: 1px solid #e0e0e0;\">"
                // Header
                + "    <div style=\"background-color: #134aa4; padding: 20px; text-align: center;\">"
                + "      <div style=\"color: #ffffff; font-family: Arial, sans-serif; font-size: 28px; font-weight: 800; letter-spacing: 2px; text-align: center;\">HEAVENSCAPE</div>"
                + "    </div>"
                // Content
                + "    <div style=\"padding: 30px 40px;\">"
                + "      <h2 style=\"color: #e65c00; font-size: 20px; margin-top: 0;\">Order Cancellation and Refund Processing</h2>"
                + "      <p style=\"color: #555555; font-size: 15px; line-height: 1.6;\">"
                + "        Hello,<br><br>"
                + "        Order <strong>" + order.getOrderCode()
                + "</strong> was cancelled successfully. "
                + "        We will process a refund for the amount paid."
                + "      </p>"
                // Thông tin chi tiết
                + "      <div style=\"background-color: #fff8f0; padding: 15px; border-radius: 6px; margin: 20px 0; border: 1px solid #ffe0b2;\">"
                + "        <table style=\"width: 100%; border-collapse: collapse; font-size: 14px;\">"
                + "          <tr>"
                + "            <td style=\"padding: 5px 0; color: #777777;\">Order Code:</td>"
                + "            <td style=\"padding: 5px 0; font-weight: bold; text-align: right;\">"
                + order.getOrderCode() + "</td>"
                + "          </tr>"
                + "          <tr>"
                + "            <td style=\"padding: 5px 0; color: #777777;\">Refund Amount:</td>"
                + "            <td style=\"padding: 5px 0; font-weight: bold; color: #e65c00; text-align: right;\">"
                + formattedPrice + "</td>"
                + "          </tr>"
                + "          <tr>"
                + "            <td style=\"padding: 5px 0; color: #777777;\">Refund Status:</td>"
                + "            <td style=\"padding: 5px 0; font-weight: bold; color: #e65c00; text-align: right;\">Processing</td>"
                + "          </tr>"
                + "          <tr>"
                + "            <td style=\"padding: 5px 0; color: #777777;\">Estimated Time:</td>"
                + "            <td style=\"padding: 5px 0; font-weight: bold; text-align: right;\">2–5 business days</td>"
                + "          </tr>"
                + "        </table>"
                + "      </div>"
                + "      <p style=\"color: #555555; font-size: 15px; line-height: 1.6;\">"
                + "        <strong>Note:</strong> The refund will be returned to the bank account or linked wallet used for the VNPAY payment. "
                + "        You will receive a confirmation email when the refund is complete."
                + "      </p>"
                + "      <div style=\"border-top: 1px solid #eeeeee; margin-top: 30px; padding-top: 20px;\">"
                + "        <p style=\"color: #888888; font-size: 13px; line-height: 1.5; margin: 0;\">If you need help, please contact HeavenScape support.</p>"
                + "      </div>"
                + "    </div>"
                // Footer
                + "    <div style=\"background-color: #f9f9f9; padding: 20px; text-align: center; border-top: 1px solid #eeeeee;\">"
                + "      <p style=\"color: #999999; font-size: 13px; margin: 0;\">&copy; 2026 HeavenScape. All rights reserved.</p>"
                + "    </div>"
                + "  </div>"
                + "</div>";
    }

    private static String buildRefundConfirmedEmailHtml(model.Order order) {
        java.text.NumberFormat nf = java.text.NumberFormat.getInstance(java.util.Locale.US);
        String formattedPrice = nf.format(order.getTotalPrice()) + " VND";

        return "<div style=\"font-family: Arial, sans-serif; background-color: #f4f7f6; margin: 0; padding: 30px 0;\">"
                + "  <div style=\"max-width: 600px; margin: 0 auto; background-color: #ffffff; border-radius: 8px; overflow: hidden; border: 1px solid #e0e0e0;\">"
                // Header
                + "    <div style=\"background-color: #134aa4; padding: 20px; text-align: center;\">"
                + "      <div style=\"color: #ffffff; font-family: Arial, sans-serif; font-size: 28px; font-weight: 800; letter-spacing: 2px; text-align: center;\">HEAVENSCAPE</div>"
                + "    </div>"
                // Content
                + "    <div style=\"padding: 30px 40px;\">"
                + "      <h2 style=\"color: #2E7D32; font-size: 20px; margin-top: 0;\">Refund Completed Successfully</h2>"
                + "      <p style=\"color: #555555; font-size: 15px; line-height: 1.6;\">"
                + "        Hello,<br><br>"
                + "        The payment for order <strong>" + order.getOrderCode()
                + "</strong> was successfully refunded to your account."
                + "      </p>"
                // Thông tin chi tiết
                + "      <div style=\"background-color: #f0fff4; padding: 15px; border-radius: 6px; margin: 20px 0; border: 1px solid #c8e6c9;\">"
                + "        <table style=\"width: 100%; border-collapse: collapse; font-size: 14px;\">"
                + "          <tr>"
                + "            <td style=\"padding: 5px 0; color: #777777;\">Order Code:</td>"
                + "            <td style=\"padding: 5px 0; font-weight: bold; text-align: right;\">"
                + order.getOrderCode() + "</td>"
                + "          </tr>"
                + "          <tr>"
                + "            <td style=\"padding: 5px 0; color: #777777;\">Refund Method:</td>"
                + "            <td style=\"padding: 5px 0; font-weight: bold; text-align: right;\">Manual Transfer (HeavenScape)</td>"
                + "          </tr>"
                + "          <tr>"
                + "            <td style=\"padding: 5px 0; color: #777777;\">Refunded Amount:</td>"
                + "            <td style=\"padding: 5px 0; font-weight: bold; color: #2E7D32; text-align: right;\">"
                + formattedPrice + "</td>"
                + "          </tr>"
                + "          <tr>"
                + "            <td style=\"padding: 5px 0; color: #777777;\">Status:</td>"
                + "            <td style=\"padding: 5px 0; font-weight: bold; color: #2E7D32; text-align: right;\">Completed ✓</td>"
                + "          </tr>"
                + "        </table>"
                + "      </div>"
                + "      <p style=\"color: #555555; font-size: 15px; line-height: 1.6;\">"
                + "        The refund was transferred to your bank account or linked wallet. "
                + "        If you have not received the funds after 1–2 business days, please contact HeavenScape support."
                + "      </p>"
                + "      <div style=\"border-top: 1px solid #eeeeee; margin-top: 30px; padding-top: 20px;\">"
                + "        <p style=\"color: #888888; font-size: 13px; line-height: 1.5; margin: 0;\">Thank you for choosing HeavenScape.</p>"
                + "      </div>"
                + "    </div>"
                // Footer
                + "    <div style=\"background-color: #f9f9f9; padding: 20px; text-align: center; border-top: 1px solid #eeeeee;\">"
                + "      <p style=\"color: #999999; font-size: 13px; margin: 0;\">&copy; 2026 HeavenScape. All rights reserved.</p>"
                + "    </div>"
                + "  </div>"
                + "</div>";
    }

    public static void sendStaffAccount(
            String toEmail,
            String fullName,
            String username,
            String password) throws MessagingException, UnsupportedEncodingException {

        Properties props = new Properties();
        props.put("mail.smtp.host", "smtp.gmail.com");
        props.put("mail.smtp.port", "587");
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");

        Session session = Session.getInstance(props, new Authenticator() {
            @Override
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(FROM_EMAIL, APP_PASSWORD);
            }
        });

        Message message = new MimeMessage(session);

        message.setFrom(new InternetAddress(
                FROM_EMAIL,
                "HeavenScape Support",
                "UTF-8"));

        message.setRecipients(
                Message.RecipientType.TO,
                InternetAddress.parse(toEmail));

        message.setSubject("HeavenScape - Staff Account");

        message.setContent(
                buildStaffAccountHtml(fullName, username, password),
                "text/html; charset=UTF-8");

        Transport.send(message);
    }

    private static String buildStaffAccountHtml(
            String fullName,
            String username,
            String password) {
        String safeName = (fullName == null || fullName.trim().isEmpty()) ? "Staff Member" : fullName;

        return "<div style=\"font-family: Arial, sans-serif; background-color: #f4f7f6; margin: 0; padding: 30px 0;\">"
                + "  <div style=\"max-width: 600px; margin: 0 auto; background-color: #ffffff; border-radius: 8px; overflow: hidden; border: 1px solid #e0e0e0;\">"
                // Header
                + "    <div style=\"background-color: #134aa4; padding: 20px; text-align: center;\">"
                + "      <div style=\"color: #ffffff; font-family: Arial, sans-serif; font-size: 28px; font-weight: 800; letter-spacing: 2px; text-align: center;\">HEAVENSCAPE</div>"
                + "    </div>"
                // Content
                + "    <div style=\"padding: 30px 40px;\">"
                + "      <h2 style=\"color: #333333; font-size: 20px; margin-top: 0;\">Staff Account Created</h2>"
                + "      <p style=\"color: #555555; font-size: 15px; line-height: 1.6;\">"
                + "        Hello <strong>" + safeName + "</strong>,<br><br>"
                + "        Your HeavenScape staff account was created successfully. "
                + "        Your sign-in details are shown below:"
                + "      </p>"
                // Thông tin tài khoản
                + "      <div style=\"background-color: #f0f5fa; padding: 15px; border-radius: 6px; margin: 20px 0; border: 1px solid #cfe0f5;\">"
                + "        <table style=\"width: 100%; border-collapse: collapse; font-size: 14px;\">"
                + "          <tr>"
                + "            <td style=\"padding: 5px 0; color: #777777;\">Username:</td>"
                + "            <td style=\"padding: 5px 0; font-weight: bold; text-align: right;\">" + username
                + "</td>"
                + "          </tr>"
                + "          <tr>"
                + "            <td style=\"padding: 5px 0; color: #777777;\">Password:</td>"
                + "            <td style=\"padding: 5px 0; font-weight: bold; color: #134aa4; text-align: right;\">"
                + password + "</td>"
                + "          </tr>"
                + "        </table>"
                + "      </div>"
                + "      <p style=\"color: #555555; font-size: 15px; line-height: 1.6;\">"
                + "        <strong>Note:</strong> For security, change your password immediately after your first sign-in "
                + "        and do not share these details with anyone."
                + "      </p>"
                + "      <div style=\"border-top: 1px solid #eeeeee; margin-top: 30px; padding-top: 20px;\">"
                + "        <p style=\"color: #888888; font-size: 13px; line-height: 1.5; margin: 0;\">"
                + "          If you did not request this account, contact HeavenScape support immediately."
                + "        </p>"
                + "      </div>"
                + "    </div>"
                // Footer
                + "    <div style=\"background-color: #f9f9f9; padding: 20px; text-align: center; border-top: 1px solid #eeeeee;\">"
                + "      <p style=\"color: #999999; font-size: 13px; margin: 0;\">"
                + "        &copy; 2026 HeavenScape. All rights reserved."
                + "      </p>"
                + "    </div>"
                + "  </div>"
                + "</div>";
    }

    public static void sendOrderCancelledEmail(String toEmail, model.Order order, String cancelReason)
            throws MessagingException, java.io.UnsupportedEncodingException {

        Properties props = new Properties();
        props.put("mail.smtp.host", "smtp.gmail.com");
        props.put("mail.smtp.port", "587");
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");

        Session session = Session.getInstance(props, new Authenticator() {
            @Override
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(FROM_EMAIL, APP_PASSWORD);
            }
        });

        Message message = new MimeMessage(session);
        message.setFrom(new InternetAddress(FROM_EMAIL, "HeavenScape Support", "UTF-8"));
        message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(toEmail));
        message.setSubject("HeavenScape - Order " + order.getOrderCode() + " Cancelled");
        message.setContent(buildOrderCancelledHtml(order, cancelReason), "text/html; charset=UTF-8");

        Transport.send(message);
    }

    private static String buildOrderCancelledHtml(model.Order order, String cancelReason) {
        java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat("dd/MM/yyyy HH:mm");
        String createdAtStr = order.getCreatedAt() != null ? sdf.format(order.getCreatedAt()) : "";
        String priceStr = String.format("%,.0f", order.getTotalPrice()) + " VND";
        String reason = (cancelReason != null && !cancelReason.trim().isEmpty()) ? cancelReason : "No reason provided";

        return "<div style=\"font-family: Arial, sans-serif; background-color: #f4f7f6; margin: 0; padding: 30px 0;\">"
                + "  <div style=\"max-width: 600px; margin: 0 auto; background-color: #ffffff; border-radius: 8px; overflow: hidden; border: 1px solid #e0e0e0;\">"
                // Header
                + "    <div style=\"background-color: #134aa4; padding: 20px; text-align: center;\">"
                + "      <div style=\"color: #ffffff; font-family: Arial, sans-serif; font-size: 28px; font-weight: 800; letter-spacing: 2px; text-align: center;\">HEAVENSCAPE</div>"
                + "    </div>"
                // Content
                + "    <div style=\"padding: 30px 40px;\">"
                + "      <h2 style=\"color: #D32F2F; font-size: 20px; margin-top: 0;\">Order Cancelled</h2>"
                + "      <p style=\"color: #555555; font-size: 15px; line-height: 1.6;\">Hello <strong>"
                + (order.getCustomerName() != null ? order.getCustomerName() : "") + "</strong>,<br><br>"
                + "      Your order was cancelled. Details are provided below:</p>"
                // Thông tin đơn
                + "      <table style=\"width: 100%; border-collapse: collapse; margin: 20px 0;\">"
                + "        <tr style=\"background-color: #f9f9f9;\">"
                + "          <td style=\"padding: 10px 16px; font-size: 14px; color: #555; border-bottom: 1px solid #eee;\"><b>Order Code</b></td>"
                + "          <td style=\"padding: 10px 16px; font-size: 14px; color: #071e27; border-bottom: 1px solid #eee;\">"
                + order.getOrderCode() + "</td>"
                + "        </tr>"
                + "        <tr>"
                + "          <td style=\"padding: 10px 16px; font-size: 14px; color: #555; border-bottom: 1px solid #eee;\"><b>Order Date</b></td>"
                + "          <td style=\"padding: 10px 16px; font-size: 14px; color: #071e27; border-bottom: 1px solid #eee;\">"
                + createdAtStr + "</td>"
                + "        </tr>"
                + "        <tr style=\"background-color: #f9f9f9;\">"
                + "          <td style=\"padding: 10px 16px; font-size: 14px; color: #555; border-bottom: 1px solid #eee;\"><b>Total Amount</b></td>"
                + "          <td style=\"padding: 10px 16px; font-size: 14px; color: #071e27; border-bottom: 1px solid #eee;\">"
                + priceStr + "</td>"
                + "        </tr>"
                + "        <tr>"
                + "          <td style=\"padding: 10px 16px; font-size: 14px; color: #555;\"><b>Cancellation Reason</b></td>"
                + "          <td style=\"padding: 10px 16px; font-size: 14px; color: #D32F2F;\"><b>" + reason
                + "</b></td>"
                + "        </tr>"
                + "      </table>"
                + "      <p style=\"color: #555555; font-size: 14px; line-height: 1.6;\">If you have any questions, please contact HeavenScape support.</p>"
                + "      <div style=\"border-top: 1px solid #eeeeee; margin-top: 30px; padding-top: 20px;\">"
                + "        <p style=\"color: #888888; font-size: 13px; line-height: 1.5; margin: 0;\">Thank you for using HeavenScape!</p>"
                + "      </div>"
                + "    </div>"
                // Footer
                + "    <div style=\"background-color: #f9f9f9; padding: 20px; text-align: center; border-top: 1px solid #eeeeee;\">"
                + "      <p style=\"color: #999999; font-size: 13px; margin: 0;\">&copy; 2026 HeavenScape. All rights reserved.</p>"
                + "    </div>"
                + "  </div>"
                + "</div>";
    }

    public static void sendAccountLockedEmail(String toEmail, String fullName)
            throws MessagingException, UnsupportedEncodingException {

        Properties props = new Properties();
        props.put("mail.smtp.host", "smtp.gmail.com");
        props.put("mail.smtp.port", "587");
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");

        Session session = Session.getInstance(props, new Authenticator() {
            @Override
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(FROM_EMAIL, APP_PASSWORD);
            }
        });

        Message message = new MimeMessage(session);
        message.setFrom(new InternetAddress(FROM_EMAIL, "HeavenScape Support", "UTF-8"));
        message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(toEmail));
        message.setSubject("HeavenScape - Your Account Has Been Locked");
        message.setContent(buildAccountStatusEmailHtml(fullName, true), "text/html; charset=UTF-8");

        Transport.send(message);
    }

    public static void sendAccountUnlockedEmail(String toEmail, String fullName)
            throws MessagingException, UnsupportedEncodingException {

        Properties props = new Properties();
        props.put("mail.smtp.host", "smtp.gmail.com");
        props.put("mail.smtp.port", "587");
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");

        Session session = Session.getInstance(props, new Authenticator() {
            @Override
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(FROM_EMAIL, APP_PASSWORD);
            }
        });

        Message message = new MimeMessage(session);
        message.setFrom(new InternetAddress(FROM_EMAIL, "HeavenScape Support", "UTF-8"));
        message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(toEmail));
        message.setSubject("HeavenScape - Your Account Has Been Unlocked");
        message.setContent(buildAccountStatusEmailHtml(fullName, false), "text/html; charset=UTF-8");

        Transport.send(message);
    }

    private static String buildAccountStatusEmailHtml(String fullName, boolean locked) {
        String safeName = (fullName == null || fullName.trim().isEmpty()) ? "Customer" : fullName;

        String title = locked ? "Account is locked" : "Account Unlocked";
        String titleColor = locked ? "#D32F2F" : "#2E7D32";

        String content = locked
                ? "Your HeavenScape account was <strong>locked</strong> by an administrator. "
                        + "While it is locked, you cannot sign in or use the system."
                : "Your HeavenScape account has been <strong>unlocked</strong>. "
                        + "You can sign in and continue using the system as usual.";

        String note = locked
                ? "If you believe this was a mistake, please contact HeavenScape support."
                : "If you did not request this account unlock, contact HeavenScape support immediately.";

        return "<div style=\"font-family: Arial, sans-serif; background-color: #f4f7f6; margin: 0; padding: 30px 0;\">"
                + "  <div style=\"max-width: 600px; margin: 0 auto; background-color: #ffffff; border-radius: 8px; overflow: hidden; border: 1px solid #e0e0e0;\">"
                // Header
                + "    <div style=\"background-color: #134aa4; padding: 20px; text-align: center;\">"
                + "      <div style=\"color: #ffffff; font-family: Arial, sans-serif; font-size: 28px; font-weight: 800; letter-spacing: 2px; text-align: center;\">HEAVENSCAPE</div>"
                + "    </div>"
                // Content
                + "    <div style=\"padding: 30px 40px;\">"
                + "      <h2 style=\"color: " + titleColor + "; font-size: 20px; margin-top: 0;\">" + title + "</h2>"
                + "      <p style=\"color: #555555; font-size: 15px; line-height: 1.6;\">"
                + "        Hello <strong>" + safeName + "</strong>,<br><br>"
                + content
                + "      </p>"
                + "      <div style=\"border-top: 1px solid #eeeeee; margin-top: 30px; padding-top: 20px;\">"
                + "        <p style=\"color: #888888; font-size: 13px; line-height: 1.5; margin: 0;\">"
                + note
                + "        </p>"
                + "      </div>"
                + "    </div>"
                // Footer
                + "    <div style=\"background-color: #f9f9f9; padding: 20px; text-align: center; border-top: 1px solid #eeeeee;\">"
                + "      <p style=\"color: #999999; font-size: 13px; margin: 0;\">"
                + "        &copy; 2026 HeavenScape. All rights reserved."
                + "      </p>"
                + "    </div>"
                + "  </div>"
                + "</div>";
    }

    public static void sendAccountLockedForViolationEmail(String toEmail, String fullName)
            throws MessagingException, UnsupportedEncodingException {
        Properties props = new Properties();
        props.put("mail.smtp.host", "smtp.gmail.com");
        props.put("mail.smtp.port", "587");
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");
        Session session = Session.getInstance(props, new Authenticator() {
            @Override
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(FROM_EMAIL, APP_PASSWORD);
            }
        });
        Message message = new MimeMessage(session);
        message.setFrom(new InternetAddress(FROM_EMAIL, "HeavenScape Support", "UTF-8"));
        message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(toEmail));
        message.setSubject("HeavenScape - Your Account Was Locked for a Policy Violation");
        message.setContent(buildAccountViolationLockedHtml(fullName), "text/html; charset=UTF-8");
        Transport.send(message);
    }

    private static String buildAccountViolationLockedHtml(String fullName) {
        String safeName = (fullName == null || fullName.trim().isEmpty()) ? "Customer" : fullName;
        return "<div style=\"font-family: Arial, sans-serif; background-color: #f4f7f6; margin: 0; padding: 30px 0;\">"
                + "  <div style=\"max-width: 600px; margin: 0 auto; background-color: #ffffff; border-radius: 8px; overflow: hidden; border: 1px solid #e0e0e0;\">"
                + "    <div style=\"background-color: #134aa4; padding: 20px; text-align: center;\">"
                + "      <div style=\"color: #ffffff; font-family: Arial, sans-serif; font-size: 28px; font-weight: 800; letter-spacing: 2px; text-align: center;\">HEAVENSCAPE</div>"
                + "    </div>"
                + "    <div style=\"padding: 30px 40px;\">"
                + "      <h2 style=\"color: #D32F2F; font-size: 20px; margin-top: 0;\">Account Locked for a Policy Violation</h2>"
                + "      <p style=\"color: #555555; font-size: 15px; line-height: 1.6;\">"
                + "        Hello <strong>" + safeName + "</strong>,<br><br>"
                + "        Your HeavenScape account was <strong>locked</strong> for violating community guidelines "
                + "        (for example, inappropriate product review content). While it is locked, you cannot "
                + "        sign in or use the system."
                + "      </p>"
                + "      <div style=\"border-top: 1px solid #eeeeee; margin-top: 30px; padding-top: 20px;\">"
                + "        <p style=\"color: #888888; font-size: 13px; line-height: 1.5; margin: 0;\">"
                + "          If you believe this was a mistake, contact HeavenScape support to submit an appeal."
                + "        </p>"
                + "      </div>"
                + "    </div>"
                + "    <div style=\"background-color: #f9f9f9; padding: 20px; text-align: center; border-top: 1px solid #eeeeee;\">"
                + "      <p style=\"color: #999999; font-size: 13px; margin: 0;\">"
                + "        &copy; 2026 HeavenScape. All rights reserved."
                + "      </p>"
                + "    </div>"
                + "  </div>"
                + "</div>";
    }

}
