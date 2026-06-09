// lib/features/expense/domain/usecases/add_expense_usecase.dart

import '../entities/entities.dart';
import '../repositories/expense_repository.dart';

class AddExpenseUseCase {
  final ExpenseRepository repository;

  const AddExpenseUseCase(this.repository);

  Future<void> call(Expense expense) {
    return repository.add(expense);
  }
}
