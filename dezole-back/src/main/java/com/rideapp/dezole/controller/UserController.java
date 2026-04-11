package com.rideapp.dezole.controller;

import com.rideapp.dezole.dto.RegisterRequest;
import com.rideapp.dezole.model.entity.User;
import com.rideapp.dezole.service.UserService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/users")
@RequiredArgsConstructor
public class UserController {

    private final UserService userService;

    @GetMapping("/me")
    public ResponseEntity<User> getCurrentUser() {
        String email = getCurrentUserEmail();
        return ResponseEntity.ok(userService.getCurrentUser(email));
    }

    @PutMapping("/me")
    public ResponseEntity<User> updateUser(@Valid @RequestBody RegisterRequest request) {
        String email = getCurrentUserEmail();
        return ResponseEntity.ok(userService.updateUser(email, request));
    }

    @DeleteMapping("/me")
    public ResponseEntity<Void> deleteUser() {
        String email = getCurrentUserEmail();
        userService.deleteUser(email);
        return ResponseEntity.noContent().build();
    }

    @PostMapping("/me/change-password")
    public ResponseEntity<Void> changePassword(@RequestParam String currentPassword, @RequestParam String newPassword) {
        String email = getCurrentUserEmail();
        userService.changePassword(email, currentPassword, newPassword);
        return ResponseEntity.ok().build();
    }

    private String getCurrentUserEmail() {
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        return auth.getName();
    }
}