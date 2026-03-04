package com.ocean.view.resort.oceanviewresortapp.dao;

import com.ocean.view.resort.oceanviewresortapp.model.User;
import com.ocean.view.resort.oceanviewresortapp.model.UserStatus;
import com.ocean.view.resort.oceanviewresortapp.util.DBConnection;

import java.sql.*;

public class UserDAO {

    // Only allow login for Active users (user_status_id = 1)
    public User authenticate(String username, String password) {
        String sql = """
                SELECT u.*, us.id AS us_id, us.name AS us_name
                FROM users u
                JOIN user_statuses us ON u.user_status_id = us.id
                WHERE u.username = ? AND u.password = ? AND us.name = 'Active'
                """;
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, username);
            ps.setString(2, password);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                UserStatus us = new UserStatus();
                us.setId(rs.getInt("us_id"));
                us.setName(rs.getString("us_name"));

                User user = new User();
                user.setId(rs.getInt("id"));
                user.setUsername(rs.getString("username"));
                user.setUserStatus(us);
                return user;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
}
