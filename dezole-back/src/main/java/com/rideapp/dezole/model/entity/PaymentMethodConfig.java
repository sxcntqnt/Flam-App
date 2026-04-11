package com.rideapp.dezole.model.entity;

import com.rideapp.dezole.model.enums.PaymentMethod;
import jakarta.persistence.*;
import lombok.*;

@Entity
@Table(name = "payment_method_configs")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class PaymentMethodConfig {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne
    @JoinColumn(name = "wallet_id", nullable = false)
    private Wallet wallet;

    @Enumerated(EnumType.STRING)
    private PaymentMethod method;

    private String cardLastFour;

    private String cardBrand;

    private String expiryDate;

    private Boolean isDefault = false;

    private Boolean isVerified = false;

    private String externalReference;
}
