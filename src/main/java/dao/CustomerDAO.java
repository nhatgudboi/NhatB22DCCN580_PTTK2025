package dao;

import model.Customer;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class CustomerDAO extends DAO {

    private static final String SELECT_CUSTOMER_BY_NAME_SQL = 
        "SELECT * FROM tblCustomer WHERE fullName LIKE ?";

    public CustomerDAO() {
        super();
    }

    public Customer[] selectCustomerByName(String name) throws SQLException {
        List<Customer> customers = new ArrayList<>();
        try (Connection connection = getConnection();
             PreparedStatement stmt = connection.prepareStatement(SELECT_CUSTOMER_BY_NAME_SQL)) {
            stmt.setString(1, "%" + name + "%");
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                Customer customer = new Customer();
                customer.setId(rs.getInt("id"));
                customer.setFullName(rs.getString("fullName"));
                customer.setAddress(rs.getString("address"));
                customer.setPhoneNumber(rs.getString("phoneNumber"));
                customer.setUserId(rs.getInt("userId"));
                customers.add(customer);
            }
        }
        return customers.toArray(new Customer[0]);
    }
}

