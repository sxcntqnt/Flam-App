package com.rideapp.dezole.model.dto.response;

import com.rideapp.dezole.model.enums.BookingStatus;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDate;
import java.util.List;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class BookingStateResponse {
    private String id;
    private String scheduleId;
    private String routeName;
    private String departureTime;
    private LocalDate departureDate;
    private List<String> selectedSeats;
    private Integer totalSeats;
    private Double pricePerSeat;
    private Double totalPrice;
    private BookingStatus status;
    private Boolean isLoading;
    private String errorMessage;
    
    // Bus info
    private String busName;
    private String busNumber;
    private Integer availableSeats;
}