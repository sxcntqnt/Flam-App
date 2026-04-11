package com.rideapp.dezole.model.dto.response;

import com.rideapp.dezole.model.enums.Role;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class UserResponse {
    private String id;
    private String email;
    private String firstName;
    private String lastName;
    private String phone;
    private String profileImage;
    private Role role;
    private String fullName;
    private Boolean isEmailVerified;
    private Boolean isPhoneVerified;
    private Boolean isActive;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;

    public UserResponse withUpdatedProfile(String firstName, String lastName, String phone, String profileImage) {
        return UserResponse.builder()
                .id(this.id)
                .email(this.email)
                .firstName(firstName != null ? firstName : this.firstName)
                .lastName(lastName != null ? lastName : this.lastName)
                .phone(phone != null ? phone : this.phone)
                .profileImage(profileImage != null ? profileImage : this.profileImage)
                .role(this.role)
                .fullName((firstName != null ? firstName : this.firstName) + " " + (lastName != null ? lastName : this.lastName))
                .isEmailVerified(this.isEmailVerified)
                .isPhoneVerified(this.isPhoneVerified)
                .isActive(this.isActive)
                .createdAt(this.createdAt)
                .updatedAt(LocalDateTime.now())
                .build();
    }
}
