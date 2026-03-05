
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.Map, java.util.List, com.ocean.view.resort.oceanviewresortapp.model.Reservation, com.ocean.view.resort.oceanviewresortapp.model.RoomType" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Edit Reservation – Ocean View Resort</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
<%@ include file="navbar.jsp" %>
<div class="main-content">
  <div class="page-header"><h2>Edit Reservation</h2></div>

  <%
    Map<String, String> errors = (Map<String, String>) request.getAttribute("errors");
    Reservation r = (Reservation) request.getAttribute("reservation");
    List<RoomType> roomTypes = (List<RoomType>) request.getAttribute("roomTypes");

    if (r == null) { response.sendRedirect(request.getContextPath() + "/dashboard"); return; }

    String guestName = r.getGuestName()        != null ? r.getGuestName()                : "";
    String address   = r.getAddress()           != null ? r.getAddress()                  : "";
    String contact   = r.getContactNumber()     != null ? r.getContactNumber()             : "";
    String roomType  = r.getRoomType()          != null ? r.getRoomType().getName()        : "";
    String checkIn   = r.getCheckInDate()       != null ? r.getCheckInDate().toString()   : "";
    String checkOut  = r.getCheckOutDate()      != null ? r.getCheckOutDate().toString()  : "";

    if (errors != null && errors.containsKey("general")) {
  %>
  <div class="alert alert-error"><%= errors.get("general") %></div>
  <% } %>

  <div class="card form-card">
    <div class="edit-notice">
      ✏️ Editing <strong><%= r.getReservationNumber() %></strong> — Reservation number cannot be changed.
    </div>

    <form id="editForm" method="post" action="${pageContext.request.contextPath}/dashboard" novalidate>
      <input type="hidden" name="action" value="update">
      <input type="hidden" name="reservationNumber" value="<%= r.getReservationNumber() %>">

      <div class="form-grid">

        <!-- Reservation Number (locked) -->
        <div class="form-group">
          <label>Reservation Number</label>
          <input type="text" value="<%= r.getReservationNumber() %>" disabled class="input-disabled">
        </div>

        <!-- Guest Name -->
        <div class="form-group">
          <label for="guestName">Guest Name *</label>
          <input type="text" id="guestName" name="guestName"
                 placeholder="Full name"
                 value="<%= guestName %>"
                 class="<%= errors != null && errors.containsKey("guestName") ? "input-error" : "" %>">
          <% if (errors != null && errors.containsKey("guestName")) { %>
          <span class="field-error"><%= errors.get("guestName") %></span>
          <% } %>
        </div>

        <!-- Address -->
        <div class="form-group full-width">
          <label for="address">Address *</label>
          <textarea id="address" name="address" rows="2"
                    placeholder="Full address"
                    class="<%= errors != null && errors.containsKey("address") ? "input-error" : "" %>"><%= address %></textarea>
          <% if (errors != null && errors.containsKey("address")) { %>
          <span class="field-error"><%= errors.get("address") %></span>
          <% } %>
        </div>

        <!-- Contact Number -->
        <div class="form-group">
          <label for="contactNumber">Contact Number *</label>
          <input type="tel" id="contactNumber" name="contactNumber"
                 placeholder="+94 77 123 4567"
                 value="<%= contact %>"
                 class="<%= errors != null && errors.containsKey("contactNumber") ? "input-error" : "" %>">
          <% if (errors != null && errors.containsKey("contactNumber")) { %>
          <span class="field-error"><%= errors.get("contactNumber") %></span>
          <% } %>
        </div>

        <!-- Room Type (dynamic from DB) -->
        <div class="form-group">
          <label for="roomType">Room Type *</label>
          <select id="roomType" name="roomType"
                  class="<%= errors != null && errors.containsKey("roomType") ? "input-error" : "" %>">
            <option value="">-- Select Room --</option>
            <% if (roomTypes != null) {
              for (RoomType rt : roomTypes) { %>
            <option value="<%= rt.getName() %>"
                    <%= rt.getName().equals(roomType) ? "selected" : "" %>>
              <%= rt.getName() %> (<%= String.format("%.0f", rt.getRate()) %>LKR/night)
            </option>
            <% } } %>
          </select>
          <% if (errors != null && errors.containsKey("roomType")) { %>
          <span class="field-error"><%= errors.get("roomType") %></span>
          <% } %>
        </div>

        <!-- Check-In Date -->
        <div class="form-group">
          <label for="checkInDate">Check-In Date *</label>
          <input type="date" id="checkInDate" name="checkInDate"
                 value="<%= checkIn %>"
                 class="<%= errors != null && errors.containsKey("checkInDate") ? "input-error" : "" %>">
          <% if (errors != null && errors.containsKey("checkInDate")) { %>
          <span class="field-error"><%= errors.get("checkInDate") %></span>
          <% } %>
        </div>

        <!-- Check-Out Date -->
        <div class="form-group">
          <label for="checkOutDate">Check-Out Date *</label>
          <input type="date" id="checkOutDate" name="checkOutDate"
                 value="<%= checkOut %>"
                 class="<%= errors != null && errors.containsKey("checkOutDate") ? "input-error" : "" %>">
          <% if (errors != null && errors.containsKey("checkOutDate")) { %>
          <span class="field-error"><%= errors.get("checkOutDate") %></span>
          <% } %>
        </div>

        <!-- Live Cost Preview -->
<%--        <div class="form-group full-width">--%>
<%--          <div id="costPreview" class="cost-preview hidden">--%>
<%--            💰 Estimated Total: <strong id="previewAmount">$0.00</strong>--%>
<%--            (<span id="previewNights">0</span> nights × <span id="previewRate">$0</span>/night)--%>
<%--          </div>--%>
<%--        </div>--%>

      </div>

      <div class="form-actions">
        <a href="${pageContext.request.contextPath}/dashboard?action=view&resNum=<%= r.getReservationNumber() %>" class="btn btn-outline">Back</a>
        <button type="submit" class="btn btn-primary">Save Changes</button>
      </div>
    </form>
  </div>
</div>

<script>
  // ── Build rates map dynamically from server-rendered room type options ────────
  // This avoids hardcoding rates in JS — they come from the DB via JSP
  const rates = {};
  document.querySelectorAll('#roomType option').forEach(opt => {
    if (opt.value) {
      const match = opt.textContent.match(/\$(\d+)/);
      if (match) rates[opt.value] = parseFloat(match[1]);
    }
  });

  const $ = id => document.getElementById(id);

  // ── Error helpers ─────────────────────────────────────────────────────────────
  function showError(el, msg) {
    el.classList.add('input-error');
    el.classList.remove('input-ok');
    let span = el.parentElement.querySelector('.field-error');
    if (!span) {
      span = document.createElement('span');
      span.className = 'field-error';
      el.after(span);
    }
    span.textContent = msg;
  }

  function clearError(el) {
    el.classList.remove('input-error');
    el.classList.add('input-ok');
    const span = el.parentElement.querySelector('.field-error');
    if (span) span.textContent = '';
  }

  // ── Field validators ──────────────────────────────────────────────────────────
  function validateGuestName() {
    const el = $('guestName');
    const v  = el.value.trim();
    if (!v)          { showError(el, 'Guest name is required.');               return false; }
    if (v.length < 2){ showError(el, 'Name must be at least 2 characters.');   return false; }
    if (v.length > 100){ showError(el, 'Name must not exceed 100 characters.'); return false; }
    if (!/^[a-zA-Z\s.''\-]+$/.test(v)) { showError(el, "Only letters, spaces, and . ' - allowed."); return false; }
    clearError(el);
    return true;
  }

  function validateAddress() {
    const el = $('address');
    const v  = el.value.trim();
    if (!v)           { showError(el, 'Address is required.');                  return false; }
    if (v.length < 5) { showError(el, 'Address must be at least 5 characters.'); return false; }
    if (v.length > 255){ showError(el, 'Address must not exceed 255 characters.'); return false; }
    clearError(el);
    return true;
  }

  function validateContact() {
    const el = $('contactNumber');
    const v  = el.value.trim();
    if (!v) { showError(el, 'Contact number is required.'); return false; }
    const digits = v.replace(/[\s\-\+\(\)]/g, '');
    if (!/^\d{7,15}$/.test(digits)) { showError(el, 'Enter a valid phone number (7–15 digits).'); return false; }
    clearError(el);
    return true;
  }

  function validateRoomType() {
    const el = $('roomType');
    if (!el.value) { showError(el, 'Please select a room type.'); return false; }
    clearError(el);
    return true;
  }

  function validateDates() {
    const ciEl = $('checkInDate');
    const coEl = $('checkOutDate');
    const ci   = ciEl.value;
    const co   = coEl.value;
    let valid  = true;

    if (!ci) {
      showError(ciEl, 'Check-in date is required.');
      valid = false;
    } else {
      clearError(ciEl);
    }

    if (!co) {
      showError(coEl, 'Check-out date is required.');
      valid = false;
    } else if (ci && co <= ci) {
      showError(coEl, 'Check-out must be after check-in date.');
      valid = false;
    } else {
      clearError(coEl);
    }

    updateCostPreview();
    return valid;
  }

  // ── Live cost preview ─────────────────────────────────────────────────────────
  function updateCostPreview() {
    const ci      = $('checkInDate').value;
    const co      = $('checkOutDate').value;
    const rt      = $('roomType').value;
    const preview = $('costPreview');

    if (ci && co && rt && co > ci) {
      const nights = Math.round((new Date(co) - new Date(ci)) / 86400000);
      const rate   = rates[rt] || 0;
      $('previewNights').textContent = nights;
      $('previewRate').textContent   = '$' + rate;
      $('previewAmount').textContent = '$' + (nights * rate).toFixed(2);
      preview.classList.remove('hidden');
    } else {
      preview.classList.add('hidden');
    }
  }

  // Trigger preview immediately on page load (form is pre-filled)
  updateCostPreview();

  // ── Event listeners ───────────────────────────────────────────────────────────
  $('guestName').addEventListener('blur',   validateGuestName);
  $('guestName').addEventListener('input',  validateGuestName);

  $('address').addEventListener('blur',  validateAddress);
  $('address').addEventListener('input', validateAddress);

  $('contactNumber').addEventListener('blur',  validateContact);
  $('contactNumber').addEventListener('input', validateContact);

  $('roomType').addEventListener('change', () => {
    validateRoomType();
    updateCostPreview();
  });

  $('checkInDate').addEventListener('change', () => {
    if ($('checkInDate').value) {
      const next = new Date($('checkInDate').value);
      next.setDate(next.getDate() + 1);
      $('checkOutDate').setAttribute('min', next.toISOString().split('T')[0]);
    }
    validateDates();
  });

  $('checkOutDate').addEventListener('change', validateDates);

  // ── Submit guard ──────────────────────────────────────────────────────────────
  $('editForm').addEventListener('submit', function(e) {
    const v1 = validateGuestName();
    const v2 = validateAddress();
    const v3 = validateContact();
    const v4 = validateRoomType();
    const v5 = validateDates();
    if (!(v1 && v2 && v3 && v4 && v5)) {
      e.preventDefault();
      document.querySelector('.input-error')?.scrollIntoView({ behavior: 'smooth', block: 'center' });
    }
  });
</script>

</body>
</html>
