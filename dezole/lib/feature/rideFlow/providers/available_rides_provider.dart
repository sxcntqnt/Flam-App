import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rxdart/rxdart.dart';

class AvailableRide {
  final String id;
  final String driverName;
  final String vehicleName;
  final String plateNumber;
  final int seats;
  final double price;
  final double rating;
  final String distance;
  final String eta;

  const AvailableRide({
    required this.id,
    required this.driverName,
    required this.vehicleName,
    required this.plateNumber,
    required this.seats,
    required this.price,
    required this.rating,
    required this.distance,
    required this.eta,
  });
}

class RideStreamState {
  final List<AvailableRide> rides;
  final bool isLoading;
  final bool hasError;
  final String? error;
  final String? selectedRideId;

  const RideStreamState({
    this.rides = const [],
    this.isLoading = false,
    this.hasError = false,
    this.error,
    this.selectedRideId,
  });

  RideStreamState copyWith({
    List<AvailableRide>? rides,
    bool? isLoading,
    bool? hasError,
    String? error,
    String? selectedRideId,
  }) {
    return RideStreamState(
      rides: rides ?? this.rides,
      isLoading: isLoading ?? this.isLoading,
      hasError: hasError ?? this.hasError,
      error: error,
      selectedRideId: selectedRideId ?? this.selectedRideId,
    );
  }
}

class AvailableRidesNotifier extends StateNotifier<RideStreamState> {
  final BehaviorSubject<List<AvailableRide>> _ridesSubject = 
      BehaviorSubject<List<AvailableRide>>.seeded(_mockRides);
  
  final StreamSubscription _subscription;

  AvailableRidesNotifier() : super(const RideStreamState()) {
    // Using RxDart to handle stream transformations
    _subscription = _ridesSubject.stream
        .debounceTime(const Duration(milliseconds: 300))
        .distinct()
        .listen((rides) {
      state = state.copyWith(rides: rides, isLoading: false);
    });
    
    _loadRides();
  }

  @override
  void dispose() {
    _subscription.cancel();
    _ridesSubject.close();
    super.dispose();
  }

  Future<void> _loadRides() async {
    state = state.copyWith(isLoading: true);
    // Simulate API call then push to subject
    await Future.delayed(const Duration(seconds: 1));
    _ridesSubject.add(_mockRides);
  }

  void selectRide(String id) {
    state = state.copyWith(selectedRideId: id);
  }

  void clearSelection() {
    state = state.copyWith(selectedRideId: null);
  }

  Future<bool> bookRide(String rideId) async {
    state = state.copyWith(isLoading: true);
    await Future.delayed(const Duration(seconds: 1));
    state = state.copyWith(isLoading: false);
    return true;
  }

  void refresh() => _loadRides();
}

final availableRidesProvider =
    StateNotifierProvider<AvailableRidesNotifier, RideStreamState>((ref) {
  return AvailableRidesNotifier();
});

final selectedRideProvider = Provider<AvailableRide?>((ref) {
  final state = ref.watch(availableRidesProvider);
  if (state.selectedRideId == null) return null;
  return state.rides.firstWhere(
    (r) => r.id == state.selectedRideId,
    orElse: () => state.rides.isNotEmpty ? state.rides.first : throw Exception('No rides available'),
  );
});

const List<AvailableRide> _mockRides = [
  AvailableRide(
    id: '1',
    driverName: 'John Kamau',
    vehicleName: 'Toyota Axio',
    plateNumber: 'KAB 123X',
    seats: 4,
    price: 150,
    rating: 4.8,
    distance: '800m',
    eta: '5mins',
  ),
  AvailableRide(
    id: '2',
    driverName: 'Sarah Wanjiku',
    vehicleName: 'Honda Civic',
    plateNumber: 'KBZ 456Y',
    seats: 4,
    price: 200,
    rating: 4.6,
    distance: '1.2km',
    eta: '8mins',
  ),
  AvailableRide(
    id: '3',
    driverName: 'Mike Otieno',
    vehicleName: 'Nissan Sentra',
    plateNumber: 'KCD 789Z',
    seats: 4,
    price: 180,
    rating: 4.9,
    distance: '500m',
    eta: '3mins',
  ),
];
