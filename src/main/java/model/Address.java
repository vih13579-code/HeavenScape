package model;

public class Address {

    private int addressID;
    private int customerID;
    private String street;
    private String district;
    private String city;
    private String country;
    private boolean isDefault;

    private String recipientName;
    private String recipientPhone;

    public Address() {
    }

    public Address(int addressID,
                   int customerID,
                   String street,
                   String district,
                   String city,
                   String country,
                   boolean isDefault) {
        this.addressID = addressID;
        this.customerID = customerID;
        this.street = street;
        this.district = district;
        this.city = city;
        this.country = country;
        this.isDefault = isDefault;
    }

    public Address(int addressID,
                   int customerID,
                   String street,
                   String district,
                   String city,
                   String country,
                   boolean isDefault,
                   String recipientName,
                   String recipientPhone) {
        this.addressID = addressID;
        this.customerID = customerID;
        this.street = street;
        this.district = district;
        this.city = city;
        this.country = country;
        this.isDefault = isDefault;
        this.recipientName = recipientName;
        this.recipientPhone = recipientPhone;
    }

    public int getAddressID() {
        return addressID;
    }

    public void setAddressID(int addressID) {
        this.addressID = addressID;
    }

    public int getCustomerID() {
        return customerID;
    }

    public void setCustomerID(int customerID) {
        this.customerID = customerID;
    }

    public String getStreet() {
        return street;
    }

    public void setStreet(String street) {
        this.street = street;
    }

    public String getDistrict() {
        return district;
    }

    public void setDistrict(String district) {
        this.district = district;
    }

    public String getCity() {
        return city;
    }

    public void setCity(String city) {
        this.city = city;
    }

    public String getCountry() {
        return country;
    }

    public void setCountry(String country) {
        this.country = country;
    }

    public boolean isDefault() {
        return isDefault;
    }

    public void setDefault(boolean isDefault) {
        this.isDefault = isDefault;
    }

    public String getRecipientName() {
        return recipientName;
    }

    public void setRecipientName(String recipientName) {
        this.recipientName = recipientName;
    }

    public String getRecipientPhone() {
        return recipientPhone;
    }

    public void setRecipientPhone(String recipientPhone) {
        this.recipientPhone = recipientPhone;
    }
}