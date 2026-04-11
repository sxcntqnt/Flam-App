package com.rideapp.dezole.model.dto.response;

import com.rideapp.dezole.model.enums.PaymentMethod;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.List;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class WalletStateResponse {
    private Long id;
    private Double availableBalance;
    private Double totalExpenditure;
    private PaymentMethod selectedMethod;
    private Boolean isLoading;
    private String error;
    private List<TransactionResponse> recentTransactions;
    private List<PaymentMethodResponse> savedPaymentMethods;
}
