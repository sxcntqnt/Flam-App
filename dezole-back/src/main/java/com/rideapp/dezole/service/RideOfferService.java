package com.rideapp.dezole.service;

import com.rideapp.dezole.dto.OfferRideRequest;
import com.rideapp.dezole.model.dto.response.RideOfferResponse;
import com.rideapp.dezole.model.entity.Driver;
import com.rideapp.dezole.model.entity.Ride;
import com.rideapp.dezole.model.entity.RideOffer;
import com.rideapp.dezole.model.enums.RideStatus;
import com.rideapp.dezole.repository.DriverRepository;
import com.rideapp.dezole.repository.RideOfferRepository;
import com.rideapp.dezole.repository.RideRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.List;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class RideOfferService {

    private final RideOfferRepository rideOfferRepository;
    private final RideRepository rideRepository;
    private final DriverRepository driverRepository;

    @Transactional
    public RideOfferResponse createOffer(String driverEmail, OfferRideRequest request) {
        Driver driver = driverRepository.findByUserEmail(driverEmail)
                .orElseThrow(() -> new RuntimeException("Driver not found"));

        Ride ride = rideRepository.findById(request.getRideId())
                .orElseThrow(() -> new RuntimeException("Ride not found"));

        if (ride.getStatus() != RideStatus.SEARCHING && ride.getStatus() != RideStatus.OFFERS_RECEIVED) {
            throw new RuntimeException("Ride is not accepting offers");
        }

        RideOffer offer = RideOffer.builder()
                .ride(ride)
                .driver(driver)
                .offeredFare(request.getOfferedFare())
                .estimatedArrivalMinutes(request.getEstimatedArrivalMinutes())
                .message(request.getMessage())
                .status(RideStatus.OFFERS_RECEIVED)
                .isAccepted(false)
                .isExpired(false)
                .expiresAt(LocalDateTime.now().plusMinutes(2))
                .build();

        offer = rideOfferRepository.save(offer);

        if (ride.getStatus() == RideStatus.SEARCHING) {
            ride.offersReceived();
            rideRepository.save(ride);
        }

        return mapToRideOfferResponse(offer);
    }

    @Transactional
    public void cancelOffer(String offerId, String driverEmail) {
        RideOffer offer = rideOfferRepository.findById(offerId)
                .orElseThrow(() -> new RuntimeException("Offer not found"));

        Driver driver = driverRepository.findByUserEmail(driverEmail)
                .orElseThrow(() -> new RuntimeException("Driver not found"));

        if (!offer.getDriver().getId().equals(driver.getId())) {
            throw new RuntimeException("Offer does not belong to this driver");
        }

        offer.expire();
        rideOfferRepository.save(offer);
    }

    public List<RideOfferResponse> getOffersForRide(String rideId) {
        return rideOfferRepository.findActiveOffersByRideId(rideId, LocalDateTime.now())
                .stream()
                .map(this::mapToRideOfferResponse)
                .collect(Collectors.toList());
    }

    public List<RideOfferResponse> getDriverOffers(String driverEmail) {
        Driver driver = driverRepository.findByUserEmail(driverEmail)
                .orElseThrow(() -> new RuntimeException("Driver not found"));

        return rideOfferRepository.findByDriverId(driver.getId())
                .stream()
                .map(this::mapToRideOfferResponse)
                .collect(Collectors.toList());
    }

    @Transactional
    public void expireStaleOffers() {
        List<RideOffer> activeOffers = rideOfferRepository.findAll()
                .stream()
                .filter(offer -> !offer.isExpired() && offer.getExpiresAt().isBefore(LocalDateTime.now()))
                .collect(Collectors.toList());

        activeOffers.forEach(offer -> {
            offer.expire();
            rideOfferRepository.save(offer);
        });
    }

    private RideOfferResponse mapToRideOfferResponse(RideOffer offer) {
        Driver driver = offer.getDriver();
        return RideOfferResponse.builder()
                .id(offer.getId())
                .rideId(offer.getRide().getId())
                .driverId(driver.getId())
                .driverName(driver.getUser().getFirstName() + " " + driver.getUser().getLastName())
                .driverImage(driver.getUser().getProfileImage())
                .driverRating(driver.getRating())
                .vehicleModel(driver.getVehicleModel())
                .vehicleNumber(driver.getVehicleNumber())
                .offeredFare(offer.getOfferedFare())
                .estimatedArrivalMinutes(offer.getEstimatedArrivalMinutes())
                .driverLatitude(driver.getCurrentLatitude())
                .driverLongitude(driver.getCurrentLongitude())
                .message(offer.getMessage())
                .status(offer.getStatus())
                .isAccepted(offer.getIsAccepted())
                .isExpired(offer.isExpired())
                .expiresAt(offer.getExpiresAt())
                .createdAt(offer.getCreatedAt())
                .build();
    }
}
