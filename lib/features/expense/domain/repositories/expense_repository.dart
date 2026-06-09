import '../entities/entities.dart';

abstract class ExpenseRepository {
  Stream<List<Expense>> watchAll();
  Future<void> add(Expense expense);
  Future<void> update(Expense expense);
  Future<void> delete(String id);
}
