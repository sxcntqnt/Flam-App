package com.rideapp.dezole.controller;

import com.rideapp.dezole.model.dto.response.BookingStateResponse;
import com.rideapp.dezole.service.BookingService;
import lombok.RequiredArgsConstructor;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDate;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/bookings")
@RequiredArgsConstructor
public class BookingController {

    private final BookingService bookingService;

    @PostMapping
    public ResponseEntity<BookingStateResponse> createBooking(@RequestBody Map<String, Object> request) {
        String email = getCurrentUserEmail();
        String scheduleId = (String) request.get("scheduleId");
        
        @DateTimeFormat(iso = DateTimeFormat.ISO.DATE)
        LocalDate departureDate = LocalDate.parse((String) request.get("departureDate"));
        
        List<String> seatNumbers = ((List<?>) request.get("seatNumbers"))
                .stream()
                .map(Object::toString)
                .collect(java.util.stream.Collectors.toList());

        return ResponseEntity.status(HttpStatus.CREATED)
                .body(bookingService.createBooking(email, scheduleId, departureDate, seatNumbers));
    }

    @PostMapping("/{id}/confirm")
    public ResponseEntity<BookingStateResponse> confirmBooking(
            @PathVariable String id,
            @RequestBody Map<String, String> request) {
        String email = getCurrentUserEmail();
        String paymentMethod = request.get("paymentMethod");

        return ResponseEntity.ok(bookingService.confirmBooking(id, email, paymentMethod));
    }

    @GetMapping
    public ResponseEntity<List<BookingStateResponse>> getMyBookings() {
        String email = getCurrentUserEmail();
        return ResponseEntity.ok(bookingService.getUserBookings(email));
    }

    @GetMapping("/{id}")
    public ResponseEntity<BookingStateResponse> getBooking(@PathVariable String id) {
        String email = getCurrentUserEmail();
        return ResponseEntity.ok(bookingService.getBooking(id, email));
    }

    @PostMapping("/{id}/cancel")
    public ResponseEntity<BookingStateResponse> cancelBooking(@PathVariable String id) {
        String email = getCurrentUserEmail();
        return ResponseEntity.ok(bookingService.cancelBooking(id, email));
    }

    @GetMapping("/seats/{scheduleId}")
    public ResponseEntity<List<String>> getAvailableSeats(
            @PathVariable String scheduleId,
            @RequestParam @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate date) {
        return ResponseEntity.ok(bookingService.getAvailableSeats(scheduleId, date));
    }

    private String getCurrentUserEmail() {
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        return auth.getName();
    }
}