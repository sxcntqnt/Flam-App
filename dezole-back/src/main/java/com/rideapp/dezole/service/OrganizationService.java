package com.rideapp.dezole.service;

import com.rideapp.dezole.model.dto.response.AuthStateResponse;
import com.rideapp.dezole.model.entity.Organization;
import com.rideapp.dezole.model.entity.User;
import com.rideapp.dezole.model.enums.AuthStatus;
import com.rideapp.dezole.model.enums.Role;
import com.rideapp.dezole.repository.OrganizationRepository;
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
public class OrganizationService {

    private final OrganizationRepository organizationRepository;
    private final UserRepository userRepository;
    private final WalletRepository walletRepository;
    private final PasswordEncoder passwordEncoder;
    private final JwtService jwtService;
    private final AuthenticationManager authenticationManager;

    @Transactional
    public AuthStateResponse registerOrganization(String email, String password, String orgName, String phone) {
        try {
            if (userRepository.existsByEmail(email)) {
                return AuthStateResponse.builder()
                        .status(AuthStatus.ERROR)
                        .errorMessage("Email already exists")
                        .build();
            }

            User user = User.builder()
                    .email(email)
                    .password(passwordEncoder.encode(password))
                    .phone(phone)
                    .role(Role.ADMIN)
                    .build();

            user = userRepository.save(user);

            Organization org = Organization.builder()
                    .name(orgName)
                    .admin(user)
                    .role(Role.ADMIN)
                    .isActive(true)
                    .build();

            org = organizationRepository.save(org);

            String token = jwtService.generateToken(user);

            return AuthStateResponse.builder()
                    .status(AuthStatus.AUTHENTICATED)
                    .token(token)
                    .userId(user.getId())
                    .email(user.getEmail())
                    .role(user.getRole().name())
                    .orgId(org.getId())
                    .orgName(org.getName())
                    .isOrganizationAdmin(true)
                    .build();
        } catch (Exception e) {
            return AuthStateResponse.builder()
                    .status(AuthStatus.ERROR)
                    .errorMessage(e.getMessage())
                    .build();
        }
    }

    public AuthStateResponse login(String email, String password) {
        try {
            Authentication authentication = authenticationManager.authenticate(
                    new UsernamePasswordAuthenticationToken(email, password)
            );

            User user = (User) authentication.getPrincipal();
            
            Organization org = organizationRepository.findByAdminId(user.getId())
                    .orElse(null);

            String token = jwtService.generateToken(user);

            return AuthStateResponse.builder()
                    .status(AuthStatus.AUTHENTICATED)
                    .token(token)
                    .userId(user.getId())
                    .email(user.getEmail())
                    .role(user.getRole().name())
                    .orgId(org != null ? org.getId() : null)
                    .orgName(org != null ? org.getName() : null)
                    .isOrganizationAdmin(user.getRole() == Role.ADMIN)
                    .build();
        } catch (Exception e) {
            return AuthStateResponse.builder()
                    .status(AuthStatus.ERROR)
                    .errorMessage("Invalid credentials")
                    .build();
        }
    }

    public Organization getOrganization(String orgId) {
        return organizationRepository.findById(orgId)
                .orElseThrow(() -> new RuntimeException("Organization not found"));
    }

    public Organization getOrganizationByAdmin(String adminId) {
        return organizationRepository.findByAdminId(adminId)
                .orElseThrow(() -> new RuntimeException("Organization not found"));
    }

    @Transactional
    public Organization updateOrganization(String orgId, String name, String description, String phone) {
        Organization org = organizationRepository.findById(orgId)
                .orElseThrow(() -> new RuntimeException("Organization not found"));

        if (name != null) org.setName(name);
        if (description != null) org.setDescription(description);
        if (phone != null) org.setPhone(phone);

        return organizationRepository.save(org);
    }
}