
<%@ page contentType="text/html;charset=UTF-8" %>
<nav class="navbar">
  <div class="nav-brand">🌊 Ocean View Resort</div>
  <div class="nav-links">
    <a href="${pageContext.request.contextPath}/dashboard">Dashboard</a>
    <a href="${pageContext.request.contextPath}/dashboard?action=add">New Reservation</a>
    <a href="${pageContext.request.contextPath}/dashboard?action=view">Find Reservation</a>
    <a href="${pageContext.request.contextPath}/dashboard?action=help">Help</a>
  </div>
  <div class="nav-user">
    👤 <%= session.getAttribute("loggedInUser") %>
    &nbsp;|&nbsp;
    <a href="${pageContext.request.contextPath}/logout">Logout</a>
  </div>
</nav>
