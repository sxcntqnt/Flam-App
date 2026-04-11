package com.rideapp.dezole.service;

import com.rideapp.dezole.exception.ResourceNotFoundException;
import com.rideapp.dezole.model.dto.response.ComplaintStateResponse;
import com.rideapp.dezole.model.entity.Complaint;
import com.rideapp.dezole.model.entity.User;
import com.rideapp.dezole.model.enums.ComplaintStatus;
import com.rideapp.dezole.repository.ComplaintRepository;
import com.rideapp.dezole.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class ComplaintService {

    private final ComplaintRepository complaintRepository;
    private final UserRepository userRepository;

    @Transactional
    public ComplaintStateResponse createComplaint(String userEmail, String topic, String description, String rideId, String orderId) {
        User user = userRepository.findByEmail(userEmail)
                .orElseThrow(() -> new ResourceNotFoundException("User not found"));

        Complaint complaint = Complaint.builder()
                .user(user)
                .topic(topic)
                .description(description)
                .status(ComplaintStatus.PENDING)
                .isSubmitting(true)
                .isSubmitted(false)
                .rideId(rideId)
                .orderId(orderId)
                .build();

        try {
            complaint = complaintRepository.save(complaint);
            complaint.markAsSubmitted();
            complaint = complaintRepository.save(complaint);
            return mapToComplaintStateResponse(complaint);
        } catch (Exception e) {
            complaint.markAsFailed(e.getMessage());
            throw e;
        }
    }

    public List<ComplaintStateResponse> getUserComplaints(String userEmail) {
        User user = userRepository.findByEmail(userEmail)
                .orElseThrow(() -> new ResourceNotFoundException("User not found"));
        
        return complaintRepository.findByUserIdOrderByCreatedAtDesc(user.getId())
                .stream()
                .map(this::mapToComplaintStateResponse)
                .collect(Collectors.toList());
    }

    public List<ComplaintStateResponse> getAllComplaints() {
        return complaintRepository.findAll()
                .stream()
                .map(this::mapToComplaintStateResponse)
                .collect(Collectors.toList());
    }

    public ComplaintStateResponse getComplaintById(Long complaintId) {
        Complaint complaint = complaintRepository.findById(complaintId)
                .orElseThrow(() -> new ResourceNotFoundException("Complaint not found"));
        return mapToComplaintStateResponse(complaint);
    }

    @Transactional
    public ComplaintStateResponse respondToComplaint(Long complaintId, String response) {
        Complaint complaint = complaintRepository.findById(complaintId)
                .orElseThrow(() -> new ResourceNotFoundException("Complaint not found"));

        complaint.resolve(response);
        complaint = complaintRepository.save(complaint);
        return mapToComplaintStateResponse(complaint);
    }

    @Transactional
    public ComplaintStateResponse updateComplaintStatus(Long complaintId, ComplaintStatus status) {
        Complaint complaint = complaintRepository.findById(complaintId)
                .orElseThrow(() -> new ResourceNotFoundException("Complaint not found"));

        complaint.setStatus(status);
        if (status == ComplaintStatus.RESOLVED) {
            complaint.setResolvedAt(java.time.LocalDateTime.now());
        }
        
        complaint = complaintRepository.save(complaint);
        return mapToComplaintStateResponse(complaint);
    }

    private ComplaintStateResponse mapToComplaintStateResponse(Complaint complaint) {
        return ComplaintStateResponse.builder()
                .id(complaint.getId())
                .topic(complaint.getTopic())
                .description(complaint.getDescription())
                .status(complaint.getStatus())
                .response(complaint.getResponse())
                .errorMessage(complaint.getErrorMessage())
                .isSubmitting(complaint.getIsSubmitting())
                .isSubmitted(complaint.getIsSubmitted())
                .createdAt(complaint.getCreatedAt())
                .resolvedAt(complaint.getResolvedAt())
                .build();
    }
}
