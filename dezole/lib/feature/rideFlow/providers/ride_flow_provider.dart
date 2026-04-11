import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rxdart/rxdart.dart';

enum RideType { transport, delivery }

enum TransportMode { car, bike, cycle, taxi }

class RideSearchState {
  final RideType rideType;
  final String? fromAddress;
  final String? toAddress;
  final bool isSearching;
  final String? error;

  const RideSearchState({
    this.rideType = RideType.transport,
    this.fromAddress,
    this.toAddress,
    this.isSearching = false,
    this.error,
  });

  RideSearchState copyWith({
    RideType? rideType,
    String? fromAddress,
    String? toAddress,
    bool? isSearching,
    String? error,
  }) {
    return RideSearchState(
      rideType: rideType ?? this.rideType,
      fromAddress: fromAddress ?? this.fromAddress,
      toAddress: toAddress ?? this.toAddress,
      isSearching: isSearching ?? this.isSearching,
      error: error,
    );
  }
}

class RideSearchNotifier extends StateNotifier<RideSearchState> {
  RideSearchNotifier() : super(const RideSearchState());

  void setRideType(RideType type) => state = state.copyWith(rideType: type);
  void setFromAddress(String? addr) =>
      state = state.copyWith(fromAddress: addr);
  void setToAddress(String? addr) => state = state.copyWith(toAddress: addr);

  Future<void> search() async {
    if (state.fromAddress == null || state.toAddress == null) {
      state = state.copyWith(error: 'Please enter both addresses');
      return;
    }
    state = state.copyWith(isSearching: true, error: null);
    await Future.delayed(const Duration(milliseconds: 500));
    state = state.copyWith(isSearching: false);
  }

  void reset() => state = const RideSearchState();
}

final rideSearchProvider =
    StateNotifierProvider<RideSearchNotifier, RideSearchState>((ref) {
      return RideSearchNotifier();
    });

final selectedTransportModeProvider = StateProvider<TransportMode>((ref) {
  return TransportMode.car;
});
