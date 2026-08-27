/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package utils;

import java.sql.Connection;
import java.sql.DriverManager;

/**
 *
 * @author DUY MINH
 */
public class DBContext {
    public Connection getConnection() {
        try {
            Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
            String dbURL = "jdbc:sqlserver://localhost:1433;"
                    + "databaseName=HeavenScape_finalDB;"
                    + "user=vinhlee;"
                    + "password=123456;"
                    + "encrypt=true;trustServerCertificate=true;";
            return DriverManager.getConnection(dbURL);
        } catch (Exception e) {
            System.out.println("Unable to connect to the database: " + e.getMessage());
            return null;
        }
    }

    public static void main(String[] args) {
        DBContext db = new DBContext();
        Connection conn = db.getConnection();
        System.out.println(conn != null ? "Database connection successful" : "Database connection failed");
    }
}
