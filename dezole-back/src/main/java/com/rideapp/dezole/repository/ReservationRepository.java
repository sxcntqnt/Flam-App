package com.rideapp.dezole.repository;

import com.rideapp.dezole.model.entity.Reservation;
import com.rideapp.dezole.model.enums.ReservationStatus;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.time.LocalDate;
import java.util.List;

@Repository
public interface ReservationRepository extends JpaRepository<Reservation, Long> {
    List<Reservation> findByCustomerId(String customerId);
    List<Reservation> findByScheduleId(Long scheduleId);
    List<Reservation> findByDepartureDate(LocalDate departureDate);
    List<Reservation> findByScheduleIdAndDepartureDate(Long scheduleId, LocalDate departureDate);
    List<Reservation> findByCustomerIdOrderByCreatedAtDesc(String customerId);
    
    @Query("SELECT r FROM Reservation r WHERE r.schedule.id = :scheduleId AND r.departureDate = :date AND r.status != 'CANCELLED'")
    List<Reservation> findActiveReservationsByScheduleAndDate(@Param("scheduleId") Long scheduleId, @Param("date") LocalDate date);
    
    @Query("SELECT r.seatNumbers FROM Reservation r WHERE r.schedule.id = :scheduleId AND r.departureDate = :date AND r.status != 'CANCELLED'")
    List<String> findBookedSeatsByScheduleAndDate(@Param("scheduleId") Long scheduleId, @Param("date") LocalDate date);
}
