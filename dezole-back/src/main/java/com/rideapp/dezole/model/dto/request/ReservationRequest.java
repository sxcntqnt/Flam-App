package com.rideapp.dezole.model.dto.request;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDate;
import java.util.List;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class ReservationRequest {
    private Long scheduleId;
    private LocalDate departureDate;
    private List<String> seatNumbers;
    private Integer totalSeats;
}