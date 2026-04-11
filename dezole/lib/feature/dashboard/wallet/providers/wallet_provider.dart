import 'package:flutter_riverpod/flutter_riverpod.dart';

enum PaymentMethod { visa, mastercard, paypal, cashApp }

class Transaction {
  final String id;
  final String name;
  final double amount;
  final String date;
  final bool isCredit;

  const Transaction({
    required this.id,
    required this.name,
    required this.amount,
    required this.date,
    required this.isCredit,
  });
}

class WalletState {
  final double availableBalance;
  final double totalExpenditure;
  final PaymentMethod selectedMethod;
  final bool isLoading;
  final String? error;
  final List<Transaction> transactions;

  const WalletState({
    this.availableBalance = 500,
    this.totalExpenditure = 200,
    this.selectedMethod = PaymentMethod.visa,
    this.isLoading = false,
    this.error,
    this.transactions = const [],
  });

  WalletState copyWith({
    double? availableBalance,
    double? totalExpenditure,
    PaymentMethod? selectedMethod,
    bool? isLoading,
    String? error,
    List<Transaction>? transactions,
  }) {
    return WalletState(
      availableBalance: availableBalance ?? this.availableBalance,
      totalExpenditure: totalExpenditure ?? this.totalExpenditure,
      selectedMethod: selectedMethod ?? this.selectedMethod,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      transactions: transactions ?? this.transactions,
    );
  }
}

class WalletNotifier extends StateNotifier<WalletState> {
  WalletNotifier() : super(const WalletState()) {
    _loadTransactions();
  }

  void _loadTransactions() {
    state = state.copyWith(
      transactions: [
        const Transaction(
          id: '1',
          name: 'Welton',
          amount: 570,
          date: 'Today at 09:20 am',
          isCredit: false,
        ),
        const Transaction(
          id: '2',
          name: 'Top Up',
          amount: 200,
          date: 'Today at 08:00 am',
          isCredit: true,
        ),
        const Transaction(
          id: '3',
          name: 'Welton',
          amount: 150,
          date: 'Yesterday at 06:30 pm',
          isCredit: false,
        ),
        const Transaction(
          id: '4',
          name: 'Welton',
          amount: 80,
          date: 'Yesterday at 02:15 pm',
          isCredit: false,
        ),
        const Transaction(
          id: '5',
          name: 'Top Up',
          amount: 500,
          date: '2 days ago',
          isCredit: true,
        ),
      ],
    );
  }

  void selectPaymentMethod(PaymentMethod method) {
    state = state.copyWith(selectedMethod: method);
  }

  Future<bool> addMoney(double amount) async {
    state = state.copyWith(isLoading: true, error: null);
    await Future.delayed(const Duration(seconds: 1));
    state = state.copyWith(
      isLoading: false,
      availableBalance: state.availableBalance + amount,
      transactions: [
        Transaction(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          name: 'Top Up',
          amount: amount,
          date: 'Just now',
          isCredit: true,
        ),
        ...state.transactions,
      ],
    );
    return true;
  }

  Future<bool> deductMoney(double amount) async {
    if (state.availableBalance < amount) {
      state = state.copyWith(error: 'Insufficient balance');
      return false;
    }
    state = state.copyWith(
      availableBalance: state.availableBalance - amount,
      totalExpenditure: state.totalExpenditure + amount,
    );
    return true;
  }
}

final walletProvider = StateNotifierProvider<WalletNotifier, WalletState>((
  ref,
) {
  return WalletNotifier();
});

final balanceProvider = Provider<double>((ref) {
  return ref.watch(walletProvider).availableBalance;
});
