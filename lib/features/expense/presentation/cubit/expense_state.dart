import 'package:equatable/equatable.dart';
import '../../domain/entities/entities.dart';

sealed class ExpenseState extends Equatable {
  const ExpenseState();
}

class ExpenseInitial extends ExpenseState {
  @override
  List<Object?> get props => [];
}

class ExpenseLoading extends ExpenseState {
  @override
  List<Object?> get props => [];
}

class ExpenseLoaded extends ExpenseState {
  final List<Expense> items;

  const ExpenseLoaded({required this.items});

  @override
  List<Object?> get props => [items];
}

class ExpenseError extends ExpenseState {
  final String message;

  const ExpenseError(this.message);

  @override
  List<Object?> get props => [message];
}
