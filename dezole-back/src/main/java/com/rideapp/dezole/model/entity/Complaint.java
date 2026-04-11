package com.rideapp.dezole.model.entity;

import com.rideapp.dezole.model.enums.ComplaintStatus;
import jakarta.persistence.*;
import lombok.*;

import java.time.LocalDateTime;

@Entity
@Table(name = "complaints")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Complaint {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne
    @JoinColumn(name = "user_id", nullable = false)
    private User user;

    private String topic;

    @Column(nullable = false, length = 1000)
    private String description;

    @Enumerated(EnumType.STRING)
    @Builder.Default
    private ComplaintStatus status = ComplaintStatus.PENDING;

    private String response;

    @Builder.Default
    private Boolean isSubmitting = false;

    @Builder.Default
    private Boolean isSubmitted = false;

    private String errorMessage;

    private String rideId;

    private String orderId;

    private LocalDateTime resolvedAt;

    private LocalDateTime createdAt;

    private LocalDateTime updatedAt;

    @PrePersist
    protected void onCreate() {
        createdAt = LocalDateTime.now();
        updatedAt = LocalDateTime.now();
        if (status == null) {
            status = ComplaintStatus.PENDING;
        }
    }

    @PreUpdate
    protected void onUpdate() {
        updatedAt = LocalDateTime.now();
    }

    public void markAsSubmitting() {
        this.isSubmitting = true;
        this.errorMessage = null;
    }

    public void markAsSubmitted() {
        this.isSubmitting = false;
        this.isSubmitted = true;
    }

    public void markAsFailed(String error) {
        this.isSubmitting = false;
        this.errorMessage = error;
    }

    public void resolve(String response) {
        this.response = response;
        this.status = ComplaintStatus.RESOLVED;
        this.resolvedAt = LocalDateTime.now();
    }
}
