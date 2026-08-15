package dao;

import java.sql.*;
import java.util.*;
import model.Address;
import utils.DBContext;

public class AddressDAO {

    DBContext db = new DBContext();

    public List<Address> getAllAddresses() {
        // TODO: implement
        return new ArrayList<Address>();
    }

    public List<Address> getAddressesByCustomerId(int customerID) {
        // TODO: implement
        return new ArrayList<Address>();
    }

    public Address getAddressById(int id) {
        // TODO: implement
        return null;
    }

    public Address getAddressByIdAndCustomer(int addressID, int customerID) {
        // TODO: implement
        return null;
    }

    public void insertAddress(Address a) {
        // TODO: implement
    }

    public int insertAddressAndReturnId(Address a) {
        // TODO: implement
        return 0;
    }

    public boolean updateAddressByCustomer(int addressID, int customerID, String street, String district, String city) {
        // TODO: implement
        return false;
    }

    public boolean deleteAddressByCustomer(int addressID, int customerID) {
        // TODO: implement
        return false;
    }

    public void setDefaultAddress(int addressID, int customerID) {
        // TODO: implement
    }

    private void resetDefault(Connection conn, int customerID) throws SQLException {
        // TODO: implement
    }

    private void setNewestAddressDefault(Connection conn, int customerID) throws SQLException {
        // TODO: implement
    }

    private Address mapAddress(ResultSet rs) throws SQLException {
        // TODO: implement
        return null;
    }

    private String emptyToNull(String value) {
        // TODO: implement
        return null;
    }
}