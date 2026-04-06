package dao;

import model.Reservation;
import Util.DBUtil;

import java.sql.*;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

public class ReservationDAO {
    public void insert(Reservation reservation) {
        String sql = "INSERT INTO reservations (user_id, table_id, reservation_time) VALUES (?, ?, ?)";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, reservation.getUserId());
            stmt.setInt(2, reservation.getTableId());
            stmt.setTimestamp(3, Timestamp.valueOf(reservation.getReservationTime()));
            stmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public List<Reservation> findAll() {
        List<Reservation> reservations = new ArrayList<>();
        String sql = "SELECT id, user_id, table_id, reservation_time FROM reservations";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                Reservation reservation = new Reservation();
                reservation.setId(rs.getInt("id"));
                reservation.setUserId(rs.getInt("user_id"));
                reservation.setTableId(rs.getInt("table_id"));
                reservation.setReservationTime(rs.getTimestamp("reservation_time").toLocalDateTime());
                reservations.add(reservation);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return reservations;
    }

    public List<Reservation> findByDate(LocalDateTime date) {
        List<Reservation> reservations = new ArrayList<>();
        String sql = "SELECT id, user_id, table_id, reservation_time FROM reservations WHERE DATE(reservation_time) = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setDate(1, Date.valueOf(date.toLocalDate()));
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Reservation reservation = new Reservation();
                    reservation.setId(rs.getInt("id"));
                    reservation.setUserId(rs.getInt("user_id"));
                    reservation.setTableId(rs.getInt("table_id"));
                    reservation.setReservationTime(rs.getTimestamp("reservation_time").toLocalDateTime());
                    reservations.add(reservation);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return reservations;
    }
}
