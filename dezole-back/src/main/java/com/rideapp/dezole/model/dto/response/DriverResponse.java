package com.rideapp.dezole.model.dto.response;

import com.rideapp.dezole.model.entity.User;
import com.rideapp.dezole.model.enums.TransportType;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class DriverResponse {
    private String id;
    private UserResponse user;
    private String vehicleModel;
    private String vehicleNumber;
    private TransportType transportType;
    private Boolean isAvailable;
    private Double currentLatitude;
    private Double currentLongitude;
    private Double rating;
}