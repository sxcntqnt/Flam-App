package com.rideapp.dezole.repository;

import com.rideapp.dezole.model.entity.Wallet;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
public interface WalletRepository extends JpaRepository<Wallet, Long> {
    Optional<Wallet> findByUserId(String userId);
    Optional<Wallet> findByUserEmail(String email);
}
