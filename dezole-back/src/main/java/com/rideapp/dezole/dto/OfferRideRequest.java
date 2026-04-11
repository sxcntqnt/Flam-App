package com.rideapp.dezole.dto;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Positive;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class OfferRideRequest {
    @NotBlank(message = "Ride ID is required")
    private String rideId;
    
    @NotNull(message = "Offered fare is required")
    @Positive(message = "Fare must be positive")
    private Double offeredFare;
    
    @NotNull(message = "Estimated arrival minutes is required")
    @Positive(message = "Arrival time must be positive")
    private Integer estimatedArrivalMinutes;
    
    private String message;
}
