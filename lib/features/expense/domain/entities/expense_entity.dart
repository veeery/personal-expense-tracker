// lib/features/expense/domain/entities/expense_entity.dart

import 'package:equatable/equatable.dart';
import '../../../../core/enums/enums.dart';

class Expense extends Equatable {
  final String id;
  final String title;
  final double amount;
  final DateTime date;
  final ExpenseCategory category;
  final DateTime createdAt;

  const Expense({
    required this.id,
    required this.title,
    required this.amount,
    required this.date,
    required this.category,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [id, title, amount, date, category, createdAt];
}