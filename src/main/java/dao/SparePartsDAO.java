package dao;

import model.SpareParts;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class SparePartsDAO extends DAO {

    private static final String SEARCH_SPAREPARTS_BY_NAME_SQL = 
        "SELECT * FROM tblSpareParts WHERE name LIKE ?";
    private static final String GET_SPAREPARTS_BY_ID_SQL = 
        "SELECT * FROM tblSpareParts WHERE id = ?";

    public SparePartsDAO() {
        super();
    }

    public SpareParts[] searchSparePartsByName(String key) throws SQLException {
        List<SpareParts> sparePartsList = new ArrayList<>();
        try (Connection connection = getConnection();
             PreparedStatement stmt = connection.prepareStatement(SEARCH_SPAREPARTS_BY_NAME_SQL)) {
            stmt.setString(1, "%" + key + "%");
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                SpareParts spareParts = new SpareParts();
                spareParts.setId(rs.getInt("id"));
                spareParts.setName(rs.getString("name"));
                spareParts.setPrice(rs.getFloat("price"));
                spareParts.setDescription(rs.getString("description"));
                spareParts.setStockQuantity(rs.getInt("stockQuantity"));
                sparePartsList.add(spareParts);
            }
        }
        return sparePartsList.toArray(new SpareParts[0]);
    }

    public SpareParts getSparePartsDetailsByID(int id) throws SQLException {
        SpareParts spareParts = null;
        try (Connection connection = getConnection();
             PreparedStatement stmt = connection.prepareStatement(GET_SPAREPARTS_BY_ID_SQL)) {
            stmt.setInt(1, id);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                spareParts = new SpareParts();
                spareParts.setId(rs.getInt("id"));
                spareParts.setName(rs.getString("name"));
                spareParts.setPrice(rs.getFloat("price"));
                spareParts.setDescription(rs.getString("description"));
                spareParts.setStockQuantity(rs.getInt("stockQuantity"));
            }
        }
        return spareParts;
    }
}

