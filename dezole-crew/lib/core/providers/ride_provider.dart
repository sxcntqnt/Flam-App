import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rxdart/rxdart.dart';

enum RideStatus {
  initial,
  searching,
  offersReceived,
  driverAssigned,
  pickingUp,
  inProgress,
  riding,
  completed,
  cancelled,
  noDriversFound,
}

enum TransportType {
  car,
  bike,
  cycle,
  taxi,
  matatu,
}

class RideOffer {
  final String id;
  final String driverId;
  final String driverName;
  final String driverImage;
  final double driverRating;
  final String vehicleModel;
  final String vehicleNumber;
  final double offeredFare;
  final int estimatedArrivalMinutes;
  final double driverLatitude;
  final double driverLongitude;
  final bool isAccepted;
  final bool isExpired;

  const RideOffer({
    required this.id,
    required this.driverId,
    required this.driverName,
    this.driverImage = '',
    required this.driverRating,
    required this.vehicleModel,
    required this.vehicleNumber,
    required this.offeredFare,
    required this.estimatedArrivalMinutes,
    required this.driverLatitude,
    required this.driverLongitude,
    this.isAccepted = false,
    this.isExpired = false,
  });
}

class RideState {
  final String? id;
  final String fromAddress;
  final double fromLatitude;
  final double fromLongitude;
  final String toAddress;
  final double toLatitude;
  final double toLongitude;
  final RideStatus status;
  final TransportType transportType;
  final bool isSearching;
  final bool offersReceived;
  final String? selectedOfferId;
  final List<RideOffer> offers;
  final String? driverId;
  final String? errorMessage;
  final DateTime? requestedAt;
  final DateTime? driverAssignedAt;
  final DateTime? startedAt;
  final DateTime? completedAt;

  const RideState({
    this.id,
    this.fromAddress = '',
    this.fromLatitude = 0.0,
    this.fromLongitude = 0.0,
    this.toAddress = '',
    this.toLatitude = 0.0,
    this.toLongitude = 0.0,
    this.status = RideStatus.initial,
    this.transportType = TransportType.car,
    this.isSearching = false,
    this.offersReceived = false,
    this.selectedOfferId,
    this.offers = const [],
    this.driverId,
    this.errorMessage,
    this.requestedAt,
    this.driverAssignedAt,
    this.startedAt,
    this.completedAt,
  });

  RideState copyWith({
    String? id,
    String? fromAddress,
    double? fromLatitude,
    double? fromLongitude,
    String? toAddress,
    double? toLatitude,
    double? toLongitude,
    RideStatus? status,
    TransportType? transportType,
    bool? isSearching,
    bool? offersReceived,
    String? selectedOfferId,
    List<RideOffer>? offers,
    String? driverId,
    String? errorMessage,
    DateTime? requestedAt,
    DateTime? driverAssignedAt,
    DateTime? startedAt,
    DateTime? completedAt,
  }) {
    return RideState(
      id: id ?? this.id,
      fromAddress: fromAddress ?? this.fromAddress,
      fromLatitude: fromLatitude ?? this.fromLatitude,
      fromLongitude: fromLongitude ?? this.fromLongitude,
      toAddress: toAddress ?? this.toAddress,
      toLatitude: toLatitude ?? this.toLatitude,
      toLongitude: toLongitude ?? this.toLongitude,
      status: status ?? this.status,
      transportType: transportType ?? this.transportType,
      isSearching: isSearching ?? this.isSearching,
      offersReceived: offersReceived ?? this.offersReceived,
      selectedOfferId: selectedOfferId ?? this.selectedOfferId,
      offers: offers ?? this.offers,
      driverId: driverId ?? this.driverId,
      errorMessage: errorMessage ?? this.errorMessage,
      requestedAt: requestedAt ?? this.requestedAt,
      driverAssignedAt: driverAssignedAt ?? this.driverAssignedAt,
      startedAt: startedAt ?? this.startedAt,
      completedAt: completedAt ?? this.completedAt,
    );
  }
}

class RideNotifier extends StateNotifier<RideState> {
  RideNotifier() : super(const RideState());

  final _rideStateSubject = BehaviorSubject<RideState>.seeded(const RideState());
  
  Stream<RideState> get rideStateStream => _rideStateSubject.stream;

  void createRideRequest({
    required String fromAddress,
    required double fromLatitude,
    required double fromLongitude,
    required String toAddress,
    required double toLatitude,
    required double toLongitude,
    TransportType transportType = TransportType.car,
  }) {
    state = RideState(
      id: 'ride-${DateTime.now().millisecondsSinceEpoch}',
      fromAddress: fromAddress,
      fromLatitude: fromLatitude,
      fromLongitude: fromLongitude,
      toAddress: toAddress,
      toLatitude: toLatitude,
      toLongitude: toLongitude,
      transportType: transportType,
      status: RideStatus.initial,
    );
    _rideStateSubject.add(state);
  }

  void startSearching() {
    state = state.copyWith(
      isSearching: true,
      status: RideStatus.searching,
      requestedAt: DateTime.now(),
    );
    _rideStateSubject.add(state);
  }

  void stopSearching() {
    state = state.copyWith(
      isSearching: false,
    );
    _rideStateSubject.add(state);
  }

  void addOffer(RideOffer offer) {
    state = state.copyWith(
      offers: [...state.offers, offer],
      offersReceived: true,
    );
    _rideStateSubject.add(state);
  }

  void acceptOffer(String offerId) {
    final offer = state.offers.firstWhere((o) => o.id == offerId);
    state = state.copyWith(
      selectedOfferId: offerId,
      driverId: offer.driverId,
      status: RideStatus.driverAssigned,
      isSearching: false,
      driverAssignedAt: DateTime.now(),
    );
    _rideStateSubject.add(state);
  }

  void declineAllOffers() {
    state = state.copyWith(
      isSearching: true,
      offersReceived: false,
      offers: [],
    );
    _rideStateSubject.add(state);
  }

  void updateStatus(RideStatus status) {
    state = state.copyWith(status: status);
    _rideStateSubject.add(state);
  }

  void startRide() {
    state = state.copyWith(
      status: RideStatus.inProgress,
      startedAt: DateTime.now(),
    );
    _rideStateSubject.add(state);
  }

  void completeRide() {
    state = state.copyWith(
      status: RideStatus.completed,
      completedAt: DateTime.now(),
    );
    _rideStateSubject.add(state);
  }

  void cancelRide(String reason) {
    state = state.copyWith(
      status: RideStatus.cancelled,
      errorMessage: reason,
    );
    _rideStateSubject.add(state);
  }

  void reset() {
    state = const RideState();
    _rideStateSubject.add(state);
  }
}

final rideProvider = StateNotifierProvider<RideNotifier, RideState>((ref) {
  return RideNotifier();
});

final rideStatusProvider = Provider<RideStatus>((ref) {
  final ride = ref.watch(rideProvider);
  return ride.status;
});

final isRideActiveProvider = Provider<bool>((ref) {
  final ride = ref.watch(rideProvider);
  return ride.status == RideStatus.searching ||
         ride.status == RideStatus.offersReceived ||
         ride.status == RideStatus.driverAssigned ||
         ride.status == RideStatus.pickingUp ||
         ride.status == RideStatus.inProgress ||
         ride.status == RideStatus.riding;
});

final offerCountProvider = Provider<int>((ref) {
  final ride = ref.watch(rideProvider);
  return ride.offers.length;
});