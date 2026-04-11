package com.rideapp.dezole.repository;

import com.rideapp.dezole.model.entity.Driver;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface DriverRepository extends JpaRepository<Driver, String> {
    Optional<Driver> findByUserId(String userId);
    
    List<Driver> findByIsAvailableTrue();
    
    @Query("SELECT d FROM Driver d WHERE d.isAvailable = true " +
           "AND d.currentLatitude IS NOT NULL " +
           "AND d.currentLongitude IS NOT NULL")
    List<Driver> findAvailableDriversWithLocation();
    
    @Query(value = "SELECT * FROM drivers d " +
           "WHERE d.is_available = true " +
           "AND d.current_latitude IS NOT NULL " +
           "AND d.current_longitude IS NOT NULL " +
           "ORDER BY SQRT(POWER(d.current_latitude - :lat, 2) + POWER(d.current_longitude - :lng, 2)) " +
           "LIMIT :limit", nativeQuery = true)
    List<Driver> findNearestDrivers(@Param("lat") Double latitude, 
                                     @Param("lng") Double longitude, 
                                     @Param("limit") int limit);
}
