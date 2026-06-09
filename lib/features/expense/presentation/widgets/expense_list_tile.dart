// lib/features/expense/presentation/widgets/expense_list_tile.dart

import 'package:flutter/material.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/utils/utils.dart';
import '../../domain/entities/entities.dart';
import 'category_color_helper.dart';

class ExpenseListTile extends StatelessWidget {
  final Expense expense;
  final VoidCallback onTap;

  const ExpenseListTile({
    super.key,
    required this.expense,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final categoryColor = CategoryColorHelper.colorFor(expense.category);
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        onTap: onTap,
        leading: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: categoryColor.withValues(alpha: 0.12),
            shape: BoxShape.circle,
          ),
          alignment: Alignment.center,
          child: Text(
            expense.category.emoji,
            style: const TextStyle(fontSize: 20),
          ),
        ),
        title: Text(
          expense.title,
          style: AppTypography.titleMedium,
        ),
        subtitle: Text(
          DateFormatter.format(expense.date),
          style: AppTypography.bodySmall.copyWith(
            color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
          ),
        ),
        trailing: Text(
          '-${CurrencyFormatter.format(expense.amount)}',
          style: AppTypography.amountSmall.copyWith(color: AppColors.error),
        ),
      ),
    );
  }
}
