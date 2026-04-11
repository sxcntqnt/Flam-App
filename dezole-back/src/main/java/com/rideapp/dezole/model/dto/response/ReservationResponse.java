package com.rideapp.dezole.model.dto.response;

import com.rideapp.dezole.model.enums.ReservationStatus;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDate;
import java.time.LocalDateTime;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class ReservationResponse {
    private Long id;
    private UserResponse customer;
    private ScheduleResponse schedule;
    private LocalDate departureDate;
    private String seatNumbers;
    private Integer totalSeats;
    private Double totalPrice;
    private ReservationStatus status;
    private LocalDateTime createdAt;
}