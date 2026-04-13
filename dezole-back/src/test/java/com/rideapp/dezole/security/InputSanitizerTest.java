package com.rideapp.dezole.security;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.*;

class InputSanitizerTest {

    private InputSanitizer sanitizer;

    @BeforeEach
    void setUp() {
        sanitizer = new InputSanitizer();
    }

    @Test
    void testSanitizeText_RemovesScriptTags() {
        String input = "<script>alert('xss')</script>Hello";
        String result = sanitizer.sanitizeText(input);
        assertFalse(result.contains("<script>"));
    }

    @Test
    void testSanitizeText_RemovesHtmlTags() {
        String input = "<div onclick='evil()'>Test</div>";
        String result = sanitizer.sanitizeText(input);
        assertFalse(result.contains("<div>"));
    }

    @Test
    void testSanitizeName_RemovesNumbers() {
        String input = "John123";
        String result = sanitizer.sanitizeName(input);
        assertEquals("John", result);
    }

    @Test
    void testSanitizeName_RemovesSpecialChars() {
        String input = "John;DROP TABLE";
        String result = sanitizer.sanitizeName(input);
        assertFalse(result.contains(";"));
    }

    @Test
    void testSanitizeEmail_Lowercases() {
        String input = "TEST@EXAMPLE.COM";
        String result = sanitizer.sanitizeEmail(input);
        assertEquals("test@example.com", result);
    }

    @Test
    void testSanitizeEmail_RejectsInvalid() {
        String input = "DROP TABLE users";
        String result = sanitizer.sanitizeEmail(input);
        assertNull(result);
    }

    @Test
    void testSanitizePhone_ValidFormat() {
        String input = "+254 700 123456";
        String result = sanitizer.sanitizePhone(input);
        assertEquals("+254700123456", result);
    }

    @Test
    void testSanitizePhone_RejectsInvalid() {
        String input = "'; DROP TABLE users;--";
        String result = sanitizer.sanitizePhone(input);
        assertNull(result);
    }

    @Test
    void testIsValidText_SQLInjectionAttempt() {
        String input = "Test'; DROP TABLE users;--";
        assertFalse(sanitizer.isValidText(input));
    }

    @Test
    void testIsValidText_XSSAttempt() {
        String input = "<script>alert('xss')</script>";
        assertFalse(sanitizer.isValidText(input));
    }

    @Test
    void testIsValidText_NormalText() {
        String input = "Hello, World! This is a test.";
        assertTrue(sanitizer.isValidText(input));
    }

    @Test
    void testIsValidName_SQLInjectionAttempt() {
        String input = "'; DROP TABLE users;--";
        assertFalse(sanitizer.isValidName(input));
    }

    @Test
    void testIsValidEmail_SQLInjectionAttempt() {
        String input = "test@example.com'; DROP TABLE users;--";
        assertFalse(sanitizer.isValidEmail(input));
    }
}