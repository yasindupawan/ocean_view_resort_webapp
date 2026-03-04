<%--
  Created by IntelliJ IDEA.
  User: sajith_h
  Date: 3/2/2026
  Time: 9:02 AM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Help – Ocean View Resort</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
<%@ include file="navbar.jsp" %>
<div class="main-content">
  <div class="page-header"><h2>Help & User Guide</h2></div>
  <div class="card help-card">
    <div class="help-section">
      <h3>🔐 1. Logging In</h3>
      <p>Enter your system username and password on the login page. Contact the system administrator if you do not have credentials.</p>
    </div>
    <div class="help-section">
      <h3>➕ 2. Adding a New Reservation</h3>
      <p>Click <strong>"New Reservation"</strong> from the navigation bar or dashboard. Fill in all required fields — reservation number must be unique (e.g., <code>RES-2024-001</code>). Check-out date must be after the check-in date. Click <strong>"Save Reservation"</strong>.</p>
    </div>
    <div class="help-section">
      <h3>🔍 3. Finding a Reservation</h3>
      <p>Click <strong>"Find Reservation"</strong> in the navigation. Enter the exact reservation number and click <strong>"Search"</strong>. Full guest details will be displayed.</p>
    </div>
    <div class="help-section">
      <h3>🧾 4. Generating a Bill</h3>
      <p>From the reservation view or dashboard, click the <strong>"Bill"</strong> button next to any reservation. The system will calculate the total cost based on room rate × number of nights. Use <strong>"Print"</strong> to print the invoice.</p>
    </div>
    <div class="help-section">
      <h3>💰 5. Room Rates</h3>
      <table class="data-table">
        <thead><tr><th>Room Type</th><th>Rate per Night</th></tr></thead>
        <tbody>
        <tr><td>Standard</td><td>25000.00</td></tr>
        <tr><td>Deluxe</td><td>35000.00</td></tr>
        <tr><td>Suite</td><td>55000.00</td></tr>
        <tr><td>Ocean View Suite</td><td>65000.00</td></tr>
        </tbody>
      </table>
    </div>
    <div class="help-section">
      <h3>🚪 6. Logging Out</h3>
      <p>Click <strong>"Logout"</strong> in the top-right corner to safely end your session.</p>
    </div>
  </div>
</div>
</body>
</html>
