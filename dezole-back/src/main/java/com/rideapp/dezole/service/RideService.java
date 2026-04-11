package com.rideapp.dezole.service;

import com.rideapp.dezole.dto.RideRequest;
import com.rideapp.dezole.model.dto.response.RideOfferResponse;
import com.rideapp.dezole.model.dto.response.RideStateResponse;
import com.rideapp.dezole.model.entity.Driver;
import com.rideapp.dezole.model.entity.Ride;
import com.rideapp.dezole.model.entity.RideOffer;
import com.rideapp.dezole.model.entity.User;
import com.rideapp.dezole.model.enums.PaymentMethod;
import com.rideapp.dezole.model.enums.RideStatus;
import com.rideapp.dezole.model.enums.RideType;
import com.rideapp.dezole.repository.DriverRepository;
import com.rideapp.dezole.repository.RideOfferRepository;
import com.rideapp.dezole.repository.RideRepository;
import com.rideapp.dezole.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.List;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class RideService {

    private final RideRepository rideRepository;
    private final RideOfferRepository rideOfferRepository;
    private final UserRepository userRepository;
    private final DriverRepository driverRepository;

    @Transactional
    public RideStateResponse createRideRequest(String passengerEmail, RideRequest request) {
        User passenger = userRepository.findByEmail(passengerEmail)
                .orElseThrow(() -> new RuntimeException("User not found"));

        Ride ride = Ride.builder()
                .passenger(passenger)
                .rideType(request.getRideType() != null ? request.getRideType() : RideType.TRANSPORT)
                .transportType(request.getTransportType())
                .fromAddress(request.getFromAddress())
                .fromLatitude(request.getFromLatitude())
                .fromLongitude(request.getFromLongitude())
                .toAddress(request.getToAddress())
                .toLatitude(request.getToLatitude())
                .toLongitude(request.getToLongitude())
                .estimatedFare(request.getEstimatedFare())
                .distanceKm(request.getDistanceKm())
                .estimatedDurationMinutes(request.getEstimatedDurationMinutes())
                .paymentMethod(request.getPaymentMethod() != null ? request.getPaymentMethod() : PaymentMethod.WALLET)
                .status(RideStatus.INITIAL)
                .isSearching(false)
                .offersReceived(false)
                .build();

        ride = rideRepository.save(ride);
        return mapToRideStateResponse(ride);
    }

    @Transactional
    public RideStateResponse startSearching(String rideId) {
        Ride ride = rideRepository.findById(rideId)
                .orElseThrow(() -> new RuntimeException("Ride not found"));

        ride.startSearching();
        ride = rideRepository.save(ride);
        return mapToRideStateResponse(ride);
    }

    @Transactional
    public RideStateResponse stopSearching(String rideId) {
        Ride ride = rideRepository.findById(rideId)
                .orElseThrow(() -> new RuntimeException("Ride not found"));

        ride.setIsSearching(false);
        ride = rideRepository.save(ride);
        return mapToRideStateResponse(ride);
    }

    @Transactional
    public RideStateResponse receiveOffers(String rideId) {
        Ride ride = rideRepository.findById(rideId)
                .orElseThrow(() -> new RuntimeException("Ride not found"));

        ride.offersReceived();
        ride = rideRepository.save(ride);
        return mapToRideStateResponse(ride);
    }

    @Transactional
    public RideStateResponse acceptOffer(String rideId, String offerId) {
        Ride ride = rideRepository.findById(rideId)
                .orElseThrow(() -> new RuntimeException("Ride not found"));

        RideOffer offer = rideOfferRepository.findById(offerId)
                .orElseThrow(() -> new RuntimeException("Offer not found"));

        if (!offer.getRide().getId().equals(rideId)) {
            throw new RuntimeException("Offer does not belong to this ride");
        }

        offer.accept();
        rideOfferRepository.save(offer);

        ride.assignDriver(offer.getDriver());
        ride.setSelectedOfferId(offerId);
        ride.setEstimatedFare(offer.getOfferedFare());
        ride = rideRepository.save(ride);

        return mapToRideStateResponse(ride);
    }

    @Transactional
    public RideStateResponse declineOffers(String rideId) {
        List<RideOffer> offers = rideOfferRepository.findByRideIdAndIsExpiredFalse(rideId);
        offers.forEach(offer -> {
            offer.expire();
            rideOfferRepository.save(offer);
        });

        Ride ride = rideRepository.findById(rideId)
                .orElseThrow(() -> new RuntimeException("Ride not found"));
        ride.setIsSearching(true);
        ride.setOffersReceived(false);
        ride = rideRepository.save(ride);

        return mapToRideStateResponse(ride);
    }

    public RideStateResponse getRideById(String rideId) {
        Ride ride = rideRepository.findById(rideId)
                .orElseThrow(() -> new RuntimeException("Ride not found"));
        return mapToRideStateResponse(ride);
    }

    public List<RideStateResponse> getPassengerRides(String passengerEmail) {
        User passenger = userRepository.findByEmail(passengerEmail)
                .orElseThrow(() -> new RuntimeException("User not found"));
        
        return rideRepository.findByPassengerId(passenger.getId())
                .stream()
                .map(this::mapToRideStateResponse)
                .collect(Collectors.toList());
    }

    public List<RideStateResponse> getDriverRides(String driverEmail) {
        Driver driver = driverRepository.findByUserEmail(driverEmail)
                .orElseThrow(() -> new RuntimeException("Driver not found"));
        
        return rideRepository.findByDriverId(driver.getId())
                .stream()
                .map(this::mapToRideStateResponse)
                .collect(Collectors.toList());
    }

    public List<RideStateResponse> getActiveRides() {
        return rideRepository.findByStatusIn(List.of(
                RideStatus.SEARCHING,
                RideStatus.OFFERS_RECEIVED,
                RideStatus.DRIVER_ASSIGNED,
                RideStatus.PICKING_UP,
                RideStatus.IN_PROGRESS,
                RideStatus.RIDING
        )).stream()
          .map(this::mapToRideStateResponse)
          .collect(Collectors.toList());
    }

    public List<RideStateResponse> getAvailableRidesForDriver(String driverEmail) {
        Driver driver = driverRepository.findByUserEmail(driverEmail)
                .orElseThrow(() -> new RuntimeException("Driver not found"));

        List<Ride> rides = rideRepository.findByStatusIn(List.of(
                RideStatus.SEARCHING,
                RideStatus.OFFERS_RECEIVED
        ));

        return rides.stream()
                .filter(ride -> ride.getTransportType() == driver.getTransportType())
                .map(this::mapToRideStateResponse)
                .collect(Collectors.toList());
    }

    @Transactional
    public RideStateResponse updateRideStatus(String rideId, RideStatus status, String driverEmail) {
        Ride ride = rideRepository.findById(rideId)
                .orElseThrow(() -> new RuntimeException("Ride not found"));

        switch (status) {
            case PICKING_UP -> ride.pickingUp();
            case IN_PROGRESS -> ride.startRide();
            case RIDING -> ride.startRiding();
            case COMPLETED -> ride.complete();
            default -> ride.setStatus(status);
        }

        ride = rideRepository.save(ride);
        return mapToRideStateResponse(ride);
    }

    @Transactional
    public RideStateResponse assignDriver(String rideId, String driverEmail) {
        Ride ride = rideRepository.findById(rideId)
                .orElseThrow(() -> new RuntimeException("Ride not found"));

        Driver driver = driverRepository.findByUserEmail(driverEmail)
                .orElseThrow(() -> new RuntimeException("Driver not found"));

        ride.assignDriver(driver);
        ride = rideRepository.save(ride);
        return mapToRideStateResponse(ride);
    }

    @Transactional
    public RideStateResponse cancelRide(String rideId, String reason, String userEmail) {
        Ride ride = rideRepository.findById(rideId)
                .orElseThrow(() -> new RuntimeException("Ride not found"));

        ride.cancel(reason);
        ride = rideRepository.save(ride);
        return mapToRideStateResponse(ride);
    }

    @Transactional
    public RideStateResponse setNoDriversFound(String rideId) {
        Ride ride = rideRepository.findById(rideId)
                .orElseThrow(() -> new RuntimeException("Ride not found"));

        ride.setNoDriversFound();
        ride = rideRepository.save(ride);
        return mapToRideStateResponse(ride);
    }

    public List<RideOfferResponse> getRideOffers(String rideId) {
        return rideOfferRepository.findByRideId(rideId)
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

    private RideStateResponse mapToRideStateResponse(Ride ride) {
        long offersCount = rideOfferRepository.countActiveOffersByRideId(ride.getId());
        
        return RideStateResponse.builder()
                .id(ride.getId())
                .rideType(ride.getRideType())
                .transportType(ride.getTransportType())
                .fromAddress(ride.getFromAddress())
                .fromLatitude(ride.getFromLatitude())
                .fromLongitude(ride.getFromLongitude())
                .toAddress(ride.getToAddress())
                .toLatitude(ride.getToLatitude())
                .toLongitude(ride.getToLongitude())
                .status(ride.getStatus())
                .isSearching(ride.getIsSearching())
                .offersReceived(ride.getOffersReceived())
                .hasError(ride.getErrorMessage() != null)
                .errorMessage(ride.getErrorMessage())
                .selectedOfferId(ride.getSelectedOfferId())
                .offersCount((int) offersCount)
                .requestedAt(ride.getRequestedAt())
                .driverAssignedAt(ride.getDriverAssignedAt())
                .startedAt(ride.getStartedAt())
                .completedAt(ride.getCompletedAt())
                .build();
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
