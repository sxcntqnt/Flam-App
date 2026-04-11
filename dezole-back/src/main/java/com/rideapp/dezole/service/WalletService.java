package com.rideapp.dezole.service;

import com.rideapp.dezole.model.dto.response.PaymentMethodResponse;
import com.rideapp.dezole.model.dto.response.TransactionResponse;
import com.rideapp.dezole.model.dto.response.WalletStateResponse;
import com.rideapp.dezole.model.entity.PaymentMethodConfig;
import com.rideapp.dezole.model.entity.Transaction;
import com.rideapp.dezole.model.entity.Wallet;
import com.rideapp.dezole.model.enums.PaymentMethod;
import com.rideapp.dezole.model.enums.TransactionType;
import com.rideapp.dezole.repository.PaymentMethodConfigRepository;
import com.rideapp.dezole.repository.TransactionRepository;
import com.rideapp.dezole.repository.WalletRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class WalletService {

    private final WalletRepository walletRepository;
    private final TransactionRepository transactionRepository;
    private final PaymentMethodConfigRepository paymentMethodConfigRepository;

    public WalletStateResponse getWalletState(String userEmail) {
        Wallet wallet = walletRepository.findByUserEmail(userEmail)
                .orElseThrow(() -> new RuntimeException("Wallet not found"));

        List<Transaction> recentTransactions = transactionRepository.findByWalletIdOrderByCreatedAtDesc(wallet.getId());
        List<PaymentMethodConfig> paymentMethods = paymentMethodConfigRepository.findByWalletId(wallet.getId());

        return WalletStateResponse.builder()
                .id(wallet.getId())
                .availableBalance(wallet.getBalance())
                .totalExpenditure(wallet.getTotalExpenditure())
                .selectedMethod(wallet.getSelectedPaymentMethod())
                .isLoading(false)
                .error(null)
                .recentTransactions(recentTransactions.stream()
                        .map(this::mapToTransactionResponse)
                        .collect(Collectors.toList()))
                .savedPaymentMethods(paymentMethods.stream()
                        .map(this::mapToPaymentMethodResponse)
                        .collect(Collectors.toList()))
                .build();
    }

    @Transactional
    public WalletStateResponse topup(String userEmail, Double amount) {
        Wallet wallet = walletRepository.findByUserEmail(userEmail)
                .orElseThrow(() -> new RuntimeException("Wallet not found"));

        Double balanceBefore = wallet.getBalance();
        wallet.credit(amount);
        wallet = walletRepository.save(wallet);

        Transaction transaction = Transaction.builder()
                .wallet(wallet)
                .type(TransactionType.TOP_UP)
                .amount(amount)
                .description("Wallet topup")
                .balanceBefore(balanceBefore)
                .balanceAfter(wallet.getBalance())
                .paymentMethod(PaymentMethod.WALLET)
                .isSuccessful(true)
                .build();
        transactionRepository.save(transaction);

        return getWalletState(userEmail);
    }

    @Transactional
    public WalletStateResponse addMoney(String userEmail, Double amount, PaymentMethod method) {
        Wallet wallet = walletRepository.findByUserEmail(userEmail)
                .orElseThrow(() -> new RuntimeException("Wallet not found"));

        Double balanceBefore = wallet.getBalance();
        wallet.credit(amount);
        wallet = walletRepository.save(wallet);

        Transaction transaction = Transaction.builder()
                .wallet(wallet)
                .type(TransactionType.TOP_UP)
                .amount(amount)
                .description("Add money via " + method.name())
                .balanceBefore(balanceBefore)
                .balanceAfter(wallet.getBalance())
                .paymentMethod(method)
                .isSuccessful(true)
                .build();
        transactionRepository.save(transaction);

        return getWalletState(userEmail);
    }

    @Transactional
    public WalletStateResponse deductMoney(String userEmail, Double amount, String rideId) {
        Wallet wallet = walletRepository.findByUserEmail(userEmail)
                .orElseThrow(() -> new RuntimeException("Wallet not found"));

        if (!wallet.hasSufficientBalance(amount)) {
            return WalletStateResponse.builder()
                    .id(wallet.getId())
                    .availableBalance(wallet.getBalance())
                    .totalExpenditure(wallet.getTotalExpenditure())
                    .selectedMethod(wallet.getSelectedPaymentMethod())
                    .isLoading(false)
                    .error("Insufficient balance")
                    .build();
        }

        Double balanceBefore = wallet.getBalance();
        wallet.debit(amount);
        wallet = walletRepository.save(wallet);

        Transaction transaction = Transaction.builder()
                .wallet(wallet)
                .type(TransactionType.PAYMENT)
                .amount(amount)
                .description("Ride payment")
                .balanceBefore(balanceBefore)
                .balanceAfter(wallet.getBalance())
                .paymentMethod(wallet.getSelectedPaymentMethod())
                .rideId(rideId)
                .isSuccessful(true)
                .build();
        transactionRepository.save(transaction);

        return getWalletState(userEmail);
    }

    @Transactional
    public WalletStateResponse selectPaymentMethod(String userEmail, PaymentMethod method) {
        Wallet wallet = walletRepository.findByUserEmail(userEmail)
                .orElseThrow(() -> new RuntimeException("Wallet not found"));

        wallet.setSelectedPaymentMethod(method);
        walletRepository.save(wallet);

        return getWalletState(userEmail);
    }

    public List<TransactionResponse> getTransactions(String userEmail) {
        Wallet wallet = walletRepository.findByUserEmail(userEmail)
                .orElseThrow(() -> new RuntimeException("Wallet not found"));

        return transactionRepository.findByWalletIdOrderByCreatedAtDesc(wallet.getId())
                .stream()
                .map(this::mapToTransactionResponse)
                .collect(Collectors.toList());
    }

    public Double getBalance(String userEmail) {
        Wallet wallet = walletRepository.findByUserEmail(userEmail)
                .orElseThrow(() -> new RuntimeException("Wallet not found"));
        return wallet.getBalance();
    }

    public boolean hasSufficientBalance(String userEmail, Double amount) {
        Wallet wallet = walletRepository.findByUserEmail(userEmail)
                .orElseThrow(() -> new RuntimeException("Wallet not found"));
        return wallet.hasSufficientBalance(amount);
    }

    private TransactionResponse mapToTransactionResponse(Transaction transaction) {
        return TransactionResponse.builder()
                .id(transaction.getId())
                .type(transaction.getType())
                .amount(transaction.getAmount())
                .description(transaction.getDescription())
                .balanceBefore(transaction.getBalanceBefore())
                .balanceAfter(transaction.getBalanceAfter())
                .paymentMethod(transaction.getPaymentMethod())
                .reference(transaction.getReference())
                .isSuccessful(transaction.getIsSuccessful())
                .createdAt(transaction.getCreatedAt())
                .build();
    }

    private PaymentMethodResponse mapToPaymentMethodResponse(PaymentMethodConfig config) {
        return PaymentMethodResponse.builder()
                .id(config.getId())
                .method(config.getMethod())
                .cardLastFour(config.getCardLastFour())
                .cardBrand(config.getCardBrand())
                .expiryDate(config.getExpiryDate())
                .isDefault(config.getIsDefault())
                .isVerified(config.getIsVerified())
                .build();
    }
}
