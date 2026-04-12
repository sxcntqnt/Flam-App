import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rxdart/rxdart.dart';

// Trip state model
class TripsState {
  final List<Map<String, dynamic>> trips;
  final bool isLoading;
  final String? selectedTripId;

  TripsState({
    this.trips = const [],
    this.isLoading = false,
    this.selectedTripId,
  });

  TripsState copyWith({
    List<Map<String, dynamic>>? trips,
    bool? isLoading,
    String? selectedTripId,
  }) {
    return TripsState(
      trips: trips ?? this.trips,
      isLoading: isLoading ?? this.isLoading,
      selectedTripId: selectedTripId ?? this.selectedTripId,
    );
  }
}

// Trips provider using Riverpod
final tripsProvider = StateNotifierProvider<TripsNotifier, TripsState>((ref) {
  return TripsNotifier();
});

class TripsNotifier extends StateNotifier<TripsState> {
  TripsNotifier() : super(TripsState());

  // Streams for reactive updates using RxDart
  final _tripsController = BehaviorSubject<List<Map<String, dynamic>>>.seeded(
    [],
  );
  final _loadingController = BehaviorSubject<bool>.seeded(false);
  final _selectedTripController = BehaviorSubject<String?>.seeded(null);

  Stream<List<Map<String, dynamic>>> get tripsStream => _tripsController.stream;
  Stream<bool> get isLoadingStream => _loadingController.stream;
  Stream<String?> get selectedTripStream => _selectedTripController.stream;

  // Add trip
  void addTrip(Map<String, dynamic> trip) {
    final newTrips = [...state.trips, trip];
    state = state.copyWith(trips: newTrips);
    _tripsController.add(newTrips);
  }

  // Update trip
  void updateTrip(String tripId, Map<String, dynamic> updates) {
    final updatedTrips = state.trips.map((trip) {
      if (trip['id'] == tripId) {
        return {...trip, ...updates};
      }
      return trip;
    }).toList();

    state = state.copyWith(trips: updatedTrips);
    _tripsController.add(updatedTrips);
  }

  // Select trip
  void selectTrip(String tripId) {
    state = state.copyWith(selectedTripId: tripId);
    _selectedTripController.add(tripId);
  }

  // Deselect trip
  void deselectTrip() {
    state = state.copyWith(selectedTripId: null);
    _selectedTripController.add(null);
  }

  // Set loading state
  void setLoading(bool isLoading) {
    state = state.copyWith(isLoading: isLoading);
    _loadingController.add(isLoading);
  }

  // Clear trips
  void clearTrips() {
    state = state.copyWith(trips: [], selectedTripId: null);
    _tripsController.add([]);
    _selectedTripController.add(null);
  }

  // Dispose controllers
  @override
  void dispose() {
    _tripsController.close();
    _loadingController.close();
    _selectedTripController.close();
    super.dispose();
  }
}
