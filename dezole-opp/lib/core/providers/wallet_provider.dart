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

class WalletState {
  final double availableBalance;
  final double totalSpent;
  final PaymentMethod selectedMethod;
  final bool isLoading;
  final String? error;
  final List<Transaction> transactions;

  const WalletState({
    this.availableBalance = 0.0,
    this.totalSpent = 0.0,
    this.selectedMethod = PaymentMethod.wallet,
    this.isLoading = false,
    this.error,
    this.transactions = const [],
  });

  WalletState copyWith({
    double? availableBalance,
    double? totalSpent,
    PaymentMethod? selectedMethod,
    bool? isLoading,
    String? error,
    List<Transaction>? transactions,
  }) {
    return WalletState(
      availableBalance: availableBalance ?? this.availableBalance,
      totalSpent: totalSpent ?? this.totalSpent,
      selectedMethod: selectedMethod ?? this.selectedMethod,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      transactions: transactions ?? this.transactions,
    );
  }
}

class Transaction {
  final String id;
  final String type;
  final double amount;
  final String description;
  final DateTime createdAt;

  const Transaction({
    required this.id,
    required this.type,
    required this.amount,
    required this.description,
    required this.createdAt,
  });
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
        totalSpent: 2500.0,
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

  Future<void> topUp(double amount) async {
    state = state.copyWith(isLoading: true);

    try {
      await Future.delayed(const Duration(milliseconds: 300));
      
      final newTransaction = Transaction(
        id: 'txn-${DateTime.now().millisecondsSinceEpoch}',
        type: 'TOP_UP',
        amount: amount,
        description: 'Wallet top up',
        createdAt: DateTime.now(),
      );

      state = state.copyWith(
        availableBalance: state.availableBalance + amount,
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

  Future<void> pay(double amount) async {
    if (state.availableBalance < amount) {
      state = state.copyWith(error: 'Insufficient balance');
      return;
    }

    state = state.copyWith(isLoading: true);

    try {
      await Future.delayed(const Duration(milliseconds: 300));
      
      final newTransaction = Transaction(
        id: 'txn-${DateTime.now().millisecondsSinceEpoch}',
        type: 'PAYMENT',
        amount: amount,
        description: 'Ride payment',
        createdAt: DateTime.now(),
      );

      state = state.copyWith(
        availableBalance: state.availableBalance - amount,
        totalSpent: state.totalSpent + amount,
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
    state = state.copyWith(selectedMethod: method);
    _walletStateSubject.add(state);
  }
}

final walletProvider = StateNotifierProvider<WalletNotifier, WalletState>((ref) {
  return WalletNotifier();
});

final balanceProvider = Provider<double>((ref) {
  final wallet = ref.watch(walletProvider);
  return wallet.availableBalance;
});