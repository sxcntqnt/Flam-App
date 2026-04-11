package com.rideapp.dezole.repository;

import com.rideapp.dezole.model.entity.PaymentMethodConfig;
import com.rideapp.dezole.model.enums.PaymentMethod;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface PaymentMethodConfigRepository extends JpaRepository<PaymentMethodConfig, Long> {
    List<PaymentMethodConfig> findByWalletId(Long walletId);
    
    Optional<PaymentMethodConfig> findByWalletIdAndMethod(Long walletId, PaymentMethod method);
    
    Optional<PaymentMethodConfig> findByWalletIdAndIsDefaultTrue(Long walletId);
    
    void deleteByWalletId(Long walletId);
}
