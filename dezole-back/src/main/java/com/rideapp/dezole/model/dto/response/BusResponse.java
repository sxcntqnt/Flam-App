package com.rideapp.dezole.model.dto.response;

import com.rideapp.dezole.model.enums.BusType;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class BusResponse {
    private Long id;
    private String busName;
    private String busNumber;
    private BusType busType;
    private Integer totalSeats;
    private String seatLayout;
    private String imageUrl;
}