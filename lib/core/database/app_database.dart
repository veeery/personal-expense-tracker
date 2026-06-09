// lib/core/database/app_database.dart

import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../enums/enums.dart';

part 'app_database.g.dart';

// ─────────────────────────────────────────
// TABLE DEFINITION
// ─────────────────────────────────────────

class ExpenseTable extends Table {
  TextColumn get id => text()();

  TextColumn get title => text()();

  RealColumn get amount => real()();

  DateTimeColumn get date => dateTime()();

  TextColumn get category => text().map(
    const EnumNameConverter<ExpenseCategory>(ExpenseCategory.values),
  )();

  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}

// ─────────────────────────────────────────
// DATABASE
// ─────────────────────────────────────────

@DriftDatabase(tables: [ExpenseTable])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  AppDatabase.forTesting(super.executor);

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) async {
      await m.createAll();
    },
    onUpgrade: (m, from, to) async {
      // TODO: handle migrations when schemaVersion increases
    },
  );
}

// ─────────────────────────────────────────
// CONNECTION
// ─────────────────────────────────────────

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File(p.join(dir.path, 'expense_tracker.db'));
    return NativeDatabase.createInBackground(file);
  });
}
