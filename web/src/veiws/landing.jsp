<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page session="true" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1" />
  <title>CafeFlow</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/src/css/style.css" />
</head>
<body>
  <div class="container">

    <jsp:include page="../jsp/header.jsp" /> <!-- Include the header -->

    <main>
      <div class="hero">
        <div class="hero-content">
          <h1>Relax. Sip. Repeat.</h1>
          <p>Freshly brewed coffee, warm ambience & delicious food.</p>
        </div>
      </div>

      <!-- Top welcome bar styled as a section -->
      <div class="section">
        <div class="welcome-message">
          <%
            String username = (String) session.getAttribute("username");
            if (username != null) {
          %>
            <p>Welcome, <strong><%= username %></strong>!</p>
            <form action="${pageContext.request.contextPath}/LogoutServlet" method="post">
                 <button type="submit" class="button">Log Out</button>
            </form>
          <%
            } else {
          %>
            <p>Welcome! Please <a href="${pageContext.request.contextPath}/src/veiws/login_new.jsp" class="button">Login</a></p>
          <%
            }
          %>
        </div>
      </div>

      <div class="section">
        <h2>Why CafeFlow?</h2>
        <p>
          CafeFlow is more than just a café — it's a modern way to dine. Whether you're looking to book a table for a quiet conversation or order your favorite items for pickup or delivery, CafeFlow offers you a smooth and interactive experience from your screen to our counter.
        </p>

        <div style="text-align: center;">
          <a href="${pageContext.request.contextPath}/src/veiws/menu_new.jsp" class="button">View Menu</a>
          <a href="${pageContext.request.contextPath}/src/veiws/cart_new.jsp" class="button">Order Now</a>
          <a href="reservation.jsp" class="button">Book Table</a>
        </div>
      </div>

      <div class="section">
        <h2>Our Specialties</h2>
        <div class="cards">
          <div class="card"><span class="icon">☕</span>Handcrafted Coffees &amp; Teas</div>
          <div class="card"><span class="icon">🥐</span>Freshly Baked Pastries &amp; Sandwiches</div>
          <div class="card"><span class="icon">🍝</span>Chef's Signature Dishes</div>
          <div class="card"><span class="icon">📦</span>Easy Online Ordering</div>
          <div class="card"><span class="icon">📅</span>Simple Table Reservations</div>
        </div>
      </div>

      <div class="section">
        <h2>Join Us</h2>
        <p>
          Sign up or log in to access exclusive deals, manage your reservations, leave reviews, and get personalized recommendations based on your taste!
        </p>
      </div>
    </main>
  </div>

  <jsp:include page="../jsp/footer.jsp" /> <!-- Include the footer -->
</body>
</html>