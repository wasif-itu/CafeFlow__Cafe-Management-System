package Servlet;

import model.User;
import Util.DBUtil;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.sql.*;
import java.util.Formatter;

@WebServlet(name = "RegisterServlet", urlPatterns = {"/RegisterServlet"})
public class RegisterServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        // 1. Get populated bean from JSP
        User user = (User) req.getAttribute("user");

        if (user == null) {
            // fallback in case bean is not set
            user = new User();
            user.setUsername(req.getParameter("username"));
            user.setEmail(req.getParameter("email"));
            user.setPasswordHash(req.getParameter("passwordHash"));
        }

        // 2. Hash the password
        String hash = sha256(user.getPasswordHash());
        user.setPasswordHash(hash);
        user.setRole("user");

        // 3. Insert into DB
        String sql = "INSERT INTO users (username, password, email, role) VALUES (?, ?, ?, ?)";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, user.getUsername());
            ps.setString(2, user.getPasswordHash());
            ps.setString(3, user.getEmail());
            ps.setString(4, user.getRole());

            int rows = ps.executeUpdate();
            if (rows > 0) {
                resp.sendRedirect("src/veiws/login_new.jsp?registered=1");
            } else {
                resp.sendRedirect("src/veiws/login_new.jsp?error=1");
            }
        } catch (SQLException e) {
            e.printStackTrace();
            resp.sendRedirect("src/veiws/login_new.jsp?error=1");
        }
    }

    private String sha256(String input) throws IOException {
        try {
            MessageDigest md = MessageDigest.getInstance("SHA-256");
            byte[] digest = md.digest(input.getBytes(StandardCharsets.UTF_8));
            try (Formatter fmt = new Formatter()) {
                for (byte b : digest) {
                    fmt.format("%02x", b);
                }
                return fmt.toString();
            }
        } catch (Exception e) {
            throw new IOException("Hashing error", e);
        }
    }
}
