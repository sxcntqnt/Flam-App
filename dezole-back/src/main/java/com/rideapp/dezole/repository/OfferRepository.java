package com.rideapp.dezole.repository;

import com.rideapp.dezole.model.entity.Offer;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.time.LocalDate;
import java.util.List;
import java.util.Optional;

@Repository
public interface OfferRepository extends JpaRepository<Offer, Long> {
    List<Offer> findByActiveTrue();
    Optional<Offer> findByCode(String code);
    List<Offer> findByActiveTrueAndEndDateGreaterThanEqual(LocalDate date);
}
