<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1" />
  <title>Checkout - CafeFlow</title>
  <link rel="stylesheet" href="../css/style.css" />
    <link rel="stylesheet" href="src/css/style.css" />

  <link rel="stylesheet" href="../css/menu_css.css" />
    <link rel="stylesheet" href="src/css/menu_css.css" />

  <style>
    .checkout-container {
      padding: 2rem;
      max-width: 600px;
      margin: 2rem auto;
      background: #fff;
      border-radius: 8px;
      box-shadow: 0 2px 8px rgba(0,0,0,0.1);
    }
    .checkout-container h1 {
      margin-bottom: 1.5rem;
    }
    .checkout-form label {
      display: block;
      margin: 0.75rem 0 0.25rem;
      font-weight: 500;
    }
    .checkout-form input,
    .checkout-form textarea,
    .checkout-form select {
      width: 100%;
      padding: 0.5rem;
      border: 1px solid #ccc;
      border-radius: 4px;
      font-size: 1rem;
    }
    .checkout-form button {
      background: #28a745;
      color: #fff;
      border: none;
      padding: 0.75rem 1.5rem;
      border-radius: 4px;
      font-size: 1rem;
      cursor: pointer;
      margin-top: 1rem;
    }
    .alert-success {
      padding: 1rem;
      margin-bottom: 1rem;
      border: 1px solid #c3e6cb;
      background-color: #d4edda;
      color: #155724;
      border-radius: 4px;
    }
  </style>
</head>
<body>
  <div class="container">
    <jsp:include page="../jsp/header.jsp" />
    <main class="checkout-container">
      <h1>Checkout</h1>
      <!-- Success/Error Alert -->
      <c:if test="${not empty successMessage}">
        <div class="alert-success">
          ${successMessage}
        </div>
      </c:if>
      <form class="checkout-form" action="${pageContext.request.contextPath}/PlaceOrderServlet" method="post" onsubmit="populateItems()">
        <label for="customer_name">Username</label>
        <input type="text" id="customer_name" name="customer_name"
               value="${sessionScope.username}" readonly />

        <label for="contact">Contact Number</label>
        <input type="tel" id="contact" name="contact" placeholder="123-456-7890" required />

        <label for="address">Shipping Address</label>
        <textarea id="address" name="address" rows="3" placeholder="123 Main St, City" required></textarea>

        <label for="payment_method">Payment Method</label>
        <select id="payment_method" name="payment_method" required>
          <option value="">Select</option>
          <option value="card">Credit/Debit Card</option>
          <option value="cod">Cash on Delivery</option>
        </select>

        <!-- Hidden field for cart items -->
        <input type="hidden" id="items" name="items" />

        <button type="submit">Place Order</button>
      </form>
    </main>
  </div>
    <jsp:include page="../jsp/footer.jsp" />

  <script>
    function populateItems() {
      const cart = JSON.parse(localStorage.getItem('cart') || '[]');
      document.getElementById('items').value = cart
        .map(i => i.name + ' x' + i.quantity)
        .join(', ');
    }
  </script>
</body>
</html>
