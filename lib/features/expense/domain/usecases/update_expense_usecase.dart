// lib/features/expense/domain/usecases/update_expense_usecase.dart

import '../entities/entities.dart';
import '../repositories/expense_repository.dart';

class UpdateExpenseUseCase {
  final ExpenseRepository repository;

  const UpdateExpenseUseCase(this.repository);

  Future<void> call(Expense expense) {
    return repository.update(expense);
  }
}
