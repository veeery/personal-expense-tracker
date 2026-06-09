import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_expense.dart';
import 'expense_state.dart';

class ExpenseCubit extends Cubit<ExpenseState> {
  final GetExpenseUseCase getExpense;

  StreamSubscription? _subscription;

  ExpenseCubit({
    required this.getExpense,
  }) : super(ExpenseInitial());

  Future<void> load() async {
    emit(ExpenseLoading());
    try {
      await getExpense();
      emit(ExpenseLoaded(items: const []));
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
