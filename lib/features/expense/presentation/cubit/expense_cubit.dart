import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/entities.dart';
import '../../domain/usecases/usecases.dart';
import 'expense_state.dart';

class ExpenseCubit extends Cubit<ExpenseState> {
  final WatchExpensesUseCase watchExpenses;
  final AddExpenseUseCase addExpense;
  final UpdateExpenseUseCase updateExpense;
  final DeleteExpenseUseCase deleteExpense;

  StreamSubscription<List<Expense>>? _subscription;

  ExpenseCubit({
    required this.watchExpenses,
    required this.addExpense,
    required this.updateExpense,
    required this.deleteExpense,
  }) : super(const ExpenseInitial());

  void load() {
    emit(const ExpenseLoading());
    _subscription?.cancel();
    _subscription = watchExpenses().listen(
      (expenses) => emit(ExpenseLoaded(items: expenses)),
      onError: (e) => emit(ExpenseError(e.toString())),
    );
  }

  Future<void> add(Expense expense) async {
    try {
      await addExpense(expense);
    } catch (e) {
      emit(ExpenseError(e.toString()));
    }
  }

  Future<void> update(Expense expense) async {
    try {
      await updateExpense(expense);
    } catch (e) {
      emit(ExpenseError(e.toString()));
    }
  }

  Future<void> delete(String id) async {
    try {
      await deleteExpense(id);
    } catch (e) {
      emit(ExpenseError(e.toString()));
    }
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
