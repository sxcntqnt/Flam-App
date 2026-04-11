package com.rideapp.dezole.model.entity;

import com.rideapp.dezole.model.enums.PaymentMethod;
import jakarta.persistence.*;
import lombok.*;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

@Entity
@Table(name = "wallets")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Wallet {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @OneToOne
    @JoinColumn(name = "user_id", unique = true, nullable = false)
    private User user;

    @Builder.Default
    private Double balance = 0.0;

    @Builder.Default
    private Double totalExpenditure = 0.0;

    @Enumerated(EnumType.STRING)
    @Builder.Default
    private PaymentMethod selectedPaymentMethod = PaymentMethod.WALLET;

    @OneToMany(mappedBy = "wallet", cascade = CascadeType.ALL, orphanRemoval = true)
    @Builder.Default
    private List<PaymentMethodConfig> paymentMethods = new ArrayList<>();

    @Builder.Default
    private Boolean isLoading = false;

    private String errorMessage;

    private LocalDateTime createdAt;

    private LocalDateTime updatedAt;

    @PrePersist
    protected void onCreate() {
        createdAt = LocalDateTime.now();
        updatedAt = LocalDateTime.now();
    }

    @PreUpdate
    protected void onUpdate() {
        updatedAt = LocalDateTime.now();
    }

    public void credit(double amount) {
        this.balance += amount;
    }

    public void debit(double amount) {
        if (this.balance < amount) {
            throw new RuntimeException("Insufficient balance");
        }
        this.balance -= amount;
        this.totalExpenditure += amount;
    }

    public boolean hasSufficientBalance(double amount) {
        return this.balance >= amount;
    }
}
