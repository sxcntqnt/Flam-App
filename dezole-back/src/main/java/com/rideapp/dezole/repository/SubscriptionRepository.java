package com.rideapp.dezole.repository;

import com.rideapp.dezole.model.entity.Subscription;
import com.rideapp.dezole.model.enums.SubscriptionStatus;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface SubscriptionRepository extends JpaRepository<Subscription, Long> {
    List<Subscription> findByUserId(String userId);
    Optional<Subscription> findByUserIdAndStatus(String userId, SubscriptionStatus status);
}
