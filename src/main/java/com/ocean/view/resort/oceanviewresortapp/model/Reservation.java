package com.ocean.view.resort.oceanviewresortapp.model;

import java.time.LocalDate;
import java.time.temporal.ChronoUnit;

public class Reservation {
    private String reservationNumber;
    private String guestName;
    private String address;
    private String contactNumber;
    private RoomType roomType;                 // was String
    private LocalDate checkInDate;
    private LocalDate checkOutDate;
    private ReservationStatus status;          // was String

    public Reservation() {}

    public String getReservationNumber() { return reservationNumber; }
    public void setReservationNumber(String n) { this.reservationNumber = n; }
    public String getGuestName() { return guestName; }
    public void setGuestName(String n) { this.guestName = n; }
    public String getAddress() { return address; }
    public void setAddress(String a) { this.address = a; }
    public String getContactNumber() { return contactNumber; }
    public void setContactNumber(String c) { this.contactNumber = c; }
    public RoomType getRoomType() { return roomType; }
    public void setRoomType(RoomType roomType) { this.roomType = roomType; }
    public LocalDate getCheckInDate() { return checkInDate; }
    public void setCheckInDate(LocalDate d) { this.checkInDate = d; }
    public LocalDate getCheckOutDate() { return checkOutDate; }
    public void setCheckOutDate(LocalDate d) { this.checkOutDate = d; }
    public ReservationStatus getStatus() { return status; }
    public void setStatus(ReservationStatus status) { this.status = status; }

    public long getNumberOfNights() {
        if (checkInDate != null && checkOutDate != null)
            return ChronoUnit.DAYS.between(checkInDate, checkOutDate);
        return 0;
    }

    public double getRoomRate() {
        return roomType != null ? roomType.getRate() : 0.0;
    }

    public double getTotalCost() {
        return getNumberOfNights() * getRoomRate();
    }
}