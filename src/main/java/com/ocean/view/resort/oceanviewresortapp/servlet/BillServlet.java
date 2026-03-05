package com.ocean.view.resort.oceanviewresortapp.servlet;

import com.ocean.view.resort.oceanviewresortapp.dao.ReservationDAO;
import com.ocean.view.resort.oceanviewresortapp.model.Reservation;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet("/bill")
public class BillServlet extends HttpServlet {
    private final ReservationDAO dao = new ReservationDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("loggedInUser") == null) {
            resp.sendRedirect(req.getContextPath() + "/login"); return;
        }
        String resNum = req.getParameter("resNum");
        if (resNum != null) {
            Reservation r = dao.getReservation(resNum.trim());
            req.setAttribute("reservation", r);
        }
        req.getRequestDispatcher("/bill.jsp").forward(req, resp);
    }
}
