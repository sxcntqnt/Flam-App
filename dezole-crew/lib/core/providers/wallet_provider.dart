import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rxdart/rxdart.dart';

enum PaymentMethod {
  visa,
  mastercard,
  paypal,
  cashApp,
  wallet,
  mPesa,
}

class Transaction {
  final String id;
  final String type;
  final double amount;
  final String description;
  final DateTime createdAt;
  final bool isSuccessful;

  const Transaction({
    required this.id,
    required this.type,
    required this.amount,
    required this.description,
    required this.createdAt,
    this.isSuccessful = true,
  });
}

class WalletState {
  final double availableBalance;
  final double totalEarnings;
  final double todayEarnings;
  final PaymentMethod selectedMethod;
  final bool isLoading;
  final String? error;
  final List<Transaction> transactions;

  const WalletState({
    this.availableBalance = 0.0,
    this.totalEarnings = 0.0,
    this.todayEarnings = 0.0,
    this.selectedMethod = PaymentMethod.wallet,
    this.isLoading = false,
    this.error,
    this.transactions = const [],
  });

  WalletState copyWith({
    double? availableBalance,
    double? totalEarnings,
    double? todayEarnings,
    PaymentMethod? selectedMethod,
    bool? isLoading,
    String? error,
    List<Transaction>? transactions,
  }) {
    return WalletState(
      availableBalance: availableBalance ?? this.availableBalance,
      totalEarnings: totalEarnings ?? this.totalEarnings,
      todayEarnings: todayEarnings ?? this.todayEarnings,
      selectedMethod: selectedMethod ?? this.selectedMethod,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      transactions: transactions ?? this.transactions,
    );
  }
}

class WalletNotifier extends StateNotifier<WalletState> {
  WalletNotifier() : super(const WalletState());

  final _walletStateSubject = BehaviorSubject<WalletState>.seeded(const WalletState());
  
  Stream<WalletState> get walletStateStream => _walletStateSubject.stream;

  Future<void> loadWallet() async {
    state = state.copyWith(isLoading: true);
    _walletStateSubject.add(state.copyWith(isLoading: true));

    try {
      await Future.delayed(const Duration(milliseconds: 500));
      
      state = state.copyWith(
        availableBalance: 5000.0,
        totalEarnings: 25000.0,
        todayEarnings: 850.0,
        isLoading: false,
      );
      _walletStateSubject.add(state);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
      _walletStateSubject.add(state);
    }
  }

  Future<void> addEarnings(double amount) async {
    state = state.copyWith(isLoading: true);

    try {
      await Future.delayed(const Duration(milliseconds: 300));
      
      final newTransaction = Transaction(
        id: 'txn-${DateTime.now().millisecondsSinceEpoch}',
        type: 'EARNINGS',
        amount: amount,
        description: 'Trip earnings',
        createdAt: DateTime.now(),
      );

      state = state.copyWith(
        availableBalance: state.availableBalance + amount,
        totalEarnings: state.totalEarnings + amount,
        todayEarnings: state.todayEarnings + amount,
        isLoading: false,
        transactions: [newTransaction, ...state.transactions],
      );
      _walletStateSubject.add(state);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
      _walletStateSubject.add(state);
    }
  }

  void selectPaymentMethod(PaymentMethod method) {
    state = state.copyWith(selectedPaymentMethod: method);
    _walletStateSubject.add(state);
  }

  void clearError() {
    state = state.copyWith(error: null);
    _walletStateSubject.add(state);
  }
}

final walletProvider = StateNotifierProvider<WalletNotifier, WalletState>((ref) {
  return WalletNotifier();
});

final walletBalanceProvider = Provider<double>((ref) {
  final wallet = ref.watch(walletProvider);
  return wallet.availableBalance;
});

final walletIsLoadingProvider = Provider<bool>((ref) {
  final wallet = ref.watch(walletProvider);
  return wallet.isLoading;
});