package com.rideapp.dezole.controller;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.Map;

@RestController
@RequestMapping("/api")
public class HealthController {

    @GetMapping("/health")
    public ResponseEntity<Map<String, Object>> healthCheck() {
        Map<String, Object> response = new HashMap<>();
        response.put("status", "UP");
        response.put("timestamp", LocalDateTime.now());
        response.put("service", "dezole-back");
        return ResponseEntity.ok(response);
    }

    @GetMapping("/info")
    public ResponseEntity<Map<String, Object>> info() {
        Map<String, Object> response = new HashMap<>();
        response.put("name", "Dezole Ride App Backend");
        response.put("version", "1.0.0");
        response.put("description", "Spring Boot backend for the Dezole ride-sharing application");
        response.put("endpoints", getEndpoints());
        return ResponseEntity.ok(response);
    }

    private Map<String, String> getEndpoints() {
        Map<String, String> endpoints = new HashMap<>();
        endpoints.put("auth", "/api/auth/register, /api/auth/login, /api/auth/register-driver");
        endpoints.put("users", "/api/users/me");
        endpoints.put("drivers", "/api/drivers/*");
        endpoints.put("rides", "/api/rides/*");
        endpoints.put("routes", "/api/routes/*");
        endpoints.put("buses", "/api/buses/*");
        endpoints.put("schedules", "/api/schedules/*");
        endpoints.put("reservations", "/api/reservations/*");
        endpoints.put("wallet", "/api/wallet/*");
        endpoints.put("favorites", "/api/favorites/*");
        return endpoints;
    }
}
