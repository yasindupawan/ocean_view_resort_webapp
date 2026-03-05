package com.ocean.view.resort.oceanviewresortapp.servlet;

import com.ocean.view.resort.oceanviewresortapp.dao.ReservationDAO;
import com.ocean.view.resort.oceanviewresortapp.dao.RoomTypeDAO;
import com.ocean.view.resort.oceanviewresortapp.model.Reservation;
import com.ocean.view.resort.oceanviewresortapp.model.RoomType;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.time.LocalDate;

@WebServlet("/dashboard")
public class ReservationServlet extends HttpServlet {

    private final ReservationDAO dao = new ReservationDAO();
    private final RoomTypeDAO roomTypeDAO = new RoomTypeDAO();

    private boolean isLoggedIn(HttpServletRequest req) {
        HttpSession s = req.getSession(false);
        return s != null && s.getAttribute("loggedInUser") != null;
    }

    // ── GET ───────────────────────────────────────────────────
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        if (!isLoggedIn(req)) { resp.sendRedirect(req.getContextPath() + "/login"); return; }

        String action = req.getParameter("action");
        if (action == null) action = "home";

        switch (action) {

            case "add" -> {
                req.setAttribute("roomTypes", roomTypeDAO.getAllRoomTypes());
                req.getRequestDispatcher("/addReservation.jsp").forward(req, resp);
            }

            case "view" -> {
                String resNum = req.getParameter("resNum");
                if (resNum != null && !resNum.isBlank()) {
                    Reservation r = dao.getReservation(resNum.trim());
                    req.setAttribute("reservation", r);
                    if (r == null) req.setAttribute("error", "Reservation not found.");
                }
                req.getRequestDispatcher("/viewReservation.jsp").forward(req, resp);
            }

            case "edit" -> {
                String resNum = req.getParameter("resNum");
                Reservation r = dao.getReservation(resNum);
                if (r == null) { resp.sendRedirect(req.getContextPath() + "/dashboard"); return; }
                if ("Cancelled".equals(r.getStatus().getName())) {
                    req.setAttribute("error", "Cannot edit a cancelled reservation.");
                    req.setAttribute("reservation", r);
                    req.getRequestDispatcher("/viewReservation.jsp").forward(req, resp);
                    return;
                }
                req.setAttribute("reservation", r);
                req.setAttribute("roomTypes", roomTypeDAO.getAllRoomTypes());
                req.getRequestDispatcher("/editReservation.jsp").forward(req, resp);
            }

            case "cancel" -> {
                String resNum = req.getParameter("resNum");
                Reservation r = dao.getReservation(resNum);
                if (r != null && "Active".equals(r.getStatus().getName())) {
                    req.setAttribute("reservation", r);
                    req.getRequestDispatcher("/cancelConfirm.jsp").forward(req, resp);
                } else {
                    resp.sendRedirect(req.getContextPath() + "/dashboard");
                }
            }

            case "help" -> req.getRequestDispatcher("/help.jsp").forward(req, resp);

            default -> {
                // Dashboard home – load all stats
                req.setAttribute("reservations", dao.getAllReservations());
                req.setAttribute("totalReservations", dao.getTotalReservations());
                req.setAttribute("activeReservations", dao.getActiveReservations());
                req.setAttribute("cancelledReservations", dao.getCancelledReservations());
                req.setAttribute("todayCheckIns", dao.getTodayCheckIns());
                req.setAttribute("todayCheckOuts", dao.getTodayCheckOuts());
                req.setAttribute("recentReservations", dao.getRecentReservations(5));
                req.getRequestDispatcher("/dashboard.jsp").forward(req, resp);
            }
        }
    }

    // ── POST ──────────────────────────────────────────────────
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        if (!isLoggedIn(req)) { resp.sendRedirect(req.getContextPath() + "/login"); return; }

        String action = req.getParameter("action");

        switch (action != null ? action : "") {

            case "add" -> {
                Reservation r = buildFromRequest(req);
                if (dao.reservationExists(r.getReservationNumber())) {
                    req.setAttribute("error", "Reservation number already exists.");
                    req.getRequestDispatcher("/addReservation.jsp").forward(req, resp);
                } else if (!datesValid(r)) {
                    req.setAttribute("error", "Check-out date must be after check-in date.");
                    req.getRequestDispatcher("/addReservation.jsp").forward(req, resp);
                } else {
                    dao.addReservation(r);
                    resp.sendRedirect(req.getContextPath() + "/dashboard?action=view&resNum="
                            + r.getReservationNumber() + "&added=true");
                }
            }

            case "update" -> {
                Reservation r = buildFromRequest(req);
                if (!datesValid(r)) {
                    req.setAttribute("error", "Check-out date must be after check-in date.");
                    req.setAttribute("reservation", dao.getReservation(r.getReservationNumber()));
                    req.getRequestDispatcher("/editReservation.jsp").forward(req, resp);
                    return;
                }
                boolean ok = dao.updateReservation(r);
                if (ok) {
                    resp.sendRedirect(req.getContextPath() + "/dashboard?action=view&resNum="
                            + r.getReservationNumber() + "&updated=true");
                } else {
                    req.setAttribute("error", "Update failed. Reservation may be cancelled.");
                    req.setAttribute("reservation", dao.getReservation(r.getReservationNumber()));
                    req.getRequestDispatcher("/editReservation.jsp").forward(req, resp);
                }
            }

            case "cancel" -> {
                String resNum = req.getParameter("reservationNumber");
                boolean ok = dao.cancelReservation(resNum);
                if (ok) {
                    resp.sendRedirect(req.getContextPath() + "/dashboard?cancelled=true");
                } else {
                    resp.sendRedirect(req.getContextPath() + "/dashboard");
                }
            }

            default -> resp.sendRedirect(req.getContextPath() + "/dashboard");
        }
    }

    // ── HELPERS ───────────────────────────────────────────────
    private Reservation buildFromRequest(HttpServletRequest req) {
        RoomType rt = new RoomType();
        rt.setName(req.getParameter("roomType"));

        Reservation r = new Reservation();
        r.setReservationNumber(req.getParameter("reservationNumber"));
        r.setGuestName(req.getParameter("guestName"));
        r.setAddress(req.getParameter("address"));
        r.setContactNumber(req.getParameter("contactNumber"));
        r.setRoomType(rt);
        r.setCheckInDate(LocalDate.parse(req.getParameter("checkInDate")));
        r.setCheckOutDate(LocalDate.parse(req.getParameter("checkOutDate")));
        return r;
    }

    private boolean datesValid(Reservation r) {
        return r.getCheckOutDate().isAfter(r.getCheckInDate());
    }
}