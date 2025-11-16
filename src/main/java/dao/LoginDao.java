package dao;

import model.User;
import java.sql.*;
import java.util.Date;

public class LoginDao {
    private String jdbcURL = "jdbc:mysql://localhost:3306/userdb";
    private String jdbcUsername = "root";
    private String jdbcPassword = "1234"; // Thay bằng mật khẩu MySQL của bạn

    private static final String INSERT_USER_SQL = "INSERT INTO tblUser (username, email, password, fullName, role) VALUES (?, ?, ?, ?, ?)";
    private static final String SELECT_USER_SQL = "SELECT * FROM tblUser WHERE (email = ? OR username = ?) AND password = ?";

    protected Connection getConnection() throws SQLException {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
        }
        return DriverManager.getConnection(jdbcURL, jdbcUsername, jdbcPassword);
    }

    public boolean registerUser(User user) throws SQLException {
        try (Connection connection = getConnection();
             PreparedStatement stmt = connection.prepareStatement(INSERT_USER_SQL)) {
            stmt.setString(1, user.getEmail().split("@")[0]); // Use email prefix as username
            stmt.setString(2, user.getEmail());
            stmt.setString(3, user.getPassword());
            stmt.setString(4, user.getFullName());
            stmt.setString(5, "customer"); // Default role
            return stmt.executeUpdate() > 0;
        }
    }

    public User validateUser(String email, String password) throws SQLException {
        try (Connection connection = getConnection();
             PreparedStatement stmt = connection.prepareStatement(SELECT_USER_SQL)) {
            stmt.setString(1, email);
            stmt.setString(2, email); // Also check username
            stmt.setString(3, password);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                User user = new User();
                user.setId(rs.getInt("id"));
                user.setUsername(rs.getString("username"));
                user.setPassword(password);
                user.setFullName(rs.getString("fullName"));
                Date dateOfBirth = rs.getDate("dateOfBirth");
                if (dateOfBirth != null) {
                    user.setDateOfBirth(new Date(dateOfBirth.getTime()));
                }
                user.setAddress(rs.getString("address"));
                user.setEmail(rs.getString("email"));
                user.setPhoneNumber(rs.getString("phoneNumber"));
                user.setRole(rs.getString("role"));
                return user;
            }
        }
        return null;
    }
}
