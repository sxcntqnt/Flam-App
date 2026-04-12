import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rxdart/rxdart.dart';

// Example of a Riverpod provider with RxDart for financial data
final financialDataProvider = StreamProvider<FinancialSummary>((ref) {
  // Using RxDart to combine multiple financial data streams
  final incomeStream = Stream.periodic(
    const Duration(seconds: 5),
    (count) =>
        IncomeData(amount: 1000.0 * (count + 1), source: 'Service $count'),
  );
  final expenseStream = Stream.periodic(
    const Duration(seconds: 7),
    (count) =>
        ExpenseData(amount: 500.0 * (count + 1), category: 'Category $count'),
  );

  return Rx.combineLatest2(
    incomeStream,
    expenseStream,
    (income, expense) => FinancialSummary(
      totalIncome: income.amount,
      totalExpense: expense.amount,
      netIncome: income.amount - expense.amount,
      lastUpdated: DateTime.now(),
    ),
  ).takeWhile((_) => !ref.isCancelled);
});

class IncomeData {
  final double amount;
  final String source;

  const IncomeData({required this.amount, required this.source});
}

class ExpenseData {
  final double amount;
  final String category;

  const ExpenseData({required this.amount, required this.category});
}

class FinancialSummary {
  final double totalIncome;
  final double totalExpense;
  final double netIncome;
  final DateTime lastUpdated;

  const FinancialSummary({
    required this.totalIncome,
    required this.totalExpense,
    required this.netIncome,
    required this.lastUpdated,
  });
}

class FinanceScreen extends ConsumerWidget {
  final String orgId;

  const FinanceScreen({Key? key, required this.orgId}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final financialAsync = ref.watch(financialDataProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('Finance - $orgId'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              ref.refresh(financialDataProvider);
            },
          ),
        ],
      ),
      body: financialAsync.when(
        data: (summary) => Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Org ID: $orgId',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 20),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Text(
                        'Financial Summary',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Total Income:'),
                          Text(
                            '\$${summary.totalIncome.toStringAsFixed(2)}',
                            style: const TextStyle(color: Colors.green),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Total Expense:'),
                          Text(
                            '\$${summary.totalExpense.toStringAsFixed(2)}',
                            style: const TextStyle(color: Colors.red),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Net Income:'),
                          Text(
                            '\$${summary.netIncome.toStringAsFixed(2)}',
                            style: TextStyle(
                              color: summary.netIncome >= 0
                                  ? Colors.green
                                  : Colors.red,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Last updated: ${summary.lastUpdated.toString().split('.')[0]}',
                        style: TextStyle(
                          color: Theme.of(context).textTheme.bodySmall?.color,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Financial data updates every 5-7 seconds using RxDart combineLatest',
              ),
            ],
          ),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) =>
            Center(child: Text('Error loading financial data: $error')),
      ),
    );
  }
}
