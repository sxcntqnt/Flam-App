package com.rideapp.dezole.controller;

import com.rideapp.dezole.model.dto.response.AuthStateResponse;
import com.rideapp.dezole.model.entity.Organization;
import com.rideapp.dezole.service.OrganizationService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.bind.annotation.*;

import java.util.Map;

@RestController
@RequestMapping("/api/organizations")
@RequiredArgsConstructor
public class OrganizationController {

    private final OrganizationService organizationService;

    @PostMapping("/register")
    public ResponseEntity<AuthStateResponse> registerOrganization(
            @Valid @RequestBody Map<String, String> request) {
        String email = request.get("email");
        String password = request.get("password");
        String orgName = request.get("orgName");
        String phone = request.get("phone");

        return ResponseEntity.status(HttpStatus.CREATED)
                .body(organizationService.registerOrganization(email, password, orgName, phone));
    }

    @PostMapping("/login")
    public ResponseEntity<AuthStateResponse> login(@Valid @RequestBody Map<String, String> request) {
        String email = request.get("email");
        String password = request.get("password");

        return ResponseEntity.ok(organizationService.login(email, password));
    }

    @GetMapping("/me")
    public ResponseEntity<Organization> getMyOrganization() {
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        String email = auth.getName();

        Organization org = organizationService.getOrganizationByAdmin(email);
        return ResponseEntity.ok(org);
    }

    @PutMapping("/me")
    public ResponseEntity<Organization> updateOrganization(@RequestBody Map<String, String> request) {
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        String email = auth.getName();

        Organization org = organizationService.getOrganizationByAdmin(email);

        String name = request.get("name");
        String description = request.get("description");
        String phone = request.get("phone");

        return ResponseEntity.ok(organizationService.updateOrganization(
                org.getId(), name, description, phone));
    }
}