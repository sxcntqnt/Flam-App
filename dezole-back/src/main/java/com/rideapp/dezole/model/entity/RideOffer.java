package com.rideapp.dezole.model.entity;

import com.rideapp.dezole.model.enums.RideStatus;
import jakarta.persistence.*;
import lombok.*;

import java.time.LocalDateTime;

@Entity
@Table(name = "ride_offers")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class RideOffer {
    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    private String id;

    @ManyToOne
    @JoinColumn(name = "ride_id", nullable = false)
    private Ride ride;

    @ManyToOne
    @JoinColumn(name = "driver_id", nullable = false)
    private Driver driver;

    private Double offeredFare;

    private Integer estimatedArrivalMinutes;

    private String message;

    @Enumerated(EnumType.STRING)
    @Builder.Default
    private RideStatus status = RideStatus.OFFERS_RECEIVED;

    @Builder.Default
    private Boolean isAccepted = false;

    @Builder.Default
    private Boolean isExpired = false;

    private LocalDateTime expiresAt;

    private LocalDateTime createdAt;

    @PrePersist
    protected void onCreate() {
        createdAt = LocalDateTime.now();
        if (expiresAt == null) {
            expiresAt = createdAt.plusMinutes(2);
        }
    }

    public void accept() {
        this.isAccepted = true;
        this.status = RideStatus.DRIVER_ASSIGNED;
    }

    public void expire() {
        this.isExpired = true;
        this.status = RideStatus.CANCELLED;
    }

    public boolean isExpired() {
        return isExpired || (expiresAt != null && LocalDateTime.now().isAfter(expiresAt));
    }
}
