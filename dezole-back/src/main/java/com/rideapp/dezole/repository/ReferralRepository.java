package com.rideapp.dezole.repository;

import com.rideapp.dezole.model.entity.Referral;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface ReferralRepository extends JpaRepository<Referral, Long> {
    List<Referral> findByReferrerId(String referrerId);
    Optional<Referral> findByReferralCode(String referralCode);
    Optional<Referral> findByReferredEmail(String referredEmail);
}
