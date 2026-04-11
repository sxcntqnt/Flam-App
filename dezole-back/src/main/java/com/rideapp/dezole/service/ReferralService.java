package com.rideapp.dezole.service;

import com.rideapp.dezole.exception.ResourceNotFoundException;
import com.rideapp.dezole.model.entity.Referral;
import com.rideapp.dezole.model.entity.User;
import com.rideapp.dezole.repository.ReferralRepository;
import com.rideapp.dezole.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

@Service
@RequiredArgsConstructor
public class ReferralService {

    private final ReferralRepository referralRepository;
    private final UserRepository userRepository;

    public Referral getUserReferral(String userId) {
        List<Referral> referrals = referralRepository.findByReferrerId(userId);
        if (referrals.isEmpty()) {
            String code = generateReferralCode();
            User user = userRepository.findById(userId)
                    .orElseThrow(() -> new ResourceNotFoundException("User not found"));
            
            Referral referral = Referral.builder()
                    .referrer(user)
                    .referralCode(code)
                    .build();
            return referralRepository.save(referral);
        }
        return referrals.get(0);
    }

    @Transactional
    public Referral applyReferralCode(String userId, String code) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new ResourceNotFoundException("User not found"));

        if (referralRepository.findByReferredEmail(user.getEmail()).isPresent()) {
            throw new RuntimeException("You have already used a referral code");
        }

        Referral referral = referralRepository.findByReferralCode(code)
                .orElseThrow(() -> new ResourceNotFoundException("Invalid referral code"));

        if (referral.isUsed()) {
            throw new RuntimeException("Referral code already used");
        }

        referral.setReferredEmail(user.getEmail());
        referral.setUsed(true);
        referral.setUsedAt(LocalDateTime.now());

        return referralRepository.save(referral);
    }

    public Map<String, Object> getReferralStats(String userId) {
        List<Referral> referrals = referralRepository.findByReferrerId(userId);
        
        long totalReferrals = referrals.size();
        long usedReferrals = referrals.stream().filter(Referral::isUsed).count();
        
        Map<String, Object> stats = new HashMap<>();
        stats.put("totalReferrals", totalReferrals);
        stats.put("usedReferrals", usedReferrals);
        stats.put("pendingReferrals", totalReferrals - usedReferrals);
        
        return stats;
    }

    private String generateReferralCode() {
        return "REF-" + UUID.randomUUID().toString().substring(0, 8).toUpperCase();
    }
}
