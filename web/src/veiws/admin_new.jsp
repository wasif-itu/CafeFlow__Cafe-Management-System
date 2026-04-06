<%@ page import="java.sql.*, Util.DBUtil" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1" />
  <title>CafeFlow Admin Dashboard</title>
  <link rel="stylesheet" href="../css/menu_css.css">
  <link rel="stylesheet" href="../css/style.css">
      <jsp:include page="../jsp/header.jsp" />

  <style>
    body {
      font-family: Arial, sans-serif;
      background-color: #f5f5f5;
      margin: 0;
      display: flex;
    }
    .sidebar {
      width: 220px;
      background: white;
      color: #4A1F8D;
      height: 100vh;
      display: flex;
      flex-direction: column;
    }
    .sidebar h2 {
      text-align: center;
      padding: 20px 0;
      margin: 0;
      background: white;
      color: #4A1F8D;
    }
    .sidebar button {
      background: transparent;
      border: none;
      color: #4A1F8D;
      padding: 15px 20px;
      text-align: left;
      width: 100%;
      cursor: pointer;
      font-size: 16px;
    }
    .sidebar button.active, .sidebar button:hover {
      background: #e9e0f8;
      color: #4A1F8D;
    }
    .main {
      flex: 1;
      padding: 20px;
      background: #f5f5f5;
      height: 100vh;
      overflow-y: auto;
    }
    .main h1 {
      text-align: center;
      margin-bottom: 40px;
      color: #4A1F8D;
      font-size: 2.5em;
    }
    table.admin-table {
      width: 100%;
      border-collapse: separate;
      border-spacing: 0;
      border-radius: 8px;
      overflow: hidden;
      box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
    }
    table.admin-table th, table.admin-table td {
      padding: 12px 15px;
    }
    table.admin-table thead {
      background: #4A1F8D;
      color: #fff;
    }
    table.admin-table tbody tr {
      background: #fff;
    }
    table.admin-table tbody tr:nth-child(even) {
      background: #e9ecef;
    }
    table.admin-table tbody tr:hover {
      background: #dedede;
    }
    /* Add/update button styles */
    table.admin-table input[type="submit"],
    .admin-form input[type="submit"] {
      background-color: #4A1F8D;
      color: white;
      padding: 10px 15px;
      border: none;
      margin: 5px;
      border-radius: 5px;
      cursor: pointer;
      transition: background-color 0.3s;
    }
    table.admin-table input[type="submit"]:hover,
    .admin-form input[type="submit"]:hover {
      background-color: #65358D;
    }
    .admin-form {
      background: white;
      padding: 20px;
      border-radius: 8px;
      box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
      margin-bottom: 30px;
      max-width: 600px;
    }
    .admin-form h2 {
      margin-top: 0;
      color: #4A1F8D;
    }
    .admin-form .form-group {
      margin-bottom: 15px;
    }
    .admin-form label {
      display: block;
      margin-bottom: 5px;
      font-weight: bold;
    }
    .admin-form input[type="text"],
    .admin-form input[type="file"],
    .admin-form select {
      width: 100%;
      padding: 8px;
      border: 1px solid #ced4da;
      border-radius: 4px;
    }
    .item-list {
      list-style: none;
      padding: 0;
      margin: 0;
    }
    .item-list li {
      background: #4A1F8D;
      color: #fff;
      display: inline-block;
      padding: 4px 8px;
      border-radius: 4px;
      margin: 2px;
      font-size: 14px;
    }
    .admin-table img {
      border-radius: 4px;
    }

    /* ——— Modal styles ——— */
    .modal-overlay {
      position: fixed;
      top: 0; left: 0;
      width: 100%; height: 100%;
      background: rgba(0,0,0,0.5);
      display: none;            /* hidden by default */
      align-items: center;
      justify-content: center;
      z-index: 1000;
    }
    .modal-window {
      background: #fff;
      padding: 20px;
      border-radius: 8px;
      max-width: 400px;
      width: 90%;
      box-shadow: 0 2px 10px rgba(0,0,0,0.3);
      position: relative;
    }
    .modal-close {
      position: absolute;
      top: 8px; right: 8px;
      background: transparent;
      border: none;
      font-size: 1.5em;
      cursor: pointer;
    }
#modal-details-list {
  padding-left: 20px;
  margin-top: 10px;
}
#modal-details-list li {
  margin-bottom: 8px;
  font-size: 0.95em;
  color: #333;
  background: transparent;
}

  </style>
</head>
<body>
  <nav class="sidebar">
    <h2>Dashboard</h2>
    <button id="tab-orders" class="active">Manage Orders</button>
    <button id="tab-menu">Update Menu</button>
  </nav>

  <div class="main">
    <div id="orders-section">
      <h1>🛒 Manage Orders</h1>
      <table class="admin-table">
        <thead>
          <tr>
            <th>Order ID</th>
            <th>Customer</th>
            <th>Items</th>
            <th>Status</th>
            <th>Change Status</th>
            <th>Details</th>  <!-- new header -->
          </tr>
        </thead>
        <tbody>
        <% try (Connection conn = DBUtil.getConnection();
                Statement stmt = conn.createStatement();
                ResultSet rs = stmt.executeQuery("SELECT * FROM orders")) {
             while (rs.next()) {
               int orderId = rs.getInt("id");
               String customer = rs.getString("customer_name");
               String items = rs.getString("items");
               String status = rs.getString("status");
        %>
          <tr>
            <td><%= orderId %></td>
            <td><%= customer %></td>
            <td>
              <ul class="item-list">
                <% for (String it : items.split(",")) { %>
                  <li><%= it.trim() %></li>
                <% } %>
              </ul>
            </td>
            <td><%= status %></td>
            <td>
              <form action="<%=request.getContextPath()%>/UpdateOrderStatusServlet" method="post">
                <input type="hidden" name="order_id" value="<%= orderId %>" />
                <select name="new_status" required>
                  <option value="Pending" <%= "Pending".equalsIgnoreCase(status)?"selected":"" %>>Pending</option>
                  <option value="In Progress" <%= "In Progress".equalsIgnoreCase(status)?"selected":"" %>>In Progress</option>
                  <option value="Delivered" <%= "Delivered".equalsIgnoreCase(status)?"selected":"" %>>Delivered</option>
                  <option value="Cancelled" <%= "Cancelled".equalsIgnoreCase(status)?"selected":"" %>>Cancelled</option>
                </select>
                <input type="submit" value="Update" />
              </form>
            </td>
            <td>
              <button
                class="view-details-btn"
                data-order-id="<%= orderId %>">
                View Details
              </button>
            </td>
          </tr>
        <% } } catch (Exception e) {
             out.println("❌ Error: " + e.getMessage());
           } %>
        </tbody>
      </table>
    </div>

    <div id="menu-section" style="display:none;">
      <h1>🍽️ Update Menu</h1>
      <div class="admin-form">
        <h2>Add New Product</h2>
        <form action="<%=request.getContextPath()%>/ProductServlet" method="post" enctype="multipart/form-data">
          <input type="hidden" name="action" value="Add" />
          <div class="form-group">
            <label>Name:</label>
            <input type="text" name="name" required />
          </div>
          <div class="form-group">
            <label>Price:</label>
            <input type="text" name="price" required />
          </div>
          <div class="form-group">
            <label>Description:</label>
            <input type="text" name="description" required />
          </div>
          <div class="form-group">
            <label>Category:</label>
            <input type="text" name="category" required />
          </div>
          <div class="form-group">
            <label>Image:</label>
            <input type="file" name="image" accept="image/*" required />
          </div>
          <input type="submit" value="Add Product" />
        </form>
      </div>
      <table class="admin-table">
       <thead>
          <tr>
            <th>ID</th>
            <th>Name</th>
            <th>Price</th>
            <th>Description</th>
            <th>Image</th>
            <th>Actions</th>
          </tr>
        </thead>
        <tbody>
        <% try (Connection conn = DBUtil.getConnection(); Statement stmt = conn.createStatement(); ResultSet rs = stmt.executeQuery("SELECT * FROM products")) {
             while (rs.next()) {
               int id = rs.getInt("id");
               String name = rs.getString("name");
               double price = rs.getDouble("price");
               String description = rs.getString("description");
               String imagePath = rs.getString("image_path");
               String category = rs.getString("category");
        %>
          <tr>
            <form action="<%=request.getContextPath()%>/ProductServlet" method="post" enctype="multipart/form-data">
  <td><%= id %></td>
  <td><input type="text" name="name" value="<%= name %>" /></td>
  <td><input type="text" name="price" value="<%= price %>" /></td>  
  <td><input type="text" name="category" value="<%= category %>" /></td>

  <td><input type="text" name="description" value="<%= description %>" /></td>
  <td>
    <img src="<%= imagePath %>" width="60" height="60" alt="Product Image" /><br/>
    <input type="file" name="image" />
  </td>
  <td>
    <input type="hidden" name="id" value="<%= id %>" />
    <input type="submit" name="action" value="Update" />
    <input type="submit" name="action" value="Delete" onclick="return confirm('Are you sure?');" />
  </td>
</form>

          </tr>
        <% } } catch (Exception e) { out.println("❌ Error: " + e.getMessage()); } %>
        </tbody>
      </table>
    </div>
  </div>

  <div id="order-modal" class="modal-overlay">
    <div class="modal-window">
      <button class="modal-close">&times;</button>
      <h2>Order #<span id="modal-order-id"></span> Details</h2>
      <ul id="modal-details-list"></ul>
    </div>
  </div>

  <script>
    document.getElementById('tab-orders').addEventListener('click', () => {
      document.getElementById('orders-section').style.display = '';
      document.getElementById('menu-section').style.display = 'none';
      document.getElementById('tab-orders').classList.add('active');
      document.getElementById('tab-menu').classList.remove('active');
    });
    document.getElementById('tab-menu').addEventListener('click', () => {
      document.getElementById('menu-section').style.display = '';
      document.getElementById('orders-section').style.display = 'none';
      document.getElementById('tab-menu').classList.add('active');
      document.getElementById('tab-orders').classList.remove('active');
    });
function openOrderModal(order) {
  console.log("🔥 RAW ORDER:", order);
  const orderData = JSON.parse(JSON.stringify(order || {}));

  const modal = document.getElementById('order-modal');
  if (!modal) return console.error("❌ No #order-modal on page");

  const orderIdSpan = modal.querySelector('#modal-order-id');
  const detailsList = modal.querySelector('#modal-details-list');
  if (!orderIdSpan || !detailsList) {
    return console.error("❌ Missing #modal-order-id or #modal-details-list");
  }

  orderIdSpan.textContent = orderData.id ?? 'N/A';
  detailsList.innerHTML = '';


  const properties = [
    { key: 'customer_name',  label: 'Customer Name'   },
    { key: 'address',        label: 'Address'         },
    { key: 'contact',        label: 'Contact'         },
    { key: 'items',          label: 'Items'           },
    { key: 'order_date',     label: 'Order Date'      },
    { key: 'payment_method', label: 'Payment Method'  },
    { key: 'status',         label: 'Status'          }
  ];

 properties.forEach(prop => {
  const raw = orderData[prop.key];
  console.log("🔍", prop.label, "→", raw);

  const li = document.createElement('li');
  li.textContent = prop.label + ': ' + (raw ?? 'N/A');

  console.log("ℹ️ Appending LI:", li.outerHTML);

  detailsList.appendChild(li);
});

  modal.style.display = 'flex';
  console.log("✅ Modal displayed");
}

document.querySelectorAll('.view-details-btn').forEach(btn => {
  btn.addEventListener('click', () => {
    const orderId = btn.dataset.orderId;
    const url = '<%= request.getContextPath() %>/api/orders/' + orderId;

    console.log("🔍 Fetching order details for Order ID:", orderId);

    fetch(url)
      .then(r => {
        if (!r.ok) {
          console.error("⚠️ Fetch error:", r.status);
          return Promise.reject(r.status);
        }
        return r.json();
      })
      .then(json => {
        console.log('🔍 order JSON fetched:', json);
        openOrderModal(json); // Pass the JSON object directly
      })
      .catch(e => {
        console.error("⚠️ Could not load order details:", e);
        alert('⚠️ Could not load order details: ' + e);
      });
  });
});
    document.querySelector('#order-modal .modal-close')
      .addEventListener('click', () => {
        document.getElementById('order-modal').style.display = 'none';
      });
    document.getElementById('order-modal')
      .addEventListener('click', e => {
        if (e.target.id === 'order-modal') {
          e.currentTarget.style.display = 'none';
        }
      });
  </script>
</body>
</html>
