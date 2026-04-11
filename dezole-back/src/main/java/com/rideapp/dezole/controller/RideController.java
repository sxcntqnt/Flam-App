package com.rideapp.dezole.controller;

import com.rideapp.dezole.dto.OfferRideRequest;
import com.rideapp.dezole.dto.RideRequest;
import com.rideapp.dezole.dto.RideStatusUpdateRequest;
import com.rideapp.dezole.model.dto.response.RideOfferResponse;
import com.rideapp.dezole.model.dto.response.RideStateResponse;
import com.rideapp.dezole.model.enums.RideStatus;
import com.rideapp.dezole.service.RideOfferService;
import com.rideapp.dezole.service.RideService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/rides")
@RequiredArgsConstructor
public class RideController {

    private final RideService rideService;
    private final RideOfferService rideOfferService;

    @PostMapping
    public ResponseEntity<RideStateResponse> createRideRequest(@Valid @RequestBody RideRequest request) {
        String email = getCurrentUserEmail();
        return ResponseEntity.status(HttpStatus.CREATED).body(rideService.createRideRequest(email, request));
    }

    @PostMapping("/{id}/search")
    public ResponseEntity<RideStateResponse> startSearching(@PathVariable String id) {
        return ResponseEntity.ok(rideService.startSearching(id));
    }

    @PostMapping("/{id}/stop-search")
    public ResponseEntity<RideStateResponse> stopSearching(@PathVariable String id) {
        return ResponseEntity.ok(rideService.stopSearching(id));
    }

    @PostMapping("/{id}/accept-offer/{offerId}")
    public ResponseEntity<RideStateResponse> acceptOffer(@PathVariable String id, @PathVariable String offerId) {
        return ResponseEntity.ok(rideService.acceptOffer(id, offerId));
    }

    @PostMapping("/{id}/decline-offers")
    public ResponseEntity<RideStateResponse> declineOffers(@PathVariable String id) {
        return ResponseEntity.ok(rideService.declineOffers(id));
    }

    @PostMapping("/{id}/offers")
    public ResponseEntity<RideOfferResponse> createOffer(
            @PathVariable String id,
            @Valid @RequestBody OfferRideRequest request) {
        String email = getCurrentUserEmail();
        request.setRideId(id);
        return ResponseEntity.status(HttpStatus.CREATED).body(rideOfferService.createOffer(email, request));
    }

    @GetMapping("/{id}")
    public ResponseEntity<RideStateResponse> getRideById(@PathVariable String id) {
        return ResponseEntity.ok(rideService.getRideById(id));
    }

    @GetMapping("/{id}/offers")
    public ResponseEntity<List<RideOfferResponse>> getRideOffers(@PathVariable String id) {
        return ResponseEntity.ok(rideService.getRideOffers(id));
    }

    @GetMapping("/my-rides")
    public ResponseEntity<List<RideStateResponse>> getMyRides() {
        String email = getCurrentUserEmail();
        return ResponseEntity.ok(rideService.getPassengerRides(email));
    }

    @GetMapping("/driver/rides")
    public ResponseEntity<List<RideStateResponse>> getDriverRides() {
        String email = getCurrentUserEmail();
        return ResponseEntity.ok(rideService.getDriverRides(email));
    }

    @GetMapping("/available")
    public ResponseEntity<List<RideStateResponse>> getAvailableRides() {
        String email = getCurrentUserEmail();
        return ResponseEntity.ok(rideService.getAvailableRidesForDriver(email));
    }

    @GetMapping("/active")
    public ResponseEntity<List<RideStateResponse>> getActiveRides() {
        return ResponseEntity.ok(rideService.getActiveRides());
    }

    @PutMapping("/{id}/status")
    public ResponseEntity<RideStateResponse> updateRideStatus(
            @PathVariable String id,
            @Valid @RequestBody RideStatusUpdateRequest request) {
        String email = getCurrentUserEmail();
        return ResponseEntity.ok(rideService.updateRideStatus(id, request.getStatus(), email));
    }

    @PutMapping("/{id}/assign")
    public ResponseEntity<RideStateResponse> assignDriver(@PathVariable String id) {
        String email = getCurrentUserEmail();
        return ResponseEntity.ok(rideService.assignDriver(id, email));
    }

    @PostMapping("/{id}/cancel")
    public ResponseEntity<RideStateResponse> cancelRide(
            @PathVariable String id,
            @RequestParam(required = false) String reason) {
        String email = getCurrentUserEmail();
        return ResponseEntity.ok(rideService.cancelRide(id, reason, email));
    }

    @GetMapping("/driver/offers")
    public ResponseEntity<List<RideOfferResponse>> getDriverOffers() {
        String email = getCurrentUserEmail();
        return ResponseEntity.ok(rideOfferService.getDriverOffers(email));
    }

    @DeleteMapping("/offers/{offerId}")
    public ResponseEntity<Void> cancelOffer(@PathVariable String offerId) {
        String email = getCurrentUserEmail();
        rideOfferService.cancelOffer(offerId, email);
        return ResponseEntity.noContent().build();
    }

    private String getCurrentUserEmail() {
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        return auth.getName();
    }
}
