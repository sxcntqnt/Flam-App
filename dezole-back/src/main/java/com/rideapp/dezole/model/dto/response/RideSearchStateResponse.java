package com.rideapp.dezole.model.dto.response;

import com.rideapp.dezole.model.enums.RideSearchStatus;
import com.rideapp.dezole.model.enums.TransportMode;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.List;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class RideSearchStateResponse {
    private RideSearchStatus status;
    private String fromAddress;
    private Double fromLatitude;
    private Double fromLongitude;
    private String toAddress;
    private Double toLatitude;
    private Double toLongitude;
    private TransportMode transportMode;
    private Boolean isSearching;
    private String errorMessage;
    
    // Available offers
    private List<RideOfferResponse> availableOffers;
    private Integer offersCount;
    
    // Confirmed ride info
    private String rideId;
    private String driverId;
    private String driverName;
    private String driverImage;
    private Double driverRating;
    private String vehicleModel;
    private String vehicleNumber;
    private Double estimatedFare;
    private Integer estimatedArrivalMinutes;
    
    // Ride timing
    private String requestedAt;
    private String driverAssignedAt;
    private String startedAt;
    private String completedAt;
}