package model;

import java.sql.Date;

public class Account {

    private int id;
    private String fullname;
    private String email;
    private String phone;
    private String role;
    private String status;

    public Account(int id, String fullname, String email,
            String phone, String role, String status) {
        this.id = id;
        this.fullname = fullname;
        this.email = email;
        this.phone = phone;
        this.role = role;
        this.status = status;
    }

    public int getId() {
        return id;
    }

    public String getFullname() {
        return fullname;
    }

    public String getEmail() {
        return email;
    }

    public String getPhone() {
        return phone;
    }

    public String getRole() {
        return role;
    }

    public String getStatus() {
        return status;
    }
}
