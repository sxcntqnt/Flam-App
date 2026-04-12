import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rxdart/rxdart.dart';

// Wallet state model
class WalletState {
  final double balance;
  final List<Map<String, dynamic>> transactions;
  final bool isLoading;

  WalletState({
    this.balance = 0.0,
    this.transactions = const [],
    this.isLoading = false,
  });

  WalletState copyWith({
    double? balance,
    List<Map<String, dynamic>>? transactions,
    bool? isLoading,
  }) {
    return WalletState(
      balance: balance ?? this.balance,
      transactions: transactions ?? this.transactions,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

// Wallet provider using Riverpod
final walletProvider = StateNotifierProvider<WalletNotifier, WalletState>((
  ref,
) {
  return WalletNotifier();
});

class WalletNotifier extends StateNotifier<WalletState> {
  WalletNotifier() : super(WalletState());

  // Streams for reactive updates using RxDart
  final _balanceController = BehaviorSubject<double>.seeded(0.0);
  final _transactionsController =
      BehaviorSubject<List<Map<String, dynamic>>>.seeded([]);
  final _loadingController = BehaviorSubject<bool>.seeded(false);

  Stream<double> get balanceStream => _balanceController.stream;
  Stream<List<Map<String, dynamic>>> get transactionsStream =>
      _transactionsController.stream;
  Stream<bool> get isLoadingStream => _loadingController.stream;

  // Add funds
  void addFunds(double amount) {
    final newBalance = state.balance + amount;
    state = state.copyWith(balance: newBalance);
    _balanceController.add(newBalance);
  }

  // Deduct funds
  bool deductFunds(double amount) {
    if (state.balance >= amount) {
      final newBalance = state.balance - amount;
      state = state.copyWith(balance: newBalance);
      _balanceController.add(newBalance);
      return true;
    }
    return false;
  }

  // Add transaction
  void addTransaction(Map<String, dynamic> transaction) {
    final newTransactions = [...state.transactions, transaction];
    state = state.copyWith(transactions: newTransactions);
    _transactionsController.add(newTransactions);
  }

  // Set loading state
  void setLoading(bool isLoading) {
    state = state.copyWith(isLoading: isLoading);
    _loadingController.add(isLoading);
  }

  // Clear wallet
  void clearWallet() {
    state = state.copyWith(balance: 0.0, transactions: []);
    _balanceController.add(0.0);
    _transactionsController.add([]);
  }

  // Dispose controllers
  @override
  void dispose() {
    _balanceController.close();
    _transactionsController.close();
    _loadingController.close();
    super.dispose();
  }
}
