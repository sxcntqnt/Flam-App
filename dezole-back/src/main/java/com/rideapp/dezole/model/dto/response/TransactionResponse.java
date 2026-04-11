package com.rideapp.dezole.model.dto.response;

import com.rideapp.dezole.model.enums.PaymentMethod;
import com.rideapp.dezole.model.enums.TransactionType;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class TransactionResponse {
    private Long id;
    private TransactionType type;
    private Double amount;
    private String description;
    private Double balanceBefore;
    private Double balanceAfter;
    private PaymentMethod paymentMethod;
    private String reference;
    private Boolean isSuccessful;
    private LocalDateTime createdAt;
}
