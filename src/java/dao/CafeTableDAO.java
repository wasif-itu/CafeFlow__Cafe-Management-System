package dao;

import model.CafeTable;
import Util.DBUtil;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class CafeTableDAO {
    public List<CafeTable> findAll() {
        List<CafeTable> tables = new ArrayList<>();
        String sql = "SELECT id, capacity, is_available FROM cafe_tables";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                CafeTable table = new CafeTable();
                table.setId(rs.getInt("id"));
                table.setCapacity(rs.getInt("capacity"));
                table.setAvailable(rs.getBoolean("is_available"));
                tables.add(table);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return tables;
    }
}
