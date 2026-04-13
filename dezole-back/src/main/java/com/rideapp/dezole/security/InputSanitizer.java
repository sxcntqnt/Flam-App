package com.rideapp.dezole.security;

import org.springframework.stereotype.Component;

import java.util.regex.Pattern;

@Component
public class InputSanitizer {

    private static final Pattern SAFE_TEXT_PATTERN = Pattern.compile("^[A-Za-z0-9\\s.,'-!@#$%^&*()_+=|:;<>?/\\\\]+$");
    private static final Pattern EMAIL_PATTERN = Pattern.compile("^[A-Za-z0-9+_.-]+@(.+)$");
    private static final Pattern PHONE_PATTERN = Pattern.compile("^\\+?[0-9]{9,15}$");
    private static final Pattern ALPHANUMERIC_PATTERN = Pattern.compile("^[A-Za-z0-9]+$");

    private static final int MAX_TEXT_LENGTH = 1000;
    private static final int MAX_NAME_LENGTH = 100;
    private static final int MAX_EMAIL_LENGTH = 255;

    public String sanitizeText(String input) {
        if (input == null) return null;
        String trimmed = input.trim();
        if (trimmed.length() > MAX_TEXT_LENGTH) {
            trimmed = trimmed.substring(0, MAX_TEXT_LENGTH);
        }
        return trimmed.replaceAll("[<>\"';&]", "");
    }

    public String sanitizeName(String input) {
        if (input == null) return null;
        String trimmed = input.trim();
        if (trimmed.length() > MAX_NAME_LENGTH) {
            trimmed = trimmed.substring(0, MAX_NAME_LENGTH);
        }
        return trimmed.replaceAll("[<>\"';&0-9]", "");
    }

    public String sanitizeEmail(String input) {
        if (input == null) return null;
        String trimmed = input.trim().toLowerCase();
        if (trimmed.length() > MAX_EMAIL_LENGTH) {
            return null;
        }
        if (!EMAIL_PATTERN.matcher(trimmed).matches()) {
            return null;
        }
        return trimmed;
    }

    public String sanitizePhone(String input) {
        if (input == null) return null;
        String trimmed = input.trim().replaceAll("[\\s-()]", "");
        if (!PHONE_PATTERN.matcher(trimmed).matches()) {
            return null;
        }
        return trimmed;
    }

    public String sanitizeAlphanumeric(String input) {
        if (input == null) return null;
        if (!ALPHANUMERIC_PATTERN.matcher(input).matches()) {
            return null;
        }
        return input;
    }

    public boolean isValidText(String input) {
        return input != null && !input.isEmpty() && 
               input.length() <= MAX_TEXT_LENGTH && 
               SAFE_TEXT_PATTERN.matcher(input).matches();
    }

    public boolean isValidName(String input) {
        if (input == null || input.isEmpty()) return true;
        if (input.length() > MAX_NAME_LENGTH) return false;
        return input.matches("^[A-Za-z\\s'-]+$");
    }

    public boolean isValidEmail(String input) {
        if (input == null || input.isEmpty()) return false;
        return EMAIL_PATTERN.matcher(input).matches();
    }
}