package dao;

import model.Service;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ServiceDAO extends DAO {

    private static final String SEARCH_SERVICE_BY_NAME_SQL = 
        "SELECT * FROM tblService WHERE name LIKE ?";
    private static final String GET_SERVICE_BY_ID_SQL = 
        "SELECT * FROM tblService WHERE id = ?";

    public ServiceDAO() {
        super();
    }

    public Service[] searchServiceByName(String key) throws SQLException {
        List<Service> services = new ArrayList<>();
        try (Connection connection = getConnection();
             PreparedStatement stmt = connection.prepareStatement(SEARCH_SERVICE_BY_NAME_SQL)) {
            stmt.setString(1, "%" + key + "%");
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                Service service = new Service();
                service.setId(rs.getInt("id"));
                service.setName(rs.getString("name"));
                service.setPrice(rs.getFloat("price"));
                service.setDescription(rs.getString("description"));
                services.add(service);
            }
        }
        return services.toArray(new Service[0]);
    }

    public Service getServiceDetailsByID(int id) throws SQLException {
        Service service = null;
        try (Connection connection = getConnection();
             PreparedStatement stmt = connection.prepareStatement(GET_SERVICE_BY_ID_SQL)) {
            stmt.setInt(1, id);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                service = new Service();
                service.setId(rs.getInt("id"));
                service.setName(rs.getString("name"));
                service.setPrice(rs.getFloat("price"));
                service.setDescription(rs.getString("description"));
            }
        }
        return service;
    }
}

