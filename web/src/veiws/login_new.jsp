<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="model.User" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
  <title>Login & Signup Form</title>
  <link rel="stylesheet" href="../css/index.css">
</head>
<body>
  <div class="container" id="container">

    <div class="form-container sign-up-container">
      <form action="${pageContext.request.contextPath}/RegisterServlet" method="post">
        <jsp:useBean id="user" class="model.User" scope="request" />
        <jsp:setProperty name="user" property="*" />

        <h1>Create Account</h1>
        <div class="social-container">
          <a href="#"><i>f</i></a>
          <a href="#"><i>G+</i></a>
          <a href="#"><i>in</i></a>
        </div>

        <input type="text" name="username" placeholder="Username" required />
        <input type="email" name="email" placeholder="Email" required />
        <input type="password" name="passwordHash" placeholder="Password" required />
        
        <button>Sign Up</button>
      </form>
    </div>

    <div class="form-container sign-in-container">
      <form action="${pageContext.request.contextPath}/LoginServlet" method="post">
        <h1>Sign in</h1>
        <div class="social-container">
          <a href="#"><i>f</i></a>
          <a href="#"><i>G+</i></a>
          <a href="#"><i>in</i></a>
        </div>

        <% String error = (String) request.getAttribute("error");
           if (error != null) { %>
          <p style="color: red; font-weight: bold;"><%= error %></p>
        <% } %>

        <input type="text" name="username" placeholder="Username or Email" required />
        <input type="password" name="password" placeholder="Password" required />
        <div class="remember-me">
          <input type="checkbox" id="rememberMe" name="rememberMe" />
          <label for="rememberMe">Remember Me</label>
        </div>
        <button type="submit"style="background-color: #673ab7 ">Sign In</button>
      </form>
    </div>

    <div class="overlay-container">
        <div class="overlay" style="background-color: #673ab7 " >
        <div class="overlay-panel overlay-left"style="background-color: #673ab7 ">
          <h1>Welcome Back!</h1>
          <p>To keep connected with us please login with your personal info</p>
          <button class="ghost" id="signIn">Sign In</button>
        </div>
        <div class="overlay-panel overlay-right"style="background-color: #673ab7 ">
          <h1>Hello, Friend!</h1>
          <p>Enter your personal details and start your journey with us</p>
          <button class="ghost" id="signUp"style="background-color: #673ab7 ">Sign Up</button>
        </div>
      </div>
    </div>
  </div>

  <script src="../js/loginscript.js"></script>
</body>
</html>
