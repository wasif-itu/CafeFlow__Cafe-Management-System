package Servlet;

import java.io.*;
import java.sql.*;
import javax.servlet.*;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.http.*;

import util.DatabaseConnector;
import javax.servlet.annotation.WebServlet;

@WebServlet("/ProductServlet")
@MultipartConfig(maxFileSize = 1024 * 1024 * 5) // 5MB max file size
public class ProductController extends HttpServlet {
    
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) 
            throws ServletException, IOException {
        
        String operation = req.getParameter("operation");
        Connection dbConnection = null;
        
        try {
            dbConnection = DatabaseConnector.createConnection();
            
            switch(operation) {
                case "Add":
                    addNewProduct(req, dbConnection);
                    break;
                    
                case "Update":
                    modifyProduct(req, dbConnection);
                    break;
                    
                case "Delete":
                    removeProduct(req, dbConnection);
                    break;
            }
            
            resp.sendRedirect(req.getContextPath() + "/src/veiws/admin_new.jsp");
            
        } catch (Exception ex) {
            ex.printStackTrace();
            resp.getWriter().println("⚠️ Operation failed: " + ex.getMessage());
        } finally {
            DatabaseConnector.closeConnection(dbConnection);
        }
    }
    
    private void addNewProduct(HttpServletRequest req, Connection conn) 
            throws SQLException, IOException, ServletException {
        
        String productName = req.getParameter("name");
        double productPrice = Double.parseDouble(req.getParameter("price"));
        String productDesc = req.getParameter("description");
        String productCategory = req.getParameter("category");
        
        Part imageFile = req.getPart("image");
        String imageLocation = storeUploadedImage(imageFile, req.getServletContext());
        
        String sql = "INSERT INTO products (name, price, description, image_path, category) " +
                     "VALUES (?, ?, ?, ?, ?)";
        
        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, productName);
            pstmt.setDouble(2, productPrice);
            pstmt.setString(3, productDesc);
            pstmt.setString(4, imageLocation);
            pstmt.setString(5, productCategory);
            
            pstmt.execute();
        }
    }
    
    private void modifyProduct(HttpServletRequest req, Connection conn) 
            throws SQLException, IOException, ServletException {
        
        int productId = Integer.parseInt(req.getParameter("id"));
        String productName = req.getParameter("name");
        double productPrice = Double.parseDouble(req.getParameter("price"));
        String productDesc = req.getParameter("description");
        String productCategory = req.getParameter("category");
        
        Part imageFile = req.getPart("image");
        String sql;
        
        if (imageFile.getSize() > 0) {
            String imageLocation = storeUploadedImage(imageFile, req.getServletContext());
            sql = "UPDATE products SET name=?, price=?, description=?, image_path=?, category=? " +
                  "WHERE id=?";
            
            try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
                pstmt.setString(1, productName);
                pstmt.setDouble(2, productPrice);
                pstmt.setString(3, productDesc);
                pstmt.setString(4, imageLocation);
                pstmt.setString(5, productCategory);
                pstmt.setInt(6, productId);
                
                pstmt.execute();
            }
        } else {
            sql = "UPDATE products SET name=?, price=?, description=?, category=? WHERE id=?";
            
            try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
                pstmt.setString(1, productName);
                pstmt.setDouble(2, productPrice);
                pstmt.setString(3, productDesc);
                pstmt.setString(4, productCategory);
                pstmt.setInt(5, productId);
                
                pstmt.execute();
            }
        }
    }
    
    private void removeProduct(HttpServletRequest req, Connection conn) 
            throws SQLException {
        
        int productId = Integer.parseInt(req.getParameter("id"));
        String sql = "DELETE FROM products WHERE id=?";
        
        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, productId);
            pstmt.execute();
        }
    }
    
    private String storeUploadedImage(Part imagePart, ServletContext context) 
            throws IOException {
        
        String fileName = System.currentTimeMillis() + "_" + 
                         imagePart.getSubmittedFileName();
        String storagePath = context.getRealPath("/") + "images/" + fileName;
        
        imagePart.write(storagePath);
        
        return "images/" + fileName;
    }
}