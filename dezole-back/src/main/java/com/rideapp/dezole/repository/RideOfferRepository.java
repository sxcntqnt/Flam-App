package com.rideapp.dezole.repository;

import com.rideapp.dezole.model.entity.RideOffer;
import com.rideapp.dezole.model.entity.Ride;
import com.rideapp.dezole.model.enums.RideStatus;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.time.LocalDateTime;
import java.util.List;

@Repository
public interface RideOfferRepository extends JpaRepository<RideOffer, String> {
    List<RideOffer> findByRideId(String rideId);
    
    List<RideOffer> findByDriverId(String driverId);
    
    List<RideOffer> findByRideIdAndIsExpiredFalse(String rideId);
    
    List<RideOffer> findByStatus(RideStatus status);
    
    @Query("SELECT ro FROM RideOffer ro WHERE ro.ride.id = :rideId AND ro.isExpired = false AND ro.expiresAt > :now")
    List<RideOffer> findActiveOffersByRideId(@Param("rideId") String rideId, @Param("now") LocalDateTime now);
    
    @Query("SELECT COUNT(ro) FROM RideOffer ro WHERE ro.ride.id = :rideId AND ro.isExpired = false")
    long countActiveOffersByRideId(@Param("rideId") String rideId);
    
    void deleteByRideId(String rideId);
}
