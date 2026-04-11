package com.rideapp.dezole.service;

import com.rideapp.dezole.model.entity.Driver;
import com.rideapp.dezole.model.entity.User;
import com.rideapp.dezole.repository.DriverRepository;
import com.rideapp.dezole.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
@RequiredArgsConstructor
public class DriverService {

    private final DriverRepository driverRepository;
    private final UserRepository userRepository;

    public Driver getDriverByUserId(String userId) {
        return driverRepository.findByUserId(userId)
                .orElseThrow(() -> new RuntimeException("Driver not found"));
    }

    @Transactional
    public Driver updateLocation(String driverId, Double lat, Double lng) {
        Driver driver = driverRepository.findById(driverId)
                .orElseThrow(() -> new RuntimeException("Driver not found"));
        
        driver.setCurrentLatitude(lat);
        driver.setCurrentLongitude(lng);
        
        return driverRepository.save(driver);
    }

    @Transactional
    public Driver toggleAvailability(String driverId) {
        Driver driver = driverRepository.findById(driverId)
                .orElseThrow(() -> new RuntimeException("Driver not found"));
        
        driver.setAvailable(!driver.isAvailable());
        
        return driverRepository.save(driver);
    }

    public List<Driver> getNearestDrivers(Double lat, Double lng, int limit) {
        return driverRepository.findNearestDrivers(lat, lng, limit);
    }
}