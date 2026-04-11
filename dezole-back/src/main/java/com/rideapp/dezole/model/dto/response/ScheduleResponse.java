package com.rideapp.dezole.model.dto.response;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class ScheduleResponse {
    private Long id;
    private BusResponse bus;
    private RouteResponse route;
    private String departureTime;
    private Double ticketPrice;
    private Integer discount;
    private Double processingFee;
    private Boolean active;
}