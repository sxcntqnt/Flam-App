package com.rideapp.dezole.dto;

import com.rideapp.dezole.model.enums.TransportType;
import jakarta.validation.constraints.NotBlank;
import lombok.Data;

@Data
public class DriverRegisterRequest {
    @NotBlank(message = "Vehicle model is required")
    private String vehicleModel;

    @NotBlank(message = "Vehicle number is required")
    private String vehicleNumber;

    private String vehicleImage;

    private TransportType transportType;
}