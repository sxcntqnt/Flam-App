package com.rideapp.dezole.controller;

import com.rideapp.dezole.model.dto.response.TransactionResponse;
import com.rideapp.dezole.model.dto.response.WalletStateResponse;
import com.rideapp.dezole.model.enums.PaymentMethod;
import com.rideapp.dezole.service.WalletService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/wallet")
@RequiredArgsConstructor
public class WalletController {

    private final WalletService walletService;

    @GetMapping
    public ResponseEntity<WalletStateResponse> getWalletState() {
        String email = getCurrentUserEmail();
        return ResponseEntity.ok(walletService.getWalletState(email));
    }

    @PostMapping("/topup")
    public ResponseEntity<WalletStateResponse> topup(@RequestBody Map<String, Double> request) {
        String email = getCurrentUserEmail();
        Double amount = request.get("amount");
        return ResponseEntity.ok(walletService.topup(email, amount));
    }

    @PostMapping("/add-money")
    public ResponseEntity<WalletStateResponse> addMoney(
            @RequestBody Map<String, Object> request) {
        String email = getCurrentUserEmail();
        Double amount = ((Number) request.get("amount")).doubleValue();
        PaymentMethod method = PaymentMethod.valueOf((String) request.get("method"));
        return ResponseEntity.ok(walletService.addMoney(email, amount, method));
    }

    @PostMapping("/select-method")
    public ResponseEntity<WalletStateResponse> selectPaymentMethod(@RequestBody Map<String, String> request) {
        String email = getCurrentUserEmail();
        PaymentMethod method = PaymentMethod.valueOf(request.get("method"));
        return ResponseEntity.ok(walletService.selectPaymentMethod(email, method));
    }

    @GetMapping("/transactions")
    public ResponseEntity<List<TransactionResponse>> getTransactions() {
        String email = getCurrentUserEmail();
        return ResponseEntity.ok(walletService.getTransactions(email));
    }

    @GetMapping("/balance")
    public ResponseEntity<Map<String, Double>> getBalance() {
        String email = getCurrentUserEmail();
        return ResponseEntity.ok(Map.of("balance", walletService.getBalance(email)));
    }

    @GetMapping("/check-balance")
    public ResponseEntity<Map<String, Object>> checkBalance(@RequestParam Double amount) {
        String email = getCurrentUserEmail();
        boolean hasSufficient = walletService.hasSufficientBalance(email, amount);
        return ResponseEntity.ok(Map.of(
                "hasSufficientBalance", hasSufficient,
                "required", amount
        ));
    }

    private String getCurrentUserEmail() {
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        return auth.getName();
    }
}
