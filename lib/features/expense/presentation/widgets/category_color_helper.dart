// lib/features/expense/presentation/widgets/category_color_helper.dart

import 'package:flutter/material.dart';
import '../../../../core/enums/enums.dart';
import '../../../../core/theme/theme.dart';

class CategoryColorHelper {
  CategoryColorHelper._();

  static Color colorFor(ExpenseCategory cat) {
    return switch (cat) {
      ExpenseCategory.food => AppColors.categoryFood,
      ExpenseCategory.transport => AppColors.categoryTransport,
      ExpenseCategory.shopping => AppColors.categoryShopping,
      ExpenseCategory.health => AppColors.categoryHealth,
      ExpenseCategory.entertainment => AppColors.categoryEntertainment,
      ExpenseCategory.other => AppColors.categoryOther,
    };
  }
}
