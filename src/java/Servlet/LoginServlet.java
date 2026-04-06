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

@WebServlet(name = "LoginServlet", urlPatterns = {"/LoginServlet"})
public class LoginServlet extends HttpServlet {

    @Override
protected void doPost(HttpServletRequest req, HttpServletResponse resp)
        throws ServletException, IOException {

    String username = req.getParameter("username");
    String plain = req.getParameter("password");
    String remember = req.getParameter("rememberMe"); // checkbox value

    if (username == null || plain == null || username.trim().isEmpty() || plain.isEmpty()) {
        fail(req, resp, "Missing username or password.");
        return;
    }

    username = username.trim();

    User user = getUserByUsername(username);
    if (user == null) {
        fail(req, resp, "Invalid username or password.");
        return;
    }

    String submittedHash = sha256(plain);
    if (!submittedHash.equals(user.getPasswordHash())) {
        fail(req, resp, "Invalid username or password.");
        return;
    }

    // Set session
    HttpSession session = req.getSession();
    session.setAttribute("userid", user.getId());
    session.setAttribute("username", user.getUsername());
    session.setAttribute("role", user.getRole());

    // If "remember me" is checked → set cookies
    if ("on".equals(remember)) {
        Cookie userCookie = new Cookie("username", username);
        Cookie passCookie = new Cookie("password", plain); // Note: not secure. Use a token in real systems

        userCookie.setMaxAge(7 * 24 * 60 * 60); // 7 days
        passCookie.setMaxAge(7 * 24 * 60 * 60); // 7 days

        resp.addCookie(userCookie);
        resp.addCookie(passCookie);
    }

    // Redirect by role
    if ("admin".equals(user.getRole())) {
        resp.sendRedirect(req.getContextPath() + "/src/veiws/admin_new.jsp");
    } else {
        resp.sendRedirect(req.getContextPath() + "/src/veiws/landing.jsp");
    }
}


    private void fail(HttpServletRequest req, HttpServletResponse resp, String msg)
            throws ServletException, IOException {
        req.setAttribute("error", msg);
        req.getRequestDispatcher("src/veiws/login_new.jsp").forward(req, resp);
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
            throw new IOException("Hash error", e);
        }
    }

    private User getUserByUsername(String username) {
        User u = null;
        String sql = "SELECT id, username, password AS pwd, role FROM users WHERE username = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, username);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    u = new User();
                    u.setId(rs.getInt("id"));
                    u.setUsername(rs.getString("username"));
                    u.setPasswordHash(rs.getString("pwd"));
                    u.setRole(rs.getString("role"));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return u;
    }
}
