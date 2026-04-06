import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.Statement;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.json.JSONArray;
import org.json.JSONObject;
import Util.DBUtil;
@WebServlet("/api/menu")
public class MenuServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("application/json");
        PrintWriter out = response.getWriter();
        JSONArray menuArray = new JSONArray();

        try (Connection conn = DBUtil.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery("SELECT * FROM products")) {

            while (rs.next()) {
                JSONObject menuItem = new JSONObject();
                menuItem.put("name", rs.getString("name"));
                menuItem.put("price", rs.getDouble("price"));
                menuItem.put("description", rs.getString("description"));
                menuItem.put("imagePath", rs.getString("image_path"));
                menuItem.put("category", rs.getString("category")); // Fetch category
                menuArray.put(menuItem);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        out.print(menuArray);
        out.flush();
    }
}
