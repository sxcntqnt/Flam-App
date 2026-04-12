package com.rideapp.dezole.model.dto.response;

import com.rideapp.dezole.model.enums.AuthStatus;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class AuthStateResponse {
    private AuthStatus status;
    private String token;
    private String userId;
    private String email;
    private String role;
    private String errorMessage;
    
    // Organization support for dezole-org
    private String orgId;
    private String orgName;
    private Boolean isOrganizationAdmin;
    
    // Driver support for dezole-crew
    private String driverId;
    private Boolean isDriver;
    private Boolean isAvailable;
    
    // Customer support for dezole-opp
    private String profileImage;
    private String phone;
}