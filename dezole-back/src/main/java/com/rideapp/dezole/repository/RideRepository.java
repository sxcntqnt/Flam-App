package com.rideapp.dezole.repository;

import com.rideapp.dezole.model.entity.Ride;
import com.rideapp.dezole.model.enums.RideStatus;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface RideRepository extends JpaRepository<Ride, String> {
    List<Ride> findByPassengerId(String passengerId);
    List<Ride> findByDriverId(String driverId);
    List<Ride> findByPassengerIdOrderByCreatedAtDesc(String passengerId);
    List<Ride> findByDriverIdOrderByCreatedAtDesc(String driverId);
    List<Ride> findByStatus(RideStatus status);
}
