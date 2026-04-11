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
public class DriverRegisterRequest {
    private String vehicleModel;
    private String vehicleNumber;
    private TransportType transportType;
}