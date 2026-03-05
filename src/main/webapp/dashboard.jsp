
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.List, com.ocean.view.resort.oceanviewresortapp.model.Reservation" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Dashboard – Ocean View Resort</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
<%@ include file="navbar.jsp" %>
<div class="main-content">

  <!-- Page Header -->
  <div class="page-header">
    <div>
      <h2>Dashboard</h2>
      <p class="page-subtitle">Welcome back, <strong><%= session.getAttribute("loggedInUser") %></strong></p>
    </div>
    <a href="${pageContext.request.contextPath}/dashboard?action=add" class="btn btn-primary">+ New Reservation</a>
  </div>

  <!-- Flash messages -->
  <% if ("true".equals(request.getParameter("cancelled"))) { %>
  <div class="alert alert-warning">⚠️ Reservation has been cancelled successfully.</div>
  <% } %>

  <!-- Stats Cards -->
  <div class="stats-row">
    <div class="stat-card stat-blue">
      <div class="stat-icon">📋</div>
      <div class="stat-number"><%= request.getAttribute("totalReservations") %></div>
      <div class="stat-label">Total Reservations</div>
    </div>
    <div class="stat-card stat-green">
      <div class="stat-icon">✅</div>
      <div class="stat-number"><%= request.getAttribute("activeReservations") %></div>
      <div class="stat-label">Active</div>
    </div>
    <div class="stat-card stat-teal">
      <div class="stat-icon">🏨</div>
      <div class="stat-number"><%= request.getAttribute("todayCheckIns") %></div>
      <div class="stat-label">Today's Check-Ins</div>
    </div>
    <div class="stat-card stat-orange">
      <div class="stat-icon">🚪</div>
      <div class="stat-number"><%= request.getAttribute("todayCheckOuts") %></div>
      <div class="stat-label">Today's Check-Outs</div>
    </div>
    <div class="stat-card stat-red">
      <div class="stat-icon">❌</div>
      <div class="stat-number"><%= request.getAttribute("cancelledReservations") %></div>
      <div class="stat-label">Cancelled</div>
    </div>
  </div>

  <!-- All Reservations Table -->
  <div class="card">
    <div class="card-header">All Reservations</div>
    <%
      List<Reservation> reservations = (List<Reservation>) request.getAttribute("reservations");
      if (reservations == null || reservations.isEmpty()) {
    %>
    <p class="empty-state">No reservations yet. <a href="${pageContext.request.contextPath}/dashboard?action=add">Add the first one.</a></p>
    <% } else { %>
    <table class="data-table">
      <thead>
      <tr>
        <th>Res. No.</th><th>Guest Name</th><th>Room Type</th>
        <th>Check-In</th><th>Check-Out</th><th>Nights</th>
        <th>Status</th><th>Actions</th>
      </tr>
      </thead>
      <tbody>
      <% for (Reservation r : reservations) {
        boolean active = "Active".equals(r.getStatus().getName());
      %>
      <tr class="<%= active ? "" : "row-cancelled" %>">
        <td><strong><%= r.getReservationNumber() %></strong></td>
        <td><%= r.getGuestName() %></td>
        <td><span class="badge"><%= r.getRoomType().getName() %></span></td>
        <td><%= r.getCheckInDate() %></td>
        <td><%= r.getCheckOutDate() %></td>
        <td><%= r.getNumberOfNights() %></td>
        <td>
                        <span class="status-badge <%= active ? "status-active" : "status-cancelled" %>">
                            <%= r.getStatus().getName() %>
                        </span>
        </td>
        <td class="action-cell">
          <a href="${pageContext.request.contextPath}/dashboard?action=view&resNum=<%= r.getReservationNumber() %>" class="btn btn-sm btn-outline">View</a>
          <% if (active) { %>
          <a href="${pageContext.request.contextPath}/dashboard?action=edit&resNum=<%= r.getReservationNumber() %>" class="btn btn-sm btn-accent">Edit</a>
          <a href="${pageContext.request.contextPath}/bill?resNum=<%= r.getReservationNumber() %>" class="btn btn-sm btn-teal">Bill</a>
          <a href="${pageContext.request.contextPath}/dashboard?action=cancel&resNum=<%= r.getReservationNumber() %>" class="btn btn-sm btn-danger">Cancel</a>
          <% } %>
        </td>
      </tr>
      <% } %>
      </tbody>
    </table>
    <% } %>
  </div>
</div>
</body>
</html>
