package com.rideapp.dezole.service;

import com.rideapp.dezole.dto.ReservationRequest;
import com.rideapp.dezole.model.entity.Reservation;
import com.rideapp.dezole.model.entity.Schedule;
import com.rideapp.dezole.model.entity.User;
import com.rideapp.dezole.model.enums.ReservationStatus;
import com.rideapp.dezole.repository.ReservationRepository;
import com.rideapp.dezole.repository.ScheduleRepository;
import com.rideapp.dezole.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDate;
import java.util.List;

@Service
@RequiredArgsConstructor
public class ReservationService {

    private final ReservationRepository reservationRepository;
    private final UserRepository userRepository;
    private final ScheduleRepository scheduleRepository;

    @Transactional
    public Reservation createReservation(String customerId, ReservationRequest request) {
        User customer = userRepository.findById(customerId)
                .orElseThrow(() -> new RuntimeException("User not found"));

        Schedule schedule = scheduleRepository.findById(request.getScheduleId())
                .orElseThrow(() -> new RuntimeException("Schedule not found"));

        int seats = request.getTotalSeats() > 0 ? request.getTotalSeats() : 1;
        Double price = schedule.getTicketPrice() * seats;

        Reservation reservation = Reservation.builder()
                .customer(customer)
                .schedule(schedule)
                .departureDate(request.getDepartureDate())
                .seatNumbers(request.getSeatNumbers())
                .totalSeats(seats)
                .totalPrice(price)
                .status(ReservationStatus.CONFIRMED)
                .build();

        return reservationRepository.save(reservation);
    }

    public List<Reservation> getCustomerReservations(String customerId) {
        return reservationRepository.findByCustomerId(customerId);
    }

    public List<String> getBookedSeats(Long scheduleId, LocalDate date) {
        return reservationRepository.findBookedSeatsByScheduleAndDate(scheduleId, date);
    }

    @Transactional
    public void cancelReservation(Long id) {
        Reservation reservation = reservationRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Reservation not found"));
        
        reservation.setStatus(ReservationStatus.CANCELLED);
        reservationRepository.save(reservation);
    }
}