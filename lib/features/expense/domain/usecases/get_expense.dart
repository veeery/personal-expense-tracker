import '../entities/entities.dart';
import '../repositories/expense_repository.dart';

class GetExpenseUseCase {
  final ExpenseRepository repository;

  const GetExpenseUseCase(this.repository);

  Future<void> call() async {
    // TODO: implement
  }
}
