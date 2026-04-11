package com.rideapp.dezole.model.dto.response;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class RouteResponse {
    private Long id;
    private String routeName;
    private String cityFrom;
    private String cityTo;
    private Double distanceKm;
    private Double baseFare;
    private String description;
}