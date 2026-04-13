package com.rideapp.dezole.dto;

import jakarta.validation.ConstraintViolation;
import jakarta.validation.Validation;
import jakarta.validation.Validator;
import jakarta.validation.ValidatorFactory;
import org.junit.jupiter.api.BeforeAll;
import org.junit.jupiter.api.Test;

import java.util.Set;

import static org.junit.jupiter.api.Assertions.*;

class ValidationTest {

    private static Validator validator;

    @BeforeAll
    static void setUp() {
        ValidatorFactory factory = Validation.buildDefaultValidatorFactory();
        validator = factory.getValidator();
    }

    @Test
    void testRegisterRequest_ValidInput() {
        RegisterRequest request = new RegisterRequest();
        request.setEmail("test@example.com");
        request.setPassword("password123");
        request.setFirstName("John");
        request.setLastName("Doe");
        request.setPhone("+254700000000");

        Set<ConstraintViolation<RegisterRequest>> violations = validator.validate(request);
        assertTrue(violations.isEmpty());
    }

    @Test
    void testRegisterRequest_InvalidEmail() {
        RegisterRequest request = new RegisterRequest();
        request.setEmail("DROP TABLE users");
        request.setPassword("password123");

        Set<ConstraintViolation<RegisterRequest>> violations = validator.validate(request);
        assertFalse(violations.isEmpty());
    }

    @Test
    void testRegisterRequest_WeakPassword() {
        RegisterRequest request = new RegisterRequest();
        request.setEmail("test@example.com");
        request.setPassword("123");

        Set<ConstraintViolation<RegisterRequest>> violations = validator.validate(request);
        assertFalse(violations.isEmpty());
    }

    @Test
    void testRegisterRequest_PasswordNoNumbers() {
        RegisterRequest request = new RegisterRequest();
        request.setEmail("test@example.com");
        request.setPassword("onlyletters");

        Set<ConstraintViolation<RegisterRequest>> violations = validator.validate(request);
        assertFalse(violations.isEmpty());
    }

    @Test
    void testLoginRequest_ValidInput() {
        LoginRequest request = new LoginRequest();
        request.setEmail("test@example.com");
        request.setPassword("password123");

        Set<ConstraintViolation<LoginRequest>> violations = validator.validate(request);
        assertTrue(violations.isEmpty());
    }

    @Test
    void testLoginRequest_EmptyEmail() {
        LoginRequest request = new LoginRequest();
        request.setEmail("");
        request.setPassword("password123");

        Set<ConstraintViolation<LoginRequest>> violations = validator.validate(request);
        assertFalse(violations.isEmpty());
    }

    @Test
    void testRideRequest_ValidInput() {
        RideRequest request = new RideRequest();
        request.setFromAddress("Nairobi CBD");
        request.setFromLatitude(-1.2921);
        request.setFromLongitude(36.8219);
        request.setToAddress("Westlands");
        request.setToLatitude(-1.2864);
        request.setToLongitude(36.8172);
        request.setEstimatedFare(500.0);
        request.setDistanceKm(5.5);

        Set<ConstraintViolation<RideRequest>> violations = validator.validate(request);
        assertTrue(violations.isEmpty());
    }

    @Test
    void testRideRequest_InvalidLatitude() {
        RideRequest request = new RideRequest();
        request.setFromAddress("Nairobi CBD");
        request.setFromLatitude(100.0); // Invalid - exceeds max

        Set<ConstraintViolation<RideRequest>> violations = validator.validate(request);
        assertFalse(violations.isEmpty());
    }

    @Test
    void testRideRequest_ExcessiveFare() {
        RideRequest request = new RideRequest();
        request.setFromAddress("Nairobi CBD");
        request.setToAddress("Westlands");
        request.setEstimatedFare(200000.0); // Exceeds max

        Set<ConstraintViolation<RideRequest>> violations = validator.validate(request);
        assertFalse(violations.isEmpty());
    }
}