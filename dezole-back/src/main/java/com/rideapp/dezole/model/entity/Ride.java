package com.rideapp.dezole.model.entity;

import com.rideapp.dezole.model.enums.RideStatus;
import com.rideapp.dezole.model.enums.RideType;
import com.rideapp.dezole.model.enums.TransportType;
import jakarta.persistence.*;
import lombok.*;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

@Entity
@Table(name = "rides")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Ride {
    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    private String id;

    @ManyToOne
    @JoinColumn(name = "passenger_id", nullable = false)
    private User passenger;

    @ManyToOne
    @JoinColumn(name = "driver_id")
    private Driver driver;

    @Enumerated(EnumType.STRING)
    @Builder.Default
    private RideType rideType = RideType.TRANSPORT;

    @Enumerated(EnumType.STRING)
    private TransportType transportType;

    private String fromAddress;

    private Double fromLatitude;

    private Double fromLongitude;

    private String toAddress;

    private Double toLatitude;

    private Double toLongitude;

    private Double estimatedFare;

    private Double actualFare;

    private Double distanceKm;

    private Integer estimatedDurationMinutes;

    @Enumerated(EnumType.STRING)
    @Builder.Default
    private RideStatus status = RideStatus.INITIAL;

    @Enumerated(EnumType.STRING)
    @Builder.Default
    private PaymentMethod paymentMethod = PaymentMethod.WALLET;

    @Builder.Default
    private Boolean isSearching = false;

    @Builder.Default
    private Boolean offersReceived = false;

    private String selectedOfferId;

    private String cancellationReason;

    private String errorMessage;

    @OneToMany(mappedBy = "ride", cascade = CascadeType.ALL, orphanRemoval = true)
    @Builder.Default
    private List<RideOffer> offers = new ArrayList<>();

    private LocalDateTime requestedAt;

    private LocalDateTime driverAssignedAt;

    private LocalDateTime startedAt;

    private LocalDateTime completedAt;

    private LocalDateTime createdAt;

    private LocalDateTime updatedAt;

    @PrePersist
    protected void onCreate() {
        createdAt = LocalDateTime.now();
        updatedAt = LocalDateTime.now();
        if (status == null) {
            status = RideStatus.INITIAL;
        }
        if (rideType == null) {
            rideType = RideType.TRANSPORT;
        }
        if (paymentMethod == null) {
            paymentMethod = PaymentMethod.WALLET;
        }
    }

    @PreUpdate
    protected void onUpdate() {
        updatedAt = LocalDateTime.now();
    }

    public void startSearching() {
        this.isSearching = true;
        this.status = RideStatus.SEARCHING;
        this.requestedAt = LocalDateTime.now();
    }

    public void offersReceived() {
        this.offersReceived = true;
        this.status = RideStatus.OFFERS_RECEIVED;
    }

    public void assignDriver(Driver driver) {
        this.driver = driver;
        this.status = RideStatus.DRIVER_ASSIGNED;
        this.driverAssignedAt = LocalDateTime.now();
        this.isSearching = false;
    }

    public void startRide() {
        this.status = RideStatus.IN_PROGRESS;
        this.startedAt = LocalDateTime.now();
    }

    public void pickingUp() {
        this.status = RideStatus.PICKING_UP;
    }

    public void startRiding() {
        this.status = RideStatus.RIDING;
    }

    public void complete() {
        this.status = RideStatus.COMPLETED;
        this.completedAt = LocalDateTime.now();
        this.isSearching = false;
    }

    public void cancel(String reason) {
        this.status = RideStatus.CANCELLED;
        this.cancellationReason = reason;
        this.isSearching = false;
    }

    public void setNoDriversFound() {
        this.status = RideStatus.NO_DRIVERS_FOUND;
        this.errorMessage = "No drivers available in your area";
        this.isSearching = false;
    }
}
