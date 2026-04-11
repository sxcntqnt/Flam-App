package com.rideapp.dezole.model.dto.response;

import com.rideapp.dezole.model.enums.ComplaintStatus;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class ComplaintStateResponse {
    private Long id;
    private String topic;
    private String description;
    private ComplaintStatus status;
    private String response;
    private String errorMessage;
    private Boolean isSubmitting;
    private Boolean isSubmitted;
    private LocalDateTime createdAt;
    private LocalDateTime resolvedAt;
}
