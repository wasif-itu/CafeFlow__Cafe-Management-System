package Servlet;

import bean.Order;
import Util.DBUtil;

import javax.servlet.ServletConfig;
import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.util.Enumeration;

/**
 * Servlet implementation for placing orders.
 * Demonstrates ServletConfig, ServletContext, session handling,
 * JavaBean binding, hidden fields, and RequestDispatcher.
 */
@WebServlet(name = "PlaceOrderServlet", urlPatterns = {"/PlaceOrderServlet"})
public class PlaceOrderServlet extends HttpServlet {
    private String orderTable;
    private ServletContext context;

    @Override
    public void init(ServletConfig config) throws ServletException {
        super.init(config);
        this.context = config.getServletContext();
        // read init parameter from web.xml for table name
        this.orderTable = config.getInitParameter("orderTable");
        if (this.orderTable == null || this.orderTable.isEmpty()) {
            this.orderTable = "orders";  // default
        }
        // assume a Connection or DataSource has been set in context attribute "DBConnection"
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        // ensure user logged in
        if (session == null || session.getAttribute("username") == null) {
            response.sendRedirect("src/veiws/login_new.jsp");
            return;
        }

        // Populate JavaBean
        Order order = new Order();
        order.setCustomerName(request.getParameter("customer_name"));
        order.setContact(request.getParameter("contact"));
        order.setAddress(request.getParameter("address"));
        order.setPaymentMethod(request.getParameter("payment_method"));
        order.setItems(request.getParameter("items"));
        order.setStatus("In Progress");

        // Debug or validation using getParameterNames
        Enumeration<String> params = request.getParameterNames();
        while (params.hasMoreElements()) {
            String param = params.nextElement();
            String value = request.getParameter(param);
            // e.g. log: context.log("Param " + param + " = " + value);
        }

        // Insert into database
        Connection conn = (Connection) getServletContext().getAttribute("DBConnection");
        String sql = "INSERT INTO " + orderTable + " " +
                "(customer_name, contact, address, payment_method, items, status) VALUES (?,?,?,?,?,?)";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, order.getCustomerName());
            stmt.setString(2, order.getContact());
            stmt.setString(3, order.getAddress());
            stmt.setString(4, order.getPaymentMethod());
            stmt.setString(5, order.getItems());
            stmt.setString(6, order.getStatus());

            int rows = stmt.executeUpdate();
            if (rows > 0) {
                request.setAttribute("successMessage", "✅ Order placed successfully!");
            } else {
                request.setAttribute("successMessage", "❌ Failed to place order.");
            }

        } catch (SQLException e) {
            context.log("Error executing order insert", e);
            request.setAttribute("successMessage", "❌ Error placing order: " + e.getMessage());
        }

        // Forward back to checkout page
        request.getRequestDispatcher("src/veiws/checkout_new.jsp").forward(request, response);
    }
}
