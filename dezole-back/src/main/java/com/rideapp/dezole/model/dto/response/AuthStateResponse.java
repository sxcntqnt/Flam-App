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
}
