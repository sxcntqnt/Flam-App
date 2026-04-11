package com.rideapp.dezole.model.entity;

import com.rideapp.dezole.model.enums.TransportType;
import jakarta.persistence.*;
import lombok.*;

import java.time.LocalDateTime;

@Entity
@Table(name = "drivers")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Driver {
    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    private String id;

    @OneToOne
    @JoinColumn(name = "user_id", nullable = false)
    private User user;

    private String vehicleModel;

    private String vehicleNumber;

    private String vehicleImage;

    @Enumerated(EnumType.STRING)
    private TransportType transportType;

    private boolean isAvailable = true;

    private Double currentLatitude;

    private Double currentLongitude;

    private Double rating = 5.0;

    private int totalRatings = 0;

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
}
