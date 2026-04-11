package com.rideapp.dezole.service;

import com.rideapp.dezole.exception.ResourceNotFoundException;
import com.rideapp.dezole.model.entity.Offer;
import com.rideapp.dezole.repository.OfferRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDate;
import java.util.List;
import java.util.Optional;

@Service
@RequiredArgsConstructor
public class OfferService {

    private final OfferRepository offerRepository;

    public List<Offer> getActiveOffers() {
        return offerRepository.findByActiveTrueAndEndDateGreaterThanEqual(LocalDate.now());
    }

    @Transactional
    public Optional<Offer> validateOfferCode(String code, Double amount) {
        Optional<Offer> offerOpt = offerRepository.findByCode(code);
        
        if (offerOpt.isEmpty()) {
            return Optional.empty();
        }
        
        Offer offer = offerOpt.get();
        
        if (!offer.isActive()) {
            return Optional.empty();
        }
        
        if (offer.getEndDate() != null && offer.getEndDate().isBefore(LocalDate.now())) {
            return Optional.empty();
        }
        
        if (offer.getStartDate() != null && offer.getStartDate().isAfter(LocalDate.now())) {
            return Optional.empty();
        }
        
        if (offer.getMinimumAmount() != null && amount < offer.getMinimumAmount()) {
            return Optional.empty();
        }
        
        return offerOpt;
    }

    @Transactional
    public Offer createOffer(Offer offer) {
        return offerRepository.save(offer);
    }
}
