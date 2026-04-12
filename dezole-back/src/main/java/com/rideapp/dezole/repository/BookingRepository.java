package com.rideapp.dezole.repository;

import com.rideapp.dezole.model.entity.Booking;
import com.rideapp.dezole.model.enums.BookingStatus;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.time.LocalDate;
import java.util.List;
import java.util.Optional;

@Repository
public interface BookingRepository extends JpaRepository<Booking, String> {
    List<Booking> findByUserId(String userId);
    List<Booking> findByUserIdOrderByCreatedAtDesc(String userId);
    List<Booking> findByStatus(BookingStatus status);
    Optional<Booking> findByTransactionId(String transactionId);
    List<Booking> findByScheduleIdAndDepartureDate(String scheduleId, LocalDate departureDate);
}