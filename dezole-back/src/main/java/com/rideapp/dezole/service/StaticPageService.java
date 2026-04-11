package com.rideapp.dezole.service;

import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.Map;

@Service
@RequiredArgsConstructor
public class StaticPageService {

    public Map<String, String> getPrivacyPolicy() {
        return Map.of(
            "title", "Privacy Policy",
            "content", "This is the Privacy Policy for Dezole. We value your privacy and are committed to protecting your personal data."
        );
    }

    public Map<String, String> getAboutUs() {
        return Map.of(
            "title", "About Us",
            "content", "Dezole is a leading ride-hailing and bus reservation platform operating in Nairobi, Kenya."
        );
    }

    public Map<String, String> getHelpSupport() {
        return Map.of(
            "title", "Help & Support",
            "content", "For assistance, please contact our support team at support@dezole.com or call +254 700 000 000."
        );
    }

    public Map<String, String> getContactInfo() {
        return Map.of(
            "email", "info@dezole.com",
            "phone", "+254 700 000 000",
            "address", "Nairobi, Kenya",
            "website", "www.dezole.com"
        );
    }
}
