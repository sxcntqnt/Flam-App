package com.rideapp.dezole.controller;

import com.rideapp.dezole.model.dto.response.ComplaintStateResponse;
import com.rideapp.dezole.model.enums.ComplaintStatus;
import com.rideapp.dezole.service.ComplaintService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/complaints")
@RequiredArgsConstructor
public class ComplaintController {

    private final ComplaintService complaintService;

    @GetMapping
    public ResponseEntity<List<ComplaintStateResponse>> getUserComplaints() {
        String email = getCurrentUserEmail();
        return ResponseEntity.ok(complaintService.getUserComplaints(email));
    }

    @GetMapping("/all")
    public ResponseEntity<List<ComplaintStateResponse>> getAllComplaints() {
        return ResponseEntity.ok(complaintService.getAllComplaints());
    }

    @GetMapping("/{id}")
    public ResponseEntity<ComplaintStateResponse> getComplaintById(@PathVariable Long id) {
        return ResponseEntity.ok(complaintService.getComplaintById(id));
    }

    @PostMapping
    public ResponseEntity<ComplaintStateResponse> createComplaint(@RequestBody Map<String, String> request) {
        String email = getCurrentUserEmail();
        String topic = request.get("topic");
        String description = request.get("description");
        String rideId = request.get("rideId");
        String orderId = request.get("orderId");
        
        return ResponseEntity.status(HttpStatus.CREATED)
                .body(complaintService.createComplaint(email, topic, description, rideId, orderId));
    }

    @PutMapping("/{id}/status")
    public ResponseEntity<ComplaintStateResponse> updateComplaintStatus(
            @PathVariable Long id,
            @RequestBody Map<String, String> request) {
        ComplaintStatus status = ComplaintStatus.valueOf(request.get("status"));
        return ResponseEntity.ok(complaintService.updateComplaintStatus(id, status));
    }

    @PutMapping("/{id}/respond")
    public ResponseEntity<ComplaintStateResponse> respondToComplaint(
            @PathVariable Long id,
            @RequestBody Map<String, String> request) {
        String response = request.get("response");
        return ResponseEntity.ok(complaintService.respondToComplaint(id, response));
    }

    private String getCurrentUserEmail() {
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        return auth.getName();
    }
}
