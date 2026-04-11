package com.rideapp.dezole.controller;

import com.rideapp.dezole.service.StaticPageService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.Map;

@RestController
@RequestMapping("/api/static")
@RequiredArgsConstructor
public class StaticPageController {

    private final StaticPageService staticPageService;

    @GetMapping("/privacy-policy")
    public ResponseEntity<Map<String, String>> getPrivacyPolicy() {
        return ResponseEntity.ok(staticPageService.getPrivacyPolicy());
    }

    @GetMapping("/about-us")
    public ResponseEntity<Map<String, String>> getAboutUs() {
        return ResponseEntity.ok(staticPageService.getAboutUs());
    }

    @GetMapping("/help-support")
    public ResponseEntity<Map<String, String>> getHelpSupport() {
        return ResponseEntity.ok(staticPageService.getHelpSupport());
    }

    @GetMapping("/contact")
    public ResponseEntity<Map<String, String>> getContactInfo() {
        return ResponseEntity.ok(staticPageService.getContactInfo());
    }
}
