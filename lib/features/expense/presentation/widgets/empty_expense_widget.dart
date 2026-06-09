// lib/features/expense/presentation/widgets/empty_expense_widget.dart

import 'package:flutter/material.dart';
import '../../../../core/theme/theme.dart';

class EmptyExpenseWidget extends StatelessWidget {
  const EmptyExpenseWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.receipt_long,
              size: 64,
              color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.3),
            ),
            const SizedBox(height: 16),
            Text(
              'No expenses yet',
              style: AppTypography.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              'Tap + to add your first expense',
              style: AppTypography.bodySmall.copyWith(
                color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
