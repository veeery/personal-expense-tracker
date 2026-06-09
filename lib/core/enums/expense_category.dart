// lib/core/enums/expense_category.dart

import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

enum ExpenseCategory {
  food,
  transport,
  shopping,
  health,
  entertainment,
  other;

  String get label => switch (this) {
    ExpenseCategory.food => 'Food & Drink',
    ExpenseCategory.transport => 'Transport',
    ExpenseCategory.shopping => 'Shopping',
    ExpenseCategory.health => 'Health',
    ExpenseCategory.entertainment => 'Entertainment',
    ExpenseCategory.other => 'Other',
  };

  String get emoji => switch (this) {
    ExpenseCategory.food => '🍔',
    ExpenseCategory.transport => '🚗',
    ExpenseCategory.shopping => '🛍️',
    ExpenseCategory.health => '💊',
    ExpenseCategory.entertainment => '🎮',
    ExpenseCategory.other => '📦',
  };

  Color get color => switch (this) {
    ExpenseCategory.food => AppColors.categoryFood,
    ExpenseCategory.transport => AppColors.categoryTransport,
    ExpenseCategory.shopping => AppColors.categoryShopping,
    ExpenseCategory.health => AppColors.categoryHealth,
    ExpenseCategory.entertainment => AppColors.categoryEntertainment,
    ExpenseCategory.other => AppColors.categoryOther,
  };
}

