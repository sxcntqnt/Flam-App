package com.rideapp.dezole.controller;

import com.rideapp.dezole.model.entity.Subscription;
import com.rideapp.dezole.service.SubscriptionService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDate;
import java.util.Map;

@RestController
@RequestMapping("/api/subscriptions")
@RequiredArgsConstructor
public class SubscriptionController {

    private final SubscriptionService subscriptionService;

    @GetMapping("/my")
    public ResponseEntity<Subscription> getMySubscription() {
        String userId = getCurrentUserId();
        return subscriptionService.getUserSubscription(userId)
                .map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }

    @PostMapping
    public ResponseEntity<Subscription> createSubscription(@RequestBody Map<String, Object> request) {
        String userId = getCurrentUserId();
        String plan = (String) request.get("plan");
        Double price = ((Number) request.get("price")).doubleValue();
        LocalDate startDate = LocalDate.parse((String) request.get("startDate"));
        LocalDate endDate = LocalDate.parse((String) request.get("endDate"));
        
        return ResponseEntity.ok(subscriptionService.createSubscription(userId, plan, price, startDate, endDate));
    }

    @PutMapping("/cancel")
    public ResponseEntity<Void> cancelSubscription() {
        String userId = getCurrentUserId();
        subscriptionService.cancelSubscription(userId);
        return ResponseEntity.ok().build();
    }

    private String getCurrentUserId() {
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        return auth.getName();
    }
}
