// lib/core/enums/expense_category.dart

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
}
