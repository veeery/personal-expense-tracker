import '../../domain/entities/entities.dart';
import '../../domain/repositories/expense_repository.dart';
import '../datasources/expense_local_datasource.dart';

class ExpenseRepositoryImpl implements ExpenseRepository {
  final ExpenseLocalDataSource localDataSource;

  const ExpenseRepositoryImpl({required this.localDataSource});

  @override
  Stream<List<Expense>> watchAll() {
    return localDataSource.watchAll();
  }

  @override
  Future<void> add(Expense expense) => localDataSource.insert(expense);

  @override
  Future<void> update(Expense expense) => localDataSource.update(expense);

  @override
  Future<void> delete(String id) => localDataSource.delete(id);
}
