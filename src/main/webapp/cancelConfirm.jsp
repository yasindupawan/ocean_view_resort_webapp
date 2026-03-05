
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="com.ocean.view.resort.oceanviewresortapp.model.Reservation" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Cancel Reservation – Ocean View Resort</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
<%@ include file="navbar.jsp" %>
<div class="main-content">
  <div class="page-header"><h2>Cancel Reservation</h2></div>

  <%
    Reservation r = (Reservation) request.getAttribute("reservation");
    if (r != null) {
  %>
  <div class="card cancel-card">
    <div class="cancel-icon">⚠️</div>
    <h3>Are you sure you want to cancel this reservation?</h3>
    <p class="cancel-sub">This action cannot be undone. The record will be kept as cancelled.</p>

    <div class="cancel-summary">
      <div class="bill-row"><span>Reservation No.</span><strong><%= r.getReservationNumber() %></strong></div>
      <div class="bill-row"><span>Guest Name</span><span><%= r.getGuestName() %></span></div>
      <div class="bill-row"><span>Room Type</span><span><%= r.getRoomType().getName() %></span></div>
      <div class="bill-row"><span>Check-In</span><span><%= r.getCheckInDate() %></span></div>
      <div class="bill-row"><span>Check-Out</span><span><%= r.getCheckOutDate() %></span></div>
    </div>

    <form method="post" action="${pageContext.request.contextPath}/dashboard">
      <input type="hidden" name="action" value="cancel">
      <input type="hidden" name="reservationNumber" value="<%= r.getReservationNumber() %>">
      <div class="cancel-actions">
        <a href="${pageContext.request.contextPath}/dashboard" class="btn btn-outline">No, Go Back</a>
        <button type="submit" class="btn btn-danger">Yes, Cancel Reservation</button>
      </div>
    </form>
  </div>
  <% } %>
</div>
</body>
</html>
