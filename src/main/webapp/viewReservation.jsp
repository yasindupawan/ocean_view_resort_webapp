
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="com.ocean.view.resort.oceanviewresortapp.model.Reservation" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>View Reservation – Ocean View Resort</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
<%@ include file="navbar.jsp" %>
<div class="main-content">
  <div class="page-header"><h2>Find Reservation</h2></div>

  <% if ("true".equals(request.getParameter("added"))) { %>
  <div class="alert alert-success">✅ Reservation added successfully!</div>
  <% } %>

  <div class="card search-card">
    <form method="get" action="${pageContext.request.contextPath}/dashboard">
      <input type="hidden" name="action" value="view">
      <div class="search-row">
        <input type="text" name="resNum" placeholder="Enter Reservation Number..." value="<%= request.getParameter("resNum") != null ? request.getParameter("resNum") : "" %>">
        <button type="submit" class="btn btn-primary">Search</button>
      </div>
    </form>
  </div>

  <% if (request.getAttribute("error") != null) { %>
  <div class="alert alert-error"><%= request.getAttribute("error") %></div>
  <% } %>

  <%
    Reservation r = (Reservation) request.getAttribute("reservation");
    if (r != null) {
  %>
  <div class="card detail-card">
    <div class="card-header">Reservation Details</div>
    <div class="detail-grid">
      <div class="detail-item"><span class="detail-label">Reservation No.</span><span class="detail-value highlight"><%= r.getReservationNumber() %></span></div>
      <div class="detail-item"><span class="detail-label">Guest Name</span><span class="detail-value"><%= r.getGuestName() %></span></div>
      <div class="detail-item full-width"><span class="detail-label">Address</span><span class="detail-value"><%= r.getAddress() %></span></div>
      <div class="detail-item"><span class="detail-label">Contact</span><span class="detail-value"><%= r.getContactNumber() %></span></div>
      <div class="detail-item"><span class="detail-label">Room Type</span><span class="detail-value"><span class="badge"><%= r.getRoomType().getName() %></span></span></div>
      <div class="detail-item"><span class="detail-label">Check-In</span><span class="detail-value"><%= r.getCheckInDate() %></span></div>
      <div class="detail-item"><span class="detail-label">Check-Out</span><span class="detail-value"><%= r.getCheckOutDate() %></span></div>
      <div class="detail-item"><span class="detail-label">Duration</span><span class="detail-value"><%= r.getNumberOfNights() %> nights</span></div>
    </div>
    <div class="form-actions">
      <% if ("Active".equals(r.getStatus().getName())) { %>
      <a href="${pageContext.request.contextPath}/dashboard?action=edit&resNum=<%= r.getReservationNumber() %>" class="btn btn-accent">✏️ Edit</a>
      <a href="${pageContext.request.contextPath}/bill?resNum=<%= r.getReservationNumber() %>" class="btn btn-primary">🧾 Generate Bill</a>
      <a href="${pageContext.request.contextPath}/dashboard?action=cancel&resNum=<%= r.getReservationNumber() %>" class="btn btn-danger">❌ Cancel Reservation</a>
      <% } else { %>
      <span class="status-badge status-cancelled" style="padding:0.5rem 1rem;">❌ This reservation is cancelled</span>
      <% } %>
    </div>
    <% if ("true".equals(request.getParameter("updated"))) { %>
    <div class="alert alert-success">✅ Reservation updated successfully!</div>
    <% } %>
  </div>
  <% } %>
</div>
</body>
</html>
