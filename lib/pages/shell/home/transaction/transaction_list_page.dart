import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/injection_container.dart';
import '../../../../core/router/app_navigator.dart';
import '../../../../core/theme/theme.dart';
import '../../../../features/expense/expense.dart';

class TransactionListPage extends StatelessWidget {
  static const route = '/transactions';

  const TransactionListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<ExpenseCubit>()..load(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Transactions'),
        ),
        body: BlocBuilder<ExpenseCubit, ExpenseState>(
          builder: (context, state) {
            return switch (state) {
              ExpenseInitial() || ExpenseLoading() => const Center(
                  child: CircularProgressIndicator(),
                ),
              ExpenseError(:final message) => Center(
                  child: Text(
                    message,
                    style: AppTypography.bodyMedium.copyWith(
                      color: AppColors.error,
                    ),
                  ),
                ),
              ExpenseLoaded(:final items) => items.isEmpty
                  ? const EmptyExpenseWidget()
                  : Column(
                      children: [
                        TotalSummaryCard(
                          totalAmount: items.fold<double>(
                            0.0,
                            (sum, item) => sum + item.amount,
                          ),
                        ),
                        Expanded(
                          child: ListView.builder(
                            itemCount: items.length,
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            itemBuilder: (context, index) {
                              final expense = items[index];
                              return ExpenseListTile(
                                expense: expense,
                                onTap: () => AppNavigator.goTransactionDetail(
                                  context,
                                  expense.id,
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
            };
          },
        ),
      ),
    );
  }
}
