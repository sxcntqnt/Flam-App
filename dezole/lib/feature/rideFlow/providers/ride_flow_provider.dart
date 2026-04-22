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
  // Using BehaviorSubject for the search query to enable debouncing
  final BehaviorSubject<String> _searchSubject = BehaviorSubject<String>();
  
  RideSearchNotifier() : super(const RideSearchState()) {
    // This is where RxDart shines: debouncing the search input
    _searchSubject.debounceTime(const Duration(milliseconds: 500)).listen((query) {
      // Logic to trigger search based on debounced query could go here
      // or the UI can call search() explicitly
    });
  }

  @override
  void dispose() {
    _searchSubject.close();
    super.dispose();
  }

  void setRideType(RideType type) => state = state.copyWith(rideType: type);
  void setFromAddress(String? addr) => state = state.copyWith(fromAddress: addr);
  void setToAddress(String? addr) => state = state.copyWith(toAddress: addr);

  Future<void> search() async {
    if (state.fromAddress == null || state.toAddress == null) {
      state = state.copyWith(error: 'Please enter both addresses');
      return;
    }
    state = state.copyWith(isSearching: true, error: null);
    
    // Simulate API call
    await Future.delayed(const Duration(milliseconds: 500));
    state = state.copyWith(isSearching: false);
  }

  void reset() => state = const RideSearchState();
}

// Use autoDispose here as ride search state should be cleared when exiting the flow
final rideSearchProvider =
    StateNotifierProvider.autoDispose<RideSearchNotifier, RideSearchState>((ref) {
  return RideSearchNotifier();
});

final selectedTransportModeProvider = StateProvider.autoDispose<TransportMode>((ref) {
  return TransportMode.car;
});
