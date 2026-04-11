package com.rideapp.dezole.model.dto.response;

import com.rideapp.dezole.model.enums.RideStatus;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class RideOfferResponse {
    private String id;
    private String rideId;
    private String driverId;
    private String driverName;
    private String driverImage;
    private Double driverRating;
    private String vehicleModel;
    private String vehicleNumber;
    private Double offeredFare;
    private Integer estimatedArrivalMinutes;
    private Double driverLatitude;
    private Double driverLongitude;
    private String message;
    private RideStatus status;
    private Boolean isAccepted;
    private Boolean isExpired;
    private LocalDateTime expiresAt;
    private LocalDateTime createdAt;
}
