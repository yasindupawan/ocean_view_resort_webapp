package com.ocean.view.resort.oceanviewresortapp.dao;

import com.ocean.view.resort.oceanviewresortapp.model.Reservation;
import com.ocean.view.resort.oceanviewresortapp.model.ReservationStatus;
import com.ocean.view.resort.oceanviewresortapp.model.RoomType;
import com.ocean.view.resort.oceanviewresortapp.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ReservationDAO {

    public boolean addReservation(Reservation r) {
        String sql = """
                INSERT INTO reservations
                    (reservation_number, guest_name, address, contact_number,
                     room_type_id, check_in_date, check_out_date, status_id)
                VALUES (?, ?, ?, ?,
                        (SELECT id FROM room_types WHERE name = ?),
                        ?, ?,
                        (SELECT id FROM reservation_statuses WHERE name = 'Active'))
                """;
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, r.getReservationNumber());
            ps.setString(2, r.getGuestName());
            ps.setString(3, r.getAddress());
            ps.setString(4, r.getContactNumber());
            ps.setString(5, r.getRoomType().getName());
            ps.setDate(6, Date.valueOf(r.getCheckInDate()));
            ps.setDate(7, Date.valueOf(r.getCheckOutDate()));
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public Reservation getReservation(String reservationNumber) {
        String sql = buildSelectQuery() + " WHERE r.reservation_number = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, reservationNumber);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return mapRow(rs);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }


    public List<Reservation> getAllReservations() {
        List<Reservation> list = new ArrayList<>();
        String sql = buildSelectQuery() + " ORDER BY r.created_at DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) list.add(mapRow(rs));
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public boolean updateReservation(Reservation r) {
        String sql = """
                UPDATE reservations
                SET guest_name     = ?,
                    address        = ?,
                    contact_number = ?,
                    room_type_id   = (SELECT id FROM room_types WHERE name = ?),
                    check_in_date  = ?,
                    check_out_date = ?
                WHERE reservation_number = ?
                  AND status_id = (SELECT id FROM reservation_statuses WHERE name = 'Active')
                """;
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, r.getGuestName());
            ps.setString(2, r.getAddress());
            ps.setString(3, r.getContactNumber());
            ps.setString(4, r.getRoomType().getName());
            ps.setDate(5, Date.valueOf(r.getCheckInDate()));
            ps.setDate(6, Date.valueOf(r.getCheckOutDate()));
            ps.setString(7, r.getReservationNumber());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean cancelReservation(String reservationNumber) {
        String sql = """
                UPDATE reservations
                SET status_id = (SELECT id FROM reservation_statuses WHERE name = 'Cancelled')
                WHERE reservation_number = ?
                  AND status_id = (SELECT id FROM reservation_statuses WHERE name = 'Active')
                """;
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, reservationNumber);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public int getTotalReservations() {
        return countQuery("SELECT COUNT(*) FROM reservations");
    }

    public int getActiveReservations() {
        return countQuery("""
                SELECT COUNT(*) FROM reservations
                WHERE status_id = (SELECT id FROM reservation_statuses WHERE name = 'Active')
                """);
    }

    public int getCancelledReservations() {
        return countQuery("""
                SELECT COUNT(*) FROM reservations
                WHERE status_id = (SELECT id FROM reservation_statuses WHERE name = 'Cancelled')
                """);
    }

    public int getTodayCheckIns() {
        return countQuery("""
                SELECT COUNT(*) FROM reservations
                WHERE check_in_date = CURDATE()
                  AND status_id = (SELECT id FROM reservation_statuses WHERE name = 'Active')
                """);
    }

    public int getTodayCheckOuts() {
        return countQuery("""
                SELECT COUNT(*) FROM reservations
                WHERE check_out_date = CURDATE()
                  AND status_id = (SELECT id FROM reservation_statuses WHERE name = 'Active')
                """);
    }

    public List<Reservation> getRecentReservations(int limit) {
        List<Reservation> list = new ArrayList<>();
        String sql = buildSelectQuery() + " ORDER BY r.created_at DESC LIMIT ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, limit);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) list.add(mapRow(rs));
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public boolean reservationExists(String reservationNumber) {
        String sql = "SELECT 1 FROM reservations WHERE reservation_number = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, reservationNumber);
            return ps.executeQuery().next();
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    private int countQuery(String sql) {
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    // Reusable SELECT with all JOINs
    private String buildSelectQuery() {
        return """
                SELECT
                    r.reservation_number,
                    r.guest_name,
                    r.address,
                    r.contact_number,
                    r.check_in_date,
                    r.check_out_date,
                    r.created_at,
                    rt.id   AS rt_id,
                    rt.name AS rt_name,
                    rt.rate AS rt_rate,
                    rt.description AS rt_desc,
                    rs.id   AS rs_id,
                    rs.name AS rs_name
                FROM reservations r
                JOIN room_types rt           ON r.room_type_id = rt.id
                JOIN reservation_statuses rs ON r.status_id    = rs.id
                """;
    }

    private Reservation mapRow(ResultSet rs) throws SQLException {
        RoomType rt = new RoomType();
        rt.setId(rs.getInt("rt_id"));
        rt.setName(rs.getString("rt_name"));
        rt.setRate(rs.getDouble("rt_rate"));
        rt.setDescription(rs.getString("rt_desc"));

        ReservationStatus status = new ReservationStatus();
        status.setId(rs.getInt("rs_id"));
        status.setName(rs.getString("rs_name"));

        Reservation r = new Reservation();
        r.setReservationNumber(rs.getString("reservation_number"));
        r.setGuestName(rs.getString("guest_name"));
        r.setAddress(rs.getString("address"));
        r.setContactNumber(rs.getString("contact_number"));
        r.setCheckInDate(rs.getDate("check_in_date").toLocalDate());
        r.setCheckOutDate(rs.getDate("check_out_date").toLocalDate());
        r.setRoomType(rt);
        r.setStatus(status);
        return r;
    }
}