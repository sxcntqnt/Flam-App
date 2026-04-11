package com.rideapp.dezole.dto;

import com.rideapp.dezole.model.enums.RideStatus;
import jakarta.validation.constraints.NotBlank;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class RideStatusUpdateRequest {
    @NotBlank(message = "Status is required")
    private RideStatus status;
    
    private String reason;
}
