package com.rideapp.dezole.model.dto.response;

import com.rideapp.dezole.model.entity.User;
import com.rideapp.dezole.model.enums.RideStatus;
import com.rideapp.dezole.model.enums.TransportType;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class RideResponse {
    private String id;
    private UserResponse passenger;
    private DriverResponse driver;
    private Double originLatitude;
    private Double originLongitude;
    private String originAddress;
    private Double destinationLatitude;
    private Double destinationLongitude;
    private String destinationAddress;
    private Double fare;
    private RideStatus status;
    private TransportType transportType;
    private LocalDateTime createdAt;
}