import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rxdart/rxdart.dart';

// Fuel state model
class FuelState {
  final double currentPrice;
  final double balance;
  final List<String> recentTransactions;
  final bool isLoading;

  FuelState({
    this.currentPrice = 0.0,
    this.balance = 0.0,
    this.recentTransactions = const [],
    this.isLoading = false,
  });

  FuelState copyWith({
    double? currentPrice,
    double? balance,
    List<String>? recentTransactions,
    bool? isLoading,
  }) {
    return FuelState(
      currentPrice: currentPrice ?? this.currentPrice,
      balance: balance ?? this.balance,
      recentTransactions: recentTransactions ?? this.recentTransactions,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

// Fuel provider using Riverpod
final fuelProvider = StateNotifierProvider<FuelNotifier, FuelState>((ref) {
  return FuelNotifier();
});

class FuelNotifier extends StateNotifier<FuelState> {
  FuelNotifier() : super(FuelState());

  // Streams for reactive updates using RxDart
  final _priceController = BehaviorSubject<double>.seeded(0.0);
  final _balanceController = BehaviorSubject<double>.seeded(0.0);
  final _transactionsController = BehaviorSubject<List<String>>.seeded([]);

  Stream<double> get priceStream => _priceController.stream;
  Stream<double> get balanceStream => _balanceController.stream;
  Stream<List<String>> get transactionsStream => _transactionsController.stream;

  // Update fuel price
  void updatePrice(double price) {
    state = state.copyWith(currentPrice: price);
    _priceController.add(price);
  }

  // Update balance
  void updateBalance(double balance) {
    state = state.copyWith(balance: balance);
    _balanceController.add(balance);
  }

  // Add transaction
  void addTransaction(String transaction) {
    final newTransactions = [...state.recentTransactions, transaction];
    state = state.copyWith(recentTransactions: newTransactions);
    _transactionsController.add(newTransactions);
  }

  // Set loading state
  void setLoading(bool isLoading) {
    state = state.copyWith(isLoading: isLoading);
  }

  // Dispose controllers
  @override
  void dispose() {
    _priceController.close();
    _balanceController.close();
    _transactionsController.close();
    super.dispose();
  }
}
