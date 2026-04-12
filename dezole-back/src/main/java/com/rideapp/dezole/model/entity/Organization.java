package com.rideapp.dezole.model.entity;

import com.rideapp.dezole.model.enums.Role;
import jakarta.persistence.*;
import lombok.*;

import java.time.LocalDateTime;

@Entity
@Table(name = "organizations")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Organization {
    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    private String id;

    @Column(nullable = false)
    private String name;

    private String description;

    private String logoUrl;

    private String address;

    private String phone;

    private String email;

    @Enumerated(EnumType.STRING)
    private Role role;

    @ManyToOne
    @JoinColumn(name = "admin_id")
    private User admin;

    @Builder.Default
    private Boolean isActive = true;

    @Builder.Default
    private Integer memberCount = 0;

    @Builder.Default
    private Integer driverCount = 0;

    @Builder.Default
    private Integer vehicleCount = 0;

    private String location;

    private Double latitude;

    private Double longitude;

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