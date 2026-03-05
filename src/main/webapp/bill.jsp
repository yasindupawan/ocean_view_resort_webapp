
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="com.ocean.view.resort.oceanviewresortapp.model.Reservation" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Bill – Ocean View Resort</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
<%@ include file="navbar.jsp" %>
<div class="main-content">
  <div class="page-header">
    <h2>Guest Bill</h2>
    <% Reservation r = (Reservation) request.getAttribute("reservation"); %>
    <% if (r != null) { %>
    <button onclick="window.print()" class="btn btn-outline">🖨️ Print</button>
    <% } %>
  </div>

  <% if (r != null) { %>
  <div class="card bill-card" id="printArea">
    <div class="bill-header">
      <div class="bill-logo">🌊 Ocean View Resort</div>
      <div class="bill-address">Galle, Sri Lanka | +94 91 234 5678</div>
      <hr>
      <h3>INVOICE / RECEIPT</h3>
    </div>

    <div class="bill-details">
      <div class="bill-row"><span>Reservation No.</span><span><strong><%= r.getReservationNumber() %></strong></span></div>
      <div class="bill-row"><span>Guest Name</span><span><%= r.getGuestName() %></span></div>
      <div class="bill-row"><span>Contact</span><span><%= r.getContactNumber() %></span></div>
      <div class="bill-row"><span>Address</span><span><%= r.getAddress() %></span></div>
    </div>

    <table class="bill-table">
      <thead>
      <tr><th>Description</th><th>Nights</th><th>Rate/Night</th><th>Amount</th></tr>
      </thead>
      <tbody>
      <tr>
        <td><%= r.getRoomType().getName() %> Room<br><small><%= r.getCheckInDate() %> → <%= r.getCheckOutDate() %></small></td>
        <td><%= r.getNumberOfNights() %></td>
        <td><%= String.format("%.2f", r.getRoomRate()) %>LKR</td>
        <td><%= String.format("%.2f", r.getTotalCost()) %>LKR</td>
      </tr>
      </tbody>
      <tfoot>
      <tr><td colspan="3"><strong>TOTAL DUE</strong></td><td><strong><%= String.format("%.2f", r.getTotalCost()) %>LKR</strong></td></tr>
      </tfoot>
    </table>

    <div class="bill-footer">
      <p>Thank you for staying at Ocean View Resort!</p>
      <p><em>This is a computer-generated bill.</em></p>
    </div>
  </div>
  <% } else { %>
  <div class="alert alert-error">No reservation found. <a href="${pageContext.request.contextPath}/dashboard">Go back.</a></div>
  <% } %>
</div>
</body>
</html>
