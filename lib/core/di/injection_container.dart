// lib/core/di/injection_container.dart

import 'package:get_it/get_it.dart';

import '../database/app_database.dart';
import '../../features/expense/data/datasources/expense_local_datasource.dart';
import '../../features/expense/data/repositories/expense_repository_impl.dart';
import '../../features/expense/domain/repositories/expense_repository.dart';
import '../../features/expense/domain/usecases/get_expense.dart';
import '../../features/expense/presentation/cubit/expense_cubit.dart';

final getIt = GetIt.instance;

Future<void> setupDependencies() async {
  // ── Database ──────────────────────────────
  getIt.registerLazySingleton<AppDatabase>(
    () => AppDatabase(),
  );

  // ── Datasources ───────────────────────────
  getIt.registerLazySingleton<ExpenseLocalDataSource>(
    () => ExpenseLocalDataSource(getIt<AppDatabase>()),
  );

  // ── Repositories ──────────────────────────
  getIt.registerLazySingleton<ExpenseRepository>(
    () => ExpenseRepositoryImpl(
      localDataSource: getIt<ExpenseLocalDataSource>(),
    ),
  );

  // ── UseCases ──────────────────────────────
  getIt.registerLazySingleton<GetExpenseUseCase>(
    () => GetExpenseUseCase(getIt<ExpenseRepository>()),
  );

  // ── Cubits — factory, bukan singleton ─────
  getIt.registerFactory<ExpenseCubit>(
    () => ExpenseCubit(
      getExpense: getIt<GetExpenseUseCase>(),
    ),
  );
}
