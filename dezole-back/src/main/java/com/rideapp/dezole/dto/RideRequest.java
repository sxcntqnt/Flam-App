package com.rideapp.dezole.dto;

import com.rideapp.dezole.model.enums.PaymentMethod;
import com.rideapp.dezole.model.enums.RideType;
import com.rideapp.dezole.model.enums.TransportType;
import jakarta.validation.constraints.NotBlank;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class RideRequest {
    private RideType rideType;
    
    @NotBlank(message = "From address is required")
    private String fromAddress;
    private Double fromLatitude;
    private Double fromLongitude;
    
    @NotBlank(message = "To address is required")
    private String toAddress;
    private Double toLatitude;
    private Double toLongitude;
    
    private Double estimatedFare;
    private Double distanceKm;
    private Integer estimatedDurationMinutes;
    
    private TransportType transportType;
    private PaymentMethod paymentMethod;
}
