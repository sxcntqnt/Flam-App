import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ridesharing/common/theme.dart';
import 'package:ridesharing/feature/fuel/fuel_provider.dart';

class FuelWidget extends ConsumerWidget {
  const FuelWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final fuelState = ref.watch(fuelProvider);

    return Scaffold(
      backgroundColor: CustomTheme.lightColor,
      appBar: AppBar(
        title: const Text('Fuel'),
        backgroundColor: CustomTheme.appColor,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Fuel Balance',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: CustomTheme.darkColor,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '\$${fuelState.balance.toStringAsFixed(2)}',
              style: const TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: CustomTheme.appColor,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Current Fuel Price',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: CustomTheme.darkColor,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '\$${fuelState.currentPrice.toStringAsFixed(2)} per gallon',
              style: const TextStyle(
                fontSize: 20,
                color: CustomTheme.darkColor,
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
              child: fuelState.recentTransactions.isEmpty
                  ? const Center(child: Text('No transactions yet'))
                  : ListView.builder(
                      itemCount: fuelState.recentTransactions.length,
                      itemBuilder: (context, index) {
                        final transaction = fuelState.recentTransactions[index];
                        return ListTile(
                          title: Text(transaction),
                          trailing: const Icon(
                            Icons.arrow_forward_ios,
                            size: 16,
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
          // Add sample transaction for demo
          ref
              .read(fuelProvider.notifier)
              .addTransaction('Fuel purchase - \$25.00');
          ref
              .read(fuelProvider.notifier)
              .updateBalance(
                ref.read(fuelProvider.notifier).state.balance + 25.0,
              );
        },
        backgroundColor: CustomTheme.appColor,
        child: const Icon(Icons.add),
      ),
    );
  }
}
