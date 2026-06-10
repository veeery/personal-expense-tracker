import 'package:drift/drift.dart';
import '../../../../core/database/app_database.dart';
import '../models/expense_model.dart';
import '../../domain/entities/entities.dart';

class ExpenseLocalDataSource {
  final AppDatabase database;

  const ExpenseLocalDataSource(this.database);

  Stream<List<Expense>> watchAll() {
    return (database.select(database.expenseTable)
          ..orderBy([(t) => OrderingTerm.desc(t.date)]))
        .watch()
        .map((rows) => rows.map((r) => r.toEntity()).toList());
  }

  Future<void> insert(Expense expense) {
    return database
        .into(database.expenseTable)
        .insert(expense.toCompanion());
  }

  Future<void> update(Expense expense) {
    return (database.update(database.expenseTable)
          ..where((t) => t.id.equals(expense.id)))
        .write(expense.toCompanion());
  }

  Future<void> delete(String id) {
    return (database.delete(database.expenseTable)
          ..where((t) => t.id.equals(id)))
        .go();
  }
}
