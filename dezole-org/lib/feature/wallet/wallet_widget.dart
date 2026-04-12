import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ridesharing/common/theme.dart';
import 'package:ridesharing/feature/wallet/wallet_provider.dart';

class WalletWidget extends ConsumerWidget {
  const WalletWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final walletState = ref.watch(walletProvider);

    return Scaffold(
      backgroundColor: CustomTheme.lightColor,
      appBar: AppBar(
        title: const Text('Wallet'),
        backgroundColor: CustomTheme.appColor,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () {
              // Show transaction history
            },
          ),
        ],
      ),
      body: walletState.isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Wallet Balance',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: CustomTheme.darkColor,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          CustomTheme.appColor,
                          CustomTheme.appColor.withOpacity(0.8),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      children: [
                        Text(
                          '\$${walletState.balance.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Available Balance',
                          style: TextStyle(fontSize: 16, color: Colors.white70),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Recent Transactions',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: CustomTheme.darkColor,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Expanded(
                    child: walletState.transactions.isEmpty
                        ? const Center(child: Text('No transactions yet'))
                        : ListView.builder(
                            itemCount: walletState.transactions.length,
                            itemBuilder: (context, index) {
                              final transaction =
                                  walletState.transactions[index];
                              final isCredit = transaction['type'] == 'credit';
                              return ListTile(
                                leading: CircleAvatar(
                                  backgroundColor: isCredit
                                      ? Colors.green
                                      : Colors.red,
                                  child: Icon(
                                    isCredit
                                        ? Icons.arrow_circle_up
                                        : Icons.arrow_circle_down,
                                    color: Colors.white,
                                  ),
                                ),
                                title: Text(
                                  transaction['description'] ?? 'Transaction',
                                  style: TextStyle(fontWeight: FontWeight.w500),
                                ),
                                subtitle: Text(
                                  transaction['date'] ?? '',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey,
                                  ),
                                ),
                                trailing: Text(
                                  '${isCredit ? '+' : '-'}\$${transaction['amount'].toStringAsFixed(2)}',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: isCredit ? Colors.green : Colors.red,
                                  ),
                                ),
                              );
                            },
                          ),
                  ),
                ],
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Add funds for demo
          ref.read(walletProvider.notifier).addFunds(50.0);
          ref.read(walletProvider.notifier).addTransaction({
            'id': DateTime.now().millisecondsSinceEpoch.toString(),
            'type': 'credit',
            'description': 'Added funds',
            'amount': 50.0,
            'date': 'Today',
          });
        },
        backgroundColor: CustomTheme.appColor,
        child: const Icon(Icons.add),
      ),
    );
  }
}
