<%@ page import="javawork.personalexp.tools.Database" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    String errorMsg = null;
    String email = request.getParameter("email");
    String password = request.getParameter("password");

    // Check if email and password are provided
    if (email != null && password != null) {
        // Validate the credentials
        if (Database.isValidUser(email, password)) {
            // Get user ID
            int userId = Database.getUserIdByEmail(email);
            boolean isAdmin = Database.isAdmin(userId);
            
            // Set session attributes
            session.setAttribute("userEmail", email);  
            session.setAttribute("userName", Database.getUserNameByEmail(email));
            session.setAttribute("userId", userId);
            session.setAttribute("isAdmin", isAdmin);
            
            // Redirect based on user role
            if (isAdmin) {
                response.sendRedirect("admin-dashboard.jsp");   
            } else {
                response.sendRedirect("dashboard.jsp");
            }
            return;
        } else {
            errorMsg = "Invalid email or password.";
        }
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
  <title>Login Page</title>
    <!-- Apple Touch Icon (iOS) -->
<link rel="apple-touch-icon" sizes="180x180" href="/icons/apple-touch-icon.png">
<!-- Android Chrome -->
<link rel="icon" type="image/png" sizes="192x192" href="/icons/android-chrome-192x192.png">
<link rel="icon" type="image/png" sizes="512x512" href="/icons/android-chrome-512x512.png">
<!-- Favicon -->
<link rel="icon" type="image/png" sizes="32x32" href="/icons/favicon-32x32.png">
<link rel="icon" type="image/png" sizes="16x16" href="/icons/favicon-16x16.png">
<!-- Optional: Web Manifest for PWA -->
<link rel="manifest" href="/icons/site.webmanifest">
  <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css" rel="stylesheet">
  <link rel="stylesheet" href="../css/login.css">
</head>
<body>
  <div class="container">
    <!-- Sign In Section -->
    <div class="left-section">
      <h2>Sign in to PEM</h2>
      <form method="post" action="login.jsp" id="loginForm">
        <div class="input-wrapper">
          <input type="email" name="email" placeholder="Email" required />
        </div>
        <div class="input-wrapper">
          <input type="password" name="password" placeholder="Password" required />
        </div>
        <button type="submit" class="signin-btn">SIGN IN</button>
        <% if (errorMsg != null) { %>
          <p style="color:red;"><%= errorMsg %></p>
        <% } %>
      </form>
    </div>
    <!-- Welcome Section -->
    <div class="right-section">
      <h1>Hello, Friend!</h1>
      <button class="signup-outline-btn" onclick="window.location.href='signup.jsp'">SIGN UP</button>
    </div>
  </div>
</body>
</html>
