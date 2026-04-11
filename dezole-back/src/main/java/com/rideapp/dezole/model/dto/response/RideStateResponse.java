package com.rideapp.dezole.model.dto.response;

import com.rideapp.dezole.model.enums.RideStatus;
import com.rideapp.dezole.model.enums.RideType;
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
public class RideStateResponse {
    private String id;
    private RideType rideType;
    private TransportType transportType;
    private String fromAddress;
    private Double fromLatitude;
    private Double fromLongitude;
    private String toAddress;
    private Double toLatitude;
    private Double toLongitude;
    private RideStatus status;
    private Boolean isSearching;
    private Boolean offersReceived;
    private Boolean hasError;
    private String errorMessage;
    private String selectedOfferId;
    private Integer offersCount;
    private LocalDateTime requestedAt;
    private LocalDateTime driverAssignedAt;
    private LocalDateTime startedAt;
    private LocalDateTime completedAt;
}
