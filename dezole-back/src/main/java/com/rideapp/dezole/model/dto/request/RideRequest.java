package com.rideapp.dezole.model.dto.request;

import com.rideapp.dezole.model.enums.TransportType;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class RideRequest {
    private Double originLatitude;
    private Double originLongitude;
    private String originAddress;
    private Double destinationLatitude;
    private Double destinationLongitude;
    private String destinationAddress;
    private TransportType transportType;
}