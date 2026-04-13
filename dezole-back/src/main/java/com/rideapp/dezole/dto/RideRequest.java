package com.rideapp.dezole.dto;

import com.rideapp.dezole.model.enums.PaymentMethod;
import com.rideapp.dezole.model.enums.RideType;
import com.rideapp.dezole.model.enums.TransportType;
import jakarta.validation.constraints.DecimalMax;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Positive;
import jakarta.validation.constraints.Size;
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
    @Size(max = 500, message = "From address must not exceed 500 characters")
    private String fromAddress;
    
    @DecimalMax(value = "90.0", message = "Latitude must be between -90 and 90")
    @DecimalMax(value = "-90.0", message = "Latitude must be between -90 and 90")
    private Double fromLatitude;
    
    @DecimalMax(value = "180.0", message = "Longitude must be between -180 and 180")
    @DecimalMax(value = "-180.0", message = "Longitude must be between -180 and 180")
    private Double fromLongitude;
    
    @NotBlank(message = "To address is required")
    @Size(max = 500, message = "To address must not exceed 500 characters")
    private String toAddress;
    
    @DecimalMax(value = "90.0", message = "Latitude must be between -90 and 90")
    @DecimalMax(value = "-90.0", message = "Latitude must be between -90 and 90")
    private Double toLatitude;
    
    @DecimalMax(value = "180.0", message = "Longitude must be between -180 and 180")
    @DecimalMax(value = "-180.0", message = "Longitude must be between -180 and 180")
    private Double toLongitude;
    
    @Positive(message = "Estimated fare must be positive")
    @DecimalMax(value = "100000.0", message = "Estimated fare must not exceed 100,000")
    private Double estimatedFare;
    
    @Positive(message = "Distance must be positive")
    @DecimalMax(value = "1000.0", message = "Distance must not exceed 1000 km")
    private Double distanceKm;
    
    @Positive(message = "Duration must be positive")
    @DecimalMax(value = "1440.0", message = "Duration must not exceed 24 hours")
    private Integer estimatedDurationMinutes;
    
    private TransportType transportType;
    private PaymentMethod paymentMethod;
}