package com.rideapp.dezole.service;

import com.rideapp.dezole.model.dto.response.BookingStateResponse;
import com.rideapp.dezole.model.entity.Booking;
import com.rideapp.dezole.model.entity.Schedule;
import com.rideapp.dezole.model.entity.User;
import com.rideapp.dezole.model.entity.Wallet;
import com.rideapp.dezole.model.enums.BookingStatus;
import com.rideapp.dezole.repository.BookingRepository;
import com.rideapp.dezole.repository.ScheduleRepository;
import com.rideapp.dezole.repository.UserRepository;
import com.rideapp.dezole.repository.WalletRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDate;
import java.util.List;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class BookingService {

    private final BookingRepository bookingRepository;
    private final ScheduleRepository scheduleRepository;
    private final UserRepository userRepository;
    private final WalletRepository walletRepository;

    @Transactional
    public BookingStateResponse createBooking(String userEmail, String scheduleId, 
            LocalDate departureDate, List<String> seatNumbers) {
        
        User user = userRepository.findByEmail(userEmail)
                .orElseThrow(() -> new RuntimeException("User not found"));
        
        Schedule schedule = scheduleRepository.findById(scheduleId)
                .orElseThrow(() -> new RuntimeException("Schedule not found"));

        double totalPrice = seatNumbers.size() * schedule.getTicketPrice();

        Booking booking = Booking.builder()
                .user(user)
                .schedule(schedule)
                .routeName(schedule.getRoute() != null ? schedule.getRoute().getRouteName() : "")
                .departureTime(schedule.getDepartureTime().toString())
                .departureDate(departureDate)
                .seatNumbers(seatNumbers)
                .totalSeats(seatNumbers.size())
                .pricePerSeat(schedule.getTicketPrice())
                .totalPrice(totalPrice)
                .status(BookingStatus.PENDING)
                .build();

        booking = bookingRepository.save(booking);

        return mapToBookingStateResponse(booking);
    }

    @Transactional
    public BookingStateResponse confirmBooking(String bookingId, String userEmail, String paymentMethod) {
        Booking booking = bookingRepository.findById(bookingId)
                .orElseThrow(() -> new RuntimeException("Booking not found"));

        if (!booking.getUser().getEmail().equals(userEmail)) {
            throw new RuntimeException("Unauthorized");
        }

        Wallet wallet = walletRepository.findByUserEmail(userEmail)
                .orElseThrow(() -> new RuntimeException("Wallet not found"));

        if (wallet.getBalance() < booking.getTotalPrice()) {
            return BookingStateResponse.builder()
                    .id(booking.getId())
                    .status(BookingStatus.PENDING)
                    .errorMessage("Insufficient balance")
                    .build();
        }

        wallet.setBalance(wallet.getBalance() - booking.getTotalPrice());
        walletRepository.save(wallet);

        booking.setStatus(BookingStatus.CONFIRMED);
        booking.setIsPaid(true);
        booking.setPaymentMethod(paymentMethod);
        
        booking = bookingRepository.save(booking);

        return mapToBookingStateResponse(booking);
    }

    public List<BookingStateResponse> getUserBookings(String userEmail) {
        User user = userRepository.findByEmail(userEmail)
                .orElseThrow(() -> new RuntimeException("User not found"));

        return bookingRepository.findByUserIdOrderByCreatedAtDesc(user.getId())
                .stream()
                .map(this::mapToBookingStateResponse)
                .collect(Collectors.toList());
    }

    public BookingStateResponse getBooking(String bookingId, String userEmail) {
        Booking booking = bookingRepository.findById(bookingId)
                .orElseThrow(() -> new RuntimeException("Booking not found"));

        if (!booking.getUser().getEmail().equals(userEmail)) {
            throw new RuntimeException("Unauthorized");
        }

        return mapToBookingStateResponse(booking);
    }

    @Transactional
    public BookingStateResponse cancelBooking(String bookingId, String userEmail) {
        Booking booking = bookingRepository.findById(bookingId)
                .orElseThrow(() -> new RuntimeException("Booking not found"));

        if (!booking.getUser().getEmail().equals(userEmail)) {
            throw new RuntimeException("Unauthorized");
        }

        if (booking.getStatus() != BookingStatus.PENDING) {
            throw new RuntimeException("Cannot cancel booking");
        }

        booking.setStatus(BookingStatus.CANCELLED);
        booking = bookingRepository.save(booking);

        return mapToBookingStateResponse(booking);
    }

    public List<String> getAvailableSeats(String scheduleId, LocalDate departureDate) {
        List<Booking> bookedBookings = bookingRepository.findByScheduleIdAndDepartureDate(
                scheduleId, departureDate);
        
        Schedule schedule = scheduleRepository.findById(scheduleId)
                .orElseThrow(() -> new RuntimeException("Schedule not found"));

        List<String> bookedSeats = bookedBookings.stream()
                .filter(b -> b.getStatus() == BookingStatus.CONFIRMED)
                .flatMap(b -> b.getSeatNumbers().stream())
                .collect(Collectors.toList());

        List<String> availableSeats = new java.util.ArrayList<>();
        for (int i = 1; i <= schedule.getBus().getTotalSeats(); i++) {
            String seat = "Seat " + i;
            if (!bookedSeats.contains(seat)) {
                availableSeats.add(seat);
            }
        }

        return availableSeats;
    }

    private BookingStateResponse mapToBookingStateResponse(Booking booking) {
        return BookingStateResponse.builder()
                .id(booking.getId())
                .scheduleId(booking.getSchedule() != null ? booking.getSchedule().getId() : null)
                .routeName(booking.getRouteName())
                .departureTime(booking.getDepartureTime())
                .departureDate(booking.getDepartureDate())
                .selectedSeats(booking.getSeatNumbers())
                .totalSeats(booking.getTotalSeats())
                .pricePerSeat(booking.getPricePerSeat())
                .totalPrice(booking.getTotalPrice())
                .status(booking.getStatus())
                .build();
    }
}