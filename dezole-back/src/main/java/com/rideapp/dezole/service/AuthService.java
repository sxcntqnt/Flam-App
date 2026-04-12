package com.rideapp.dezole.service;

import com.rideapp.dezole.dto.DriverRegisterRequest;
import com.rideapp.dezole.dto.LoginRequest;
import com.rideapp.dezole.dto.RegisterRequest;
import com.rideapp.dezole.model.dto.response.AuthStateResponse;
import com.rideapp.dezole.model.entity.Driver;
import com.rideapp.dezole.model.entity.User;
import com.rideapp.dezole.model.entity.Wallet;
import com.rideapp.dezole.model.enums.AuthStatus;
import com.rideapp.dezole.model.enums.Role;
import com.rideapp.dezole.repository.DriverRepository;
import com.rideapp.dezole.repository.UserRepository;
import com.rideapp.dezole.repository.WalletRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
@RequiredArgsConstructor
public class AuthService {

    private final UserRepository userRepository;
    private final WalletRepository walletRepository;
    private final DriverRepository driverRepository;
    private final PasswordEncoder passwordEncoder;
    private final JwtService jwtService;
    private final AuthenticationManager authenticationManager;

    @Transactional
    public AuthStateResponse register(RegisterRequest request) {
        try {
            if (userRepository.existsByEmail(request.getEmail())) {
                return AuthStateResponse.builder()
                        .status(AuthStatus.ERROR)
                        .errorMessage("Email already exists")
                        .build();
            }

            User user = User.builder()
                    .email(request.getEmail())
                    .password(passwordEncoder.encode(request.getPassword()))
                    .firstName(request.getFirstName())
                    .lastName(request.getLastName())
                    .phone(request.getPhone())
                    .profileImage(request.getProfileImage())
                    .role(Role.CUSTOMER)
                    .build();

            user = userRepository.save(user);

            Wallet wallet = Wallet.builder()
                    .user(user)
                    .balance(0.0)
                    .build();
            walletRepository.save(wallet);

            String token = jwtService.generateToken(user);

            return AuthStateResponse.builder()
                    .status(AuthStatus.AUTHENTICATED)
                    .token(token)
                    .userId(user.getId())
                    .email(user.getEmail())
                    .role(user.getRole().name())
                    .profileImage(user.getProfileImage())
                    .phone(user.getPhone())
                    .build();
        } catch (Exception e) {
            return AuthStateResponse.builder()
                    .status(AuthStatus.ERROR)
                    .errorMessage(e.getMessage())
                    .build();
        }
    }

    public AuthStateResponse login(LoginRequest request) {
        try {
            Authentication authentication = authenticationManager.authenticate(
                    new UsernamePasswordAuthenticationToken(request.getEmail(), request.getPassword())
            );

            User user = (User) authentication.getPrincipal();
            String token = jwtService.generateToken(user);

            return AuthStateResponse.builder()
                    .status(AuthStatus.AUTHENTICATED)
                    .token(token)
                    .userId(user.getId())
                    .email(user.getEmail())
                    .role(user.getRole().name())
                    .isDriver(user.getRole() == Role.DRIVER)
                    .driverId(user.getDriverId())
                    .isAvailable(user.getIsAvailable())
                    .profileImage(user.getProfileImage())
                    .phone(user.getPhone())
                    .orgId(user.getOrgId())
                    .build();
        } catch (Exception e) {
            return AuthStateResponse.builder()
                    .status(AuthStatus.ERROR)
                    .errorMessage("Invalid email or password")
                    .build();
        }
    }

    @Transactional
    public AuthStateResponse registerAsDriver(String userId, DriverRegisterRequest request) {
        try {
            User user = userRepository.findById(userId)
                    .orElseThrow(() -> new RuntimeException("User not found"));

            user.setRole(Role.DRIVER);
            user = userRepository.save(user);

            Driver driver = Driver.builder()
                    .user(user)
                    .vehicleModel(request.getVehicleModel())
                    .vehicleNumber(request.getVehicleNumber())
                    .vehicleImage(request.getVehicleImage())
                    .transportType(request.getTransportType())
                    .isAvailable(true)
                    .rating(5.0)
                    .totalRatings(0)
                    .build();

            driver = driverRepository.save(driver);

            user.setDriverId(driver.getId());
            userRepository.save(user);

            String token = jwtService.generateToken(user);

            return AuthStateResponse.builder()
                    .status(AuthStatus.AUTHENTICATED)
                    .token(token)
                    .userId(user.getId())
                    .email(user.getEmail())
                    .role(user.getRole().name())
                    .isDriver(true)
                    .driverId(driver.getId())
                    .isAvailable(true)
                    .build();
        } catch (Exception e) {
            return AuthStateResponse.builder()
                    .status(AuthStatus.ERROR)
                    .errorMessage(e.getMessage())
                    .build();
        }
    }

    public AuthStateResponse getAuthState(String email) {
        try {
            User user = userRepository.findByEmail(email)
                    .orElseThrow(() -> new RuntimeException("User not found"));

            String token = jwtService.generateToken(user);

            return AuthStateResponse.builder()
                    .status(AuthStatus.AUTHENTICATED)
                    .token(token)
                    .userId(user.getId())
                    .email(user.getEmail())
                    .role(user.getRole().name())
                    .isDriver(user.getRole() == Role.DRIVER)
                    .driverId(user.getDriverId())
                    .isAvailable(user.getIsAvailable())
                    .profileImage(user.getProfileImage())
                    .phone(user.getPhone())
                    .orgId(user.getOrgId())
                    .build();
        } catch (Exception e) {
            return AuthStateResponse.builder()
                    .status(AuthStatus.UNAUTHENTICATED)
                    .errorMessage(e.getMessage())
                    .build();
        }
    }

    public AuthStateResponse getInitialState() {
        return AuthStateResponse.builder()
                .status(AuthStatus.INITIAL)
                .build();
    }
}