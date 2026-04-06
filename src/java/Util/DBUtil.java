package Util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBUtil {
    private static final String JDBC_DRIVER = "com.mysql.cj.jdbc.Driver";
    private static final String DB_URL = "jdbc:mysql://localhost:3306/cafe_ms";
    private static final String DB_USER = "root";
    private static final String DB_PASSWORD = "2693";

    private DatabaseConnector() {}

    public static Connection createConnection() throws SQLException, ClassNotFoundException {
        registerDriver();
        return DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);
    }


    private static void registerDriver() throws ClassNotFoundException {
        Class.forName(JDBC_DRIVER);
    }

    public static void closeConnection(Connection connection) {
        if (connection != null) {
            try {
                connection.close();
            } catch (SQLException e) {
                System.err.println("Error closing database connection: " + e.getMessage());
            }
        }
    }
}