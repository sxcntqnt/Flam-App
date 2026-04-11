package com.rideapp.dezole.controller;

import com.rideapp.dezole.dto.ReservationRequest;
import com.rideapp.dezole.model.entity.Reservation;
import com.rideapp.dezole.model.entity.User;
import com.rideapp.dezole.service.ReservationService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDate;
import java.util.List;

@RestController
@RequestMapping("/api/reservations")
@RequiredArgsConstructor
public class ReservationController {

    private final ReservationService reservationService;

    @GetMapping
    public ResponseEntity<List<Reservation>> getMyReservations() {
        String userId = getCurrentUserId();
        return ResponseEntity.ok(reservationService.getCustomerReservations(userId));
    }

    @PostMapping
    public ResponseEntity<Reservation> createReservation(@Valid @RequestBody ReservationRequest request) {
        String userId = getCurrentUserId();
        return ResponseEntity.status(HttpStatus.CREATED).body(reservationService.createReservation(userId, request));
    }

    @PutMapping("/{id}/cancel")
    public ResponseEntity<Void> cancelReservation(@PathVariable Long id) {
        reservationService.cancelReservation(id);
        return ResponseEntity.ok().build();
    }

    @GetMapping("/seats/{scheduleId}/{date}")
    public ResponseEntity<List<String>> getBookedSeats(
            @PathVariable Long scheduleId,
            @PathVariable LocalDate date) {
        return ResponseEntity.ok(reservationService.getBookedSeats(scheduleId, date));
    }

    private String getCurrentUserId() {
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        User user = (User) auth.getPrincipal();
        return user.getId();
    }
}