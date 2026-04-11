package com.rideapp.dezole.model.entity;

import com.rideapp.dezole.model.enums.PaymentMethod;
import com.rideapp.dezole.model.enums.TransactionType;
import jakarta.persistence.*;
import lombok.*;

import java.time.LocalDateTime;

@Entity
@Table(name = "transactions")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Transaction {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne
    @JoinColumn(name = "wallet_id", nullable = false)
    private Wallet wallet;

    @Enumerated(EnumType.STRING)
    private TransactionType type;

    private Double amount;

    private String description;

    private Double balanceBefore;

    private Double balanceAfter;

    @Enumerated(EnumType.STRING)
    private PaymentMethod paymentMethod;

    private String reference;

    private String rideId;

    private Boolean isSuccessful = true;

    private String failureReason;

    private LocalDateTime createdAt;

    @PrePersist
    protected void onCreate() {
        createdAt = LocalDateTime.now();
        if (isSuccessful == null) {
            isSuccessful = true;
        }
    }
}
