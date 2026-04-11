package com.rideapp.dezole.model.dto.response;

import com.rideapp.dezole.model.enums.PaymentMethod;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class PaymentMethodResponse {
    private Long id;
    private PaymentMethod method;
    private String cardLastFour;
    private String cardBrand;
    private String expiryDate;
    private Boolean isDefault;
    private Boolean isVerified;
}
