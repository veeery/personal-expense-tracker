// lib/features/expense/domain/usecases/watch_expenses_usecase.dart

import '../entities/entities.dart';
import '../repositories/expense_repository.dart';

class WatchExpensesUseCase {
  final ExpenseRepository repository;

  const WatchExpensesUseCase(this.repository);

  Stream<List<Expense>> call() {
    return repository.watchAll();
  }
}
