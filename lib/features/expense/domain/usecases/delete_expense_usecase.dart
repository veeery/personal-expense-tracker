// lib/features/expense/domain/usecases/delete_expense_usecase.dart

import '../repositories/expense_repository.dart';

class DeleteExpenseUseCase {
  final ExpenseRepository repository;

  const DeleteExpenseUseCase(this.repository);

  Future<void> call(String id) {
    return repository.delete(id);
  }
}
