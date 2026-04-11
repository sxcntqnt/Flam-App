package com.rideapp.dezole.controller;

import com.rideapp.dezole.dto.LocationUpdateRequest;
import com.rideapp.dezole.model.entity.Driver;
import com.rideapp.dezole.model.entity.User;
import com.rideapp.dezole.service.DriverService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/drivers")
@RequiredArgsConstructor
public class DriverController {

    private final DriverService driverService;

    @GetMapping("/me")
    public ResponseEntity<Driver> getCurrentDriver() {
        String userId = getCurrentUserId();
        return ResponseEntity.ok(driverService.getDriverByUserId(userId));
    }

    @PutMapping("/location")
    public ResponseEntity<Driver> updateLocation(@Valid @RequestBody LocationUpdateRequest request) {
        String userId = getCurrentUserId();
        Driver driver = driverService.getDriverByUserId(userId);
        return ResponseEntity.ok(driverService.updateLocation(driver.getId(), request.getLat(), request.getLng()));
    }

    @PutMapping("/availability")
    public ResponseEntity<Driver> toggleAvailability() {
        String userId = getCurrentUserId();
        Driver driver = driverService.getDriverByUserId(userId);
        return ResponseEntity.ok(driverService.toggleAvailability(driver.getId()));
    }

    @GetMapping("/nearest")
    public ResponseEntity<List<Driver>> getNearestDrivers(
            @RequestParam Double lat,
            @RequestParam Double lng,
            @RequestParam(defaultValue = "5") int limit) {
        return ResponseEntity.ok(driverService.getNearestDrivers(lat, lng, limit));
    }

    private String getCurrentUserId() {
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        User user = (User) auth.getPrincipal();
        return user.getId();
    }
}