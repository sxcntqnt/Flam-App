package com.rideapp.dezole.dto;

import java.time.LocalDate;
import jakarta.validation.constraints.NotNull;
import lombok.Data;

@Data
public class ReservationRequest {
    @NotNull(message = "Schedule ID is required")
    private Long scheduleId;
    
    @NotNull(message = "Departure date is required")
    private LocalDate departureDate;
    
    private String seatNumbers;
    
    private int totalSeats;
}