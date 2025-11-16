package model;

import java.util.Date;

public class Customer {
    private int id;
    private String fullName;
    private String address;
    private String phoneNumber;
    private int userId; // Reference to tblUser.id

    public Customer() {}

    public Customer(String fullName, String address, String phoneNumber, int userId) {
        this.fullName = fullName;
        this.address = address;
        this.phoneNumber = phoneNumber;
        this.userId = userId;
    }

    // Getters & Setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getFullName() { return fullName; }
    public void setFullName(String fullName) { this.fullName = fullName; }

    public String getAddress() { return address; }
    public void setAddress(String address) { this.address = address; }

    public String getPhoneNumber() { return phoneNumber; }
    public void setPhoneNumber(String phoneNumber) { this.phoneNumber = phoneNumber; }

    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }
}

