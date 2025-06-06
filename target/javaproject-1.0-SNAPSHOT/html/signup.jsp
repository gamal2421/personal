<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="javawork.personalexp.tools.Database" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Account Page</title>
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


   <link rel="stylesheet" href="../css/all.min.css"> <%-- Link to Font Awesome --%>
    <link rel="stylesheet" href="../css/sign-up.css">

</head>
<body>
    <div class="container">
        <div class="left-section">
            <h1>Welcome Back!</h1>
            <p>To keep connected with us please login with your personal info</p>
            <button class="signin-btn" onclick="window.location.href='login.jsp'">SIGN IN</button>
        </div>
        <div class="right-section">
            <h2>Create Account</h2>
            <div class="divider"> use your email for registration</div>
            <form id="signupForm" method="post">
                <input type="text" name="username" placeholder="Username" required>
                <input type="email" name="email" placeholder="Email" required>
                <input type="password" name="password" placeholder="Password" required>
                <button type="submit" class="signup-btn">SIGN UP</button>
            </form>

            <%
                String errorMsg = null;
                String username = request.getParameter("username");
                String email = request.getParameter("email");
                String password = request.getParameter("password");

                if (username != null && email != null && password != null) {
                    try {
                        if (!Database.isValidUserByEmail(email)) {
                            Database.create_user(username, password, email);
                            response.sendRedirect("login.jsp");
                        } else {
                            errorMsg = "Email is already registered.";
                        }
                    } catch (Exception e) {
                        errorMsg = "Error occurred while creating user.";
                        e.printStackTrace();
                    }
                }
            %>

            <% if (errorMsg != null) { %>
                <p style="color:red;"><%= errorMsg %></p>
            <% } %>

        </div>
    </div>

</body>
</html>
