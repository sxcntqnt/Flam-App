import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rxdart/rxdart.dart';

enum BookingStatus {
  pending,
  confirmed,
  cancelled,
  completed,
}

class BookingState {
  final String? scheduleId;
  final String? routeName;
  final DateTime? departureDate;
  final String departureTime;
  final List<String> seatNumbers;
  final int totalSeats;
  final double totalPrice;
  final BookingStatus status;
  final bool isLoading;
  final String? error;

  const BookingState({
    this.scheduleId,
    this.routeName,
    this.departureDate,
    this.departureTime = '',
    this.seatNumbers = const [],
    this.totalSeats = 0,
    this.totalPrice = 0.0,
    this.status = BookingStatus.pending,
    this.isLoading = false,
    this.error,
  });

  BookingState copyWith({
    String? scheduleId,
    String? routeName,
    DateTime? departureDate,
    String? departureTime,
    List<String>? seatNumbers,
    int? totalSeats,
    double? totalPrice,
    BookingStatus? status,
    bool? isLoading,
    String? error,
  }) {
    return BookingState(
      scheduleId: scheduleId ?? this.scheduleId,
      routeName: routeName ?? this.routeName,
      departureDate: departureDate ?? this.departureDate,
      departureTime: departureTime ?? this.departureTime,
      seatNumbers: seatNumbers ?? this.seatNumbers,
      totalSeats: totalSeats ?? this.totalSeats,
      totalPrice: totalPrice ?? this.totalPrice,
      status: status ?? this.status,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}

class BookingNotifier extends StateNotifier<BookingState> {
  BookingNotifier() : super(const BookingState());

  final _bookingStateSubject = BehaviorSubject<BookingState>.seeded(const BookingState());
  
  Stream<BookingState> get bookingStateStream => _bookingStateSubject.stream;

  void selectSchedule({
    required String scheduleId,
    required String routeName,
    required DateTime departureDate,
    required String departureTime,
  }) {
    state = state.copyWith(
      scheduleId: scheduleId,
      routeName: routeName,
      departureDate: departureDate,
      departureTime: departureTime,
    );
    _bookingStateSubject.add(state);
  }

  void selectSeats(List<String> seats, double pricePerSeat) {
    state = state.copyWith(
      seatNumbers: seats,
      totalSeats: seats.length,
      totalPrice: seats.length * pricePerSeat,
    );
    _bookingStateSubject.add(state);
  }

  void toggleSeat(String seatNumber, double pricePerSeat) {
    final seats = List<String>.from(state.seatNumbers);
    if (seats.contains(seatNumber)) {
      seats.remove(seatNumber);
    } else {
      seats.add(seatNumber);
    }
    state = state.copyWith(
      seatNumbers: seats,
      totalSeats: seats.length,
      totalPrice: seats.length * pricePerSeat,
    );
    _bookingStateSubject.add(state);
  }

  Future<void> confirmBooking() async {
    state = state.copyWith(isLoading: true);
    _bookingStateSubject.add(state.copyWith(isLoading: true));

    try {
      await Future.delayed(const Duration(milliseconds: 500));
      
      state = state.copyWith(
        status: BookingStatus.confirmed,
        isLoading: false,
      );
      _bookingStateSubject.add(state);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
      _bookingStateSubject.add(state);
    }
  }

  Future<void> cancelBooking() async {
    state = state.copyWith(
      status: BookingStatus.cancelled,
    );
    _bookingStateSubject.add(state);
  }

  void reset() {
    state = const BookingState();
    _bookingStateSubject.add(state);
  }
}

final bookingProvider = StateNotifierProvider<BookingNotifier, BookingState>((ref) {
  return BookingNotifier();
});

final selectedSeatsProvider = Provider<List<String>>((ref) {
  final booking = ref.watch(bookingProvider);
  return booking.seatNumbers;
});

final totalPriceProvider = Provider<double>((ref) {
  final booking = ref.watch(bookingProvider);
  return booking.totalPrice;
});