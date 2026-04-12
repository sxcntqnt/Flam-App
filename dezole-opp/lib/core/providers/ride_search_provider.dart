import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rxdart/rxdart.dart';

enum RideSearchStatus {
  initial,
  searching,
  offersFound,
  rideConfirmed,
  rideInProgress,
  rideCompleted,
  rideCancelled,
  noDriversAvailable,
}

enum TransportMode {
  car,
  bike,
  cycle,
  taxi,
}

class RideSearchState {
  final RideSearchStatus status;
  final String? fromAddress;
  final double? fromLatitude;
  final double? fromLongitude;
  final String? toAddress;
  final double? toLatitude;
  final double? toLongitude;
  final TransportMode transportMode;
  final bool isSearching;
  final String? errorMessage;

  const RideSearchState({
    this.status = RideSearchStatus.initial,
    this.fromAddress,
    this.fromLatitude,
    this.fromLongitude,
    this.toAddress,
    this.toLatitude,
    this.toLongitude,
    this.transportMode = TransportMode.car,
    this.isSearching = false,
    this.errorMessage,
  });

  RideSearchState copyWith({
    RideSearchStatus? status,
    String? fromAddress,
    double? fromLatitude,
    double? fromLongitude,
    String? toAddress,
    double? toLatitude,
    double? toLongitude,
    TransportMode? transportMode,
    bool? isSearching,
    String? errorMessage,
  }) {
    return RideSearchState(
      status: status ?? this.status,
      fromAddress: fromAddress ?? this.fromAddress,
      fromLatitude: fromLatitude ?? this.fromLatitude,
      fromLongitude: fromLongitude ?? this.fromLongitude,
      toAddress: toAddress ?? this.toAddress,
      toLatitude: toLatitude ?? this.toLatitude,
      toLongitude: toLongitude ?? this.toLongitude,
      transportMode: transportMode ?? this.transportMode,
      isSearching: isSearching ?? this.isSearching,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

class RideSearchNotifier extends StateNotifier<RideSearchState> {
  RideSearchNotifier() : super(const RideSearchState());

  final _searchStateSubject = BehaviorSubject<RideSearchState>.seeded(const RideSearchState());
  
  Stream<RideSearchState> get searchStateStream => _searchStateSubject.stream;

  void setFromLocation(String address, double lat, double lng) {
    state = state.copyWith(
      fromAddress: address,
      fromLatitude: lat,
      fromLongitude: lng,
    );
    _searchStateSubject.add(state);
  }

  void setToLocation(String address, double lat, double lng) {
    state = state.copyWith(
      toAddress: address,
      toLatitude: lat,
      toLongitude: lng,
    );
    _searchStateSubject.add(state);
  }

  void selectTransportMode(TransportMode mode) {
    state = state.copyWith(transportMode: mode);
    _searchStateSubject.add(state);
  }

  Future<void> searchRides() async {
    if (state.fromAddress == null || state.toAddress == null) {
      state = state.copyWith(
        errorMessage: 'Please specify pickup and destination locations',
      );
      return;
    }

    state = state.copyWith(
      status: RideSearchStatus.searching,
      isSearching: true,
    );
    _searchStateSubject.add(state.copyWith(isSearching: true));

    try {
      await Future.delayed(const Duration(seconds: 2));
      
      state = state.copyWith(
        status: RideSearchStatus.offersFound,
        isSearching: false,
      );
      _searchStateSubject.add(state);
    } catch (e) {
      state = state.copyWith(
        status: RideSearchStatus.noDriversAvailable,
        isSearching: false,
        errorMessage: e.toString(),
      );
      _searchStateSubject.add(state);
    }
  }

  void confirmRide() {
    state = state.copyWith(
      status: RideSearchStatus.rideConfirmed,
    );
    _searchStateSubject.add(state);
  }

  void startRide() {
    state = state.copyWith(
      status: RideSearchStatus.rideInProgress,
    );
    _searchStateSubject.add(state);
  }

  void completeRide() {
    state = state.copyWith(
      status: RideSearchStatus.rideCompleted,
    );
    _searchStateSubject.add(state);
  }

  void cancelRide() {
    state = state.copyWith(
      status: RideSearchStatus.rideCancelled,
    );
    _searchStateSubject.add(state);
  }

  void reset() {
    state = const RideSearchState();
    _searchStateSubject.add(state);
  }
}

final rideSearchProvider = StateNotifierProvider<RideSearchNotifier, RideSearchState>((ref) {
  return RideSearchNotifier();
});

final selectedTransportModeProvider = StateProvider<TransportMode>((ref) {
  final search = ref.watch(rideSearchProvider);
  return search.transportMode;
});

final isRideSearchingProvider = Provider<bool>((ref) {
  final search = ref.watch(rideSearchProvider);
  return search.isSearching;
});

final rideSearchStreamProvider = StreamProvider<RideSearchState>((ref) {
  final notifier = ref.read(rideSearchProvider.notifier);
  return notifier.searchStateStream;
});