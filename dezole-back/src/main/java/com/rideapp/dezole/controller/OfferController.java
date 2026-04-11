package com.rideapp.dezole.controller;

import com.rideapp.dezole.model.entity.Offer;
import com.rideapp.dezole.service.OfferService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/offers")
@RequiredArgsConstructor
public class OfferController {

    private final OfferService offerService;

    @GetMapping
    public ResponseEntity<List<Offer>> getActiveOffers() {
        return ResponseEntity.ok(offerService.getActiveOffers());
    }

    @PostMapping("/validate")
    public ResponseEntity<Map<String, Object>> validateOfferCode(@RequestBody Map<String, Object> request) {
        String code = (String) request.get("code");
        Double amount = request.get("amount") != null ? ((Number) request.get("amount")).doubleValue() : 0.0;
        
        return offerService.validateOfferCode(code, amount)
                .map(offer -> {
                    double discount = amount * offer.getDiscountPercent() / 100.0;
                    return ResponseEntity.ok(Map.of(
                            "valid", true,
                            "offer", offer,
                            "discount", discount,
                            "finalAmount", amount - discount
                    ));
                })
                .orElse(ResponseEntity.ok(Map.of("valid", false, "message", "Invalid or expired offer code")));
    }

    @PostMapping
    public ResponseEntity<Offer> createOffer(@RequestBody Offer offer) {
        return ResponseEntity.ok(offerService.createOffer(offer));
    }
}
