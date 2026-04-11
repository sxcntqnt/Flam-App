package com.rideapp.dezole.controller;

import com.rideapp.dezole.model.entity.Referral;
import com.rideapp.dezole.service.ReferralService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.bind.annotation.*;

import java.util.Map;

@RestController
@RequestMapping("/api/referrals")
@RequiredArgsConstructor
public class ReferralController {

    private final ReferralService referralService;

    @GetMapping("/my-code")
    public ResponseEntity<Referral> getMyReferralCode() {
        String userId = getCurrentUserId();
        return ResponseEntity.ok(referralService.getUserReferral(userId));
    }

    @PostMapping("/apply")
    public ResponseEntity<Referral> applyReferralCode(@RequestBody Map<String, String> request) {
        String userId = getCurrentUserId();
        String code = request.get("code");
        return ResponseEntity.ok(referralService.applyReferralCode(userId, code));
    }

    @GetMapping("/stats")
    public ResponseEntity<Map<String, Object>> getReferralStats() {
        String userId = getCurrentUserId();
        return ResponseEntity.ok(referralService.getReferralStats(userId));
    }

    private String getCurrentUserId() {
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        return auth.getName();
    }
}
