
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.Map" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>New Reservation – Ocean View Resort</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
<%@ include file="navbar.jsp" %>
<div class="main-content">
  <div class="page-header">
    <h2>New Reservation</h2>
  </div>
  <%@ page import="java.util.List, com.ocean.view.resort.oceanviewresortapp.model.RoomType" %>
  <%
    Map<String, String> errors = (Map<String, String>) request.getAttribute("errors");
    Map<String, String[]> old = (Map<String, String[]>) request.getAttribute("old");

    // Helper method simulation via inline logic
    String resNum    = old != null && old.get("reservationNumber") != null ? old.get("reservationNumber")[0] : "";
    String guestName = old != null && old.get("guestName") != null ? old.get("guestName")[0] : "";
    String address   = old != null && old.get("address") != null ? old.get("address")[0] : "";
    String contact   = old != null && old.get("contactNumber") != null ? old.get("contactNumber")[0] : "";
    String roomType  = old != null && old.get("roomType") != null ? old.get("roomType")[0] : "";
    String checkIn   = old != null && old.get("checkInDate") != null ? old.get("checkInDate")[0] : "";
    String checkOut  = old != null && old.get("checkOutDate") != null ? old.get("checkOutDate")[0] : "";

    if (errors != null && errors.containsKey("general")) {
  %>
  <div class="alert alert-error"><%= errors.get("general") %></div>
  <% } %>

  <div class="card form-card">
    <form id="reservationForm" method="post" action="${pageContext.request.contextPath}/dashboard" novalidate>
      <input type="hidden" name="action" value="add">
      <div class="form-grid">

        <!-- Reservation Number -->
        <div class="form-group">
          <label for="reservationNumber">Reservation Number *</label>
          <input type="text" id="reservationNumber" name="reservationNumber"
                 placeholder="e.g. RES-2024-001"
                 value="<%= resNum %>"
                 class="<%= errors != null && errors.containsKey("reservationNumber") ? "input-error" : "" %>">
          <span class="field-hint">Format: RES-YYYY-### (e.g. RES-2024-001)</span>
          <% if (errors != null && errors.containsKey("reservationNumber")) { %>
          <span class="field-error"><%= errors.get("reservationNumber") %></span>
          <% } %>
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

        <!-- Contact -->
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

        <!-- Room Type -->
        <div class="form-group">
          <label for="roomType">Room Type *</label>
          <%
            List<RoomType> roomTypes = (List<RoomType>) request.getAttribute("roomTypes");
          %>
          <select id="roomType" name="roomType" ...>
            <option value="">-- Select Room --</option>
            <% if (roomTypes != null) {
              for (RoomType rt : roomTypes) { %>
            <option value="<%= rt.getName() %>">
              <%= rt.getName() %> (<%= String.format("%.0f", rt.getRate()) %>LKR/night)
            </option>
            <% } } %>
          </select>
          <% if (errors != null && errors.containsKey("roomType")) { %>
          <span class="field-error"><%= errors.get("roomType") %></span>
          <% } %>
        </div>

        <!-- Check-In -->
        <div class="form-group">
          <label for="checkInDate">Check-In Date *</label>
          <input type="date" id="checkInDate" name="checkInDate"
                 value="<%= checkIn %>"
                 class="<%= errors != null && errors.containsKey("checkInDate") ? "input-error" : "" %>">
          <% if (errors != null && errors.containsKey("checkInDate")) { %>
          <span class="field-error"><%= errors.get("checkInDate") %></span>
          <% } %>
        </div>

        <!-- Check-Out -->
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
        <div class="form-group full-width">
          <div id="costPreview" class="cost-preview hidden">
            💰 Estimated Total: <strong id="previewAmount">$0.00</strong>
            (<span id="previewNights">0</span> nights × <span id="previewRate">$0</span>/night)
          </div>
        </div>

      </div>

      <div class="form-actions">
        <a href="${pageContext.request.contextPath}/dashboard" class="btn btn-outline">Cancel</a>
        <button type="submit" class="btn btn-primary">Save Reservation</button>
      </div>
    </form>
  </div>
</div>

<script>
  // ── Helpers ──────────────────────────────────────────────────
  const $ = id => document.getElementById(id);
  const today = new Date().toISOString().split('T')[0];

  // Set minimum date for check-in to today
  $('checkInDate').setAttribute('min', today);

  // ── Real-time field validators ────────────────────────────────
  function showError(inputEl, msg) {
    inputEl.classList.add('input-error');
    inputEl.classList.remove('input-ok');
    let span = inputEl.parentElement.querySelector('.field-error');
    if (!span) { span = document.createElement('span'); span.className = 'field-error'; inputEl.after(span); }
    span.textContent = msg;
  }
  function clearError(inputEl) {
    inputEl.classList.remove('input-error');
    inputEl.classList.add('input-ok');
    const span = inputEl.parentElement.querySelector('.field-error');
    if (span) span.textContent = '';
  }

  function validateResNum() {
    const el = $('reservationNumber');
    const v = el.value.trim();
    if (!v) { showError(el, 'Reservation number is required.'); return false; }
    if (!/^RES-\d{4}-\d{3,6}$/.test(v)) { showError(el, 'Format: RES-YYYY-### (e.g. RES-2024-001)'); return false; }
    clearError(el); return true;
  }

  function validateGuestName() {
    const el = $('guestName');
    const v = el.value.trim();
    if (!v) { showError(el, 'Guest name is required.'); return false; }
    if (v.length < 2) { showError(el, 'Name must be at least 2 characters.'); return false; }
    if (v.length > 100) { showError(el, 'Name must not exceed 100 characters.'); return false; }
    if (!/^[a-zA-Z\s.''\-]+$/.test(v)) { showError(el, "Only letters, spaces, and . ' - allowed."); return false; }
    clearError(el); return true;
  }

  function validateAddress() {
    const el = $('address');
    const v = el.value.trim();
    if (!v) { showError(el, 'Address is required.'); return false; }
    if (v.length < 5) { showError(el, 'Address must be at least 5 characters.'); return false; }
    if (v.length > 255) { showError(el, 'Address must not exceed 255 characters.'); return false; }
    clearError(el); return true;
  }

  function validateContact() {
    const el = $('contactNumber');
    const v = el.value.trim();
    if (!v) { showError(el, 'Contact number is required.'); return false; }
    const digits = v.replace(/[\s\-\+\(\)]/g, '');
    if (!/^\d{7,15}$/.test(digits)) { showError(el, 'Enter a valid phone number (7–15 digits).'); return false; }
    clearError(el); return true;
  }

  function validateRoomType() {
    const el = $('roomType');
    if (!el.value) { showError(el, 'Please select a room type.'); return false; }
    clearError(el); return true;
  }

  function validateDates() {
    const ciEl = $('checkInDate');
    const coEl = $('checkOutDate');
    const ci = ciEl.value, co = coEl.value;
    let valid = true;

    if (!ci) { showError(ciEl, 'Check-in date is required.'); valid = false; }
    else if (ci < today) { showError(ciEl, 'Check-in date cannot be in the past.'); valid = false; }
    else { clearError(ciEl); }

    if (!co) { showError(coEl, 'Check-out date is required.'); valid = false; }
    else if (ci && co <= ci) { showError(coEl, 'Check-out must be after check-in date.'); valid = false; }
    else { clearError(coEl); }

    updateCostPreview();
    return valid;
  }

  // ── Cost Preview ─────────────────────────────────────────────
  const rates = { 'Standard': 25000, 'Deluxe': 35000, 'Suite': 55000, 'Ocean View Suite': 65000 };

  function updateCostPreview() {
    const ci = $('checkInDate').value;
    const co = $('checkOutDate').value;
    const rt = $('roomType').value;
    const preview = $('costPreview');

    if (ci && co && rt && co > ci) {
      const nights = Math.round((new Date(co) - new Date(ci)) / 86400000);
      const rate = rates[rt] || 0;
      const total = nights * rate;
      $('previewNights').textContent = nights;
      $('previewRate').textContent = rate + 'LKR';
      $('previewAmount').textContent = total.toFixed(2) + 'LKR';
      preview.classList.remove('hidden');
    } else {
      preview.classList.add('hidden');
    }
  }

  // ── Attach listeners ─────────────────────────────────────────
  $('reservationNumber').addEventListener('blur', validateResNum);
  $('reservationNumber').addEventListener('input', validateResNum);
  $('guestName').addEventListener('blur', validateGuestName);
  $('guestName').addEventListener('input', validateGuestName);
  $('address').addEventListener('blur', validateAddress);
  $('address').addEventListener('input', validateAddress);
  $('contactNumber').addEventListener('blur', validateContact);
  $('contactNumber').addEventListener('input', validateContact);
  $('roomType').addEventListener('change', () => { validateRoomType(); updateCostPreview(); });
  $('checkInDate').addEventListener('change', () => {
    // Auto-set checkout min date
    if ($('checkInDate').value) {
      const nextDay = new Date($('checkInDate').value);
      nextDay.setDate(nextDay.getDate() + 1);
      $('checkOutDate').setAttribute('min', nextDay.toISOString().split('T')[0]);
    }
    validateDates();
  });
  $('checkOutDate').addEventListener('change', validateDates);

  // ── Final form submit guard ───────────────────────────────────
  $('reservationForm').addEventListener('submit', function(e) {
    const v1 = validateResNum();
    const v2 = validateGuestName();
    const v3 = validateAddress();
    const v4 = validateContact();
    const v5 = validateRoomType();
    const v6 = validateDates();
    if (!(v1 && v2 && v3 && v4 && v5 && v6)) {
      e.preventDefault();
      // Scroll to first error
      const firstError = document.querySelector('.input-error');
      if (firstError) firstError.scrollIntoView({ behavior: 'smooth', block: 'center' });
    }
  });
</script>

</body>
</html>
