// lib/features/expense/presentation/widgets/total_summary_card.dart

import 'package:flutter/material.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/utils/utils.dart';

class TotalSummaryCard extends StatelessWidget {
  final double totalAmount;

  const TotalSummaryCard({
    super.key,
    required this.totalAmount,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16),
      color: AppColors.primary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide.none,
      ),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Total Expenses',
              style: AppTypography.labelMedium.copyWith(
                color: Colors.white70,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              CurrencyFormatter.format(totalAmount),
              style: AppTypography.amountLarge.copyWith(
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
