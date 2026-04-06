package api;

import Util.DBUtil;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.*;
import org.json.JSONObject;

@WebServlet("/api/orders/*")
public class OrderDetailsServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // 1) Extract ID from path: e.g. /api/orders/23 → "23"
        String pathInfo = request.getPathInfo();             
        if (pathInfo == null || pathInfo.equals("/")) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Order ID missing");
            return;
        }
        String idStr = pathInfo.substring(1);  // drops leading “/”
        int orderId;
        try {
            orderId = Integer.parseInt(idStr);
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid order ID");
            return;
        }

        // 2) Query the DB
        String sql = "SELECT * FROM orders WHERE id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, orderId);
            try (ResultSet rs = ps.executeQuery()) {
                if (!rs.next()) {
                    response.sendError(HttpServletResponse.SC_NOT_FOUND, "Order not found");
                    return;
                }

                // 3) Build JSON from all columns
                ResultSetMetaData md = rs.getMetaData();
                int cols = md.getColumnCount();
                JSONObject json = new JSONObject();
                for (int i = 1; i <= cols; i++) {
                    String colName = md.getColumnLabel(i);
                    Object  val     = rs.getObject(i);
                    json.put(colName, val);
                }

                // 4) Return JSON
                response.setContentType("application/json");
                response.setCharacterEncoding("UTF-8");
                try (PrintWriter out = response.getWriter()) {
                    out.print(json.toString());
                }
            }

        } catch (SQLException e) {
            throw new ServletException("Database error fetching order " + orderId, e);
        }
    }
}
