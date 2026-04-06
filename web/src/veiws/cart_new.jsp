<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1" />
  <title>Your Cart - CafeFlow</title>
  <link rel="stylesheet" href="../css/style.css" />
  <link rel="stylesheet" href="../css/menu_css.css" />
  <style>
    .cart-container {
      padding: 2rem;
      max-width: 900px;
      margin: 0 auto;
      background: #fff;
      border-radius: 8px;
      box-shadow: 0 2px 8px rgba(0,0,0,0.1);
    }
    .cart-table {
      width: 100%;
      border-collapse: collapse;
      margin-bottom: 1.5rem;
    }
    .cart-table th,
    .cart-table td {
      padding: 0.75rem;
      text-align: left;
    }
    .cart-table th {
      border-bottom: 2px solid #eee;
    }
    .quantity-cell {
      display: flex;
      align-items: center;
    }
    .quantity-cell button {
      width: 32px;
      height: 32px;
      border: none;
      background: #f0f0f0;
      border-radius: 4px;
      cursor: pointer;
      margin: 0 8px;
      font-size: 1rem;
    }
    .quantity-cell span {
      min-width: 24px;
      text-align: center;
      display: inline-block;
    }
    .remove-btn {
      background: #dc3545;
      color: #fff;
      border: none;
      padding: 0.5rem 1rem;
      border-radius: 4px;
      cursor: pointer;
    }
    .checkout-container {
      text-align: right;
      margin-top: 1rem;
    }
    #checkout-btn {
      background: #28a745;
      color: #fff;
      border: none;
      padding: 0.75rem 1.5rem;
      border-radius: 4px;
      font-size: 1rem;
      cursor: pointer;
    }
  </style>
</head>
<body>
  <div class="container">
    <jsp:include page="../jsp/header.jsp" />

    <main class="cart-container">
      <h1>Your Cart</h1>
      <table class="cart-table">
        <thead>
          <tr>
            <th>Item</th>
            <th>Quantity</th>
            <th>Price</th>
            <th>Total</th>
            <th>Action</th>
          </tr>
        </thead>
        <tbody id="cart-body">
        </tbody>
      </table>
      <div class="cart-summary">
        <strong>Total:</strong> Rs. <span id="total-amount">0.00</span>
      </div>
      <div class="checkout-container">
        <button type="submit" id="checkout-btn">Proceed to Checkout</button>
      </div>
    </main>

  </div>
    <jsp:include page="../jsp/footer.jsp" />

  <script>
    document.addEventListener('DOMContentLoaded', () => {
      loadCart();
      document.getElementById('checkout-btn').addEventListener('click', handleCheckout);
    });

    function loadCart() {
      const cart = JSON.parse(localStorage.getItem('cart') || '[]');
      const body = document.getElementById('cart-body');
      const totalEl = document.getElementById('total-amount');
      body.innerHTML = '';
      let grandTotal = 0;

      if (cart.length === 0) {
        const tr = document.createElement('tr');
        const td = document.createElement('td');
        td.setAttribute('colspan', '5');
        td.textContent = 'Your cart is empty.';
        td.style.textAlign = 'center';
        tr.appendChild(td);
        body.appendChild(tr);
      } else {
        cart.forEach((item, idx) => {
          const tr = document.createElement('tr');
          const nameTd = document.createElement('td');
          nameTd.textContent = item.name;

          const qtyTd = document.createElement('td');
          qtyTd.className = 'quantity-cell';
          const btnDec = document.createElement('button'); btnDec.textContent = '-';
          const spanQty = document.createElement('span'); spanQty.textContent = item.quantity;
          const btnInc = document.createElement('button'); btnInc.textContent = '+';
          qtyTd.append(btnDec, spanQty, btnInc);

          const priceTd = document.createElement('td');
          priceTd.textContent = 'Rs. ' + item.price.toFixed(2);

          const totalTd = document.createElement('td');
          const lineTotal = item.price * item.quantity;
          totalTd.textContent = 'Rs. ' + lineTotal.toFixed(2);
          grandTotal += lineTotal;

          const actionTd = document.createElement('td');
          const removeBtn = document.createElement('button');
          removeBtn.className = 'remove-btn';
          removeBtn.textContent = 'Remove';
          actionTd.appendChild(removeBtn);

          btnInc.addEventListener('click', () => updateQuantity(idx, item.quantity + 1));
          btnDec.addEventListener('click', () => updateQuantity(idx, item.quantity - 1));
          removeBtn.addEventListener('click', () => removeItem(idx));

          tr.append(nameTd, qtyTd, priceTd, totalTd, actionTd);
          body.appendChild(tr);
        });
      }

      totalEl.textContent = grandTotal.toFixed(2);
    }

    function updateQuantity(index, newQty) {
      let cart = JSON.parse(localStorage.getItem('cart') || '[]');
      if (newQty < 1) return;
      cart[index].quantity = newQty;
      localStorage.setItem('cart', JSON.stringify(cart));
      loadCart();
    }

    function removeItem(index) {
      let cart = JSON.parse(localStorage.getItem('cart') || '[]');
      cart.splice(index, 1);
      localStorage.setItem('cart', JSON.stringify(cart));
      loadCart();
    }

    function handleCheckout() {
      const isLoggedIn = <%= session.getAttribute("username") != null %>;
      if (isLoggedIn) {
        window.location.href = 'checkout_new.jsp';
      } else {
        window.location.href = 'login_new.jsp';
      }
    }
  </script>
</body>
</html>
