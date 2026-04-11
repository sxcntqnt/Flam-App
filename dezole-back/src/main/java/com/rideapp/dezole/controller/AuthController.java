package com.rideapp.dezole.controller;

import com.rideapp.dezole.dto.DriverRegisterRequest;
import com.rideapp.dezole.dto.LoginRequest;
import com.rideapp.dezole.dto.RegisterRequest;
import com.rideapp.dezole.model.dto.response.AuthStateResponse;
import com.rideapp.dezole.service.AuthService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/auth")
@RequiredArgsConstructor
public class AuthController {

    private final AuthService authService;

    @GetMapping("/state")
    public ResponseEntity<AuthStateResponse> getAuthState() {
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        
        if (auth == null || !auth.isAuthenticated() || auth.getPrincipal().equals("anonymousUser")) {
            return ResponseEntity.ok(authService.getInitialState());
        }
        
        return ResponseEntity.ok(authService.getAuthState(auth.getName()));
    }

    @PostMapping("/register")
    public ResponseEntity<AuthStateResponse> register(@Valid @RequestBody RegisterRequest request) {
        return ResponseEntity.status(HttpStatus.CREATED).body(authService.register(request));
    }

    @PostMapping("/login")
    public ResponseEntity<AuthStateResponse> login(@Valid @RequestBody LoginRequest request) {
        return ResponseEntity.ok(authService.login(request));
    }

    @PostMapping("/register-driver")
    public ResponseEntity<AuthStateResponse> registerAsDriver(@Valid @RequestBody DriverRegisterRequest request) {
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        String userId = (String) auth.getPrincipal();
        return ResponseEntity.status(HttpStatus.CREATED).body(authService.registerAsDriver(userId, request));
    }

    @PostMapping("/logout")
    public ResponseEntity<AuthStateResponse> logout() {
        SecurityContextHolder.clearContext();
        return ResponseEntity.ok(AuthStateResponse.builder()
                .status(com.rideapp.dezole.model.enums.AuthStatus.UNAUTHENTICATED)
                .build());
    }
}
