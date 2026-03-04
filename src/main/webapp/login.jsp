<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Ocean View Resort – Login</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body class="login-page">
<div class="login-container">
  <div class="login-logo">
    <span class="logo-icon">🌊</span>
    <h1>Ocean View Resort</h1>
    <p>Reservation Management System</p>
  </div>
  <% if (request.getAttribute("error") != null) { %>
  <div class="alert alert-error"><%= request.getAttribute("error") %></div>
  <% } %>
  <form method="post" action="${pageContext.request.contextPath}/login">
    <div class="form-group">
      <label for="username">Username</label>
      <input type="text" id="username" name="username" placeholder="Enter username" required autofocus>
    </div>
    <div class="form-group">
      <label for="password">Password</label>
      <input type="password" id="password" name="password" placeholder="Enter password" required>
    </div>
    <button type="submit" class="btn btn-primary btn-full">Sign In</button>
  </form>
</div>
</body>
</html>
