// lib/pages/shell/home/expense/edit_expense_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/injection_container.dart';
import '../../../../core/enums/enums.dart';
import '../../../../core/router/app_navigator.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/utils/utils.dart';
import '../../../../features/expense/expense.dart';

class EditExpensePage extends StatelessWidget {
  static const route = 'edit';

  final String id;

  const EditExpensePage({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<ExpenseCubit>()..load(),
      child: BlocListener<ExpenseCubit, ExpenseState>(
        listenWhen: (previous, current) => current is ExpenseError,
        listener: (context, state) {
          if (state is ExpenseError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: AppColors.error,
              ),
            );
          }
        },
        child: _EditExpenseView(id: id),
      ),
    );
  }
}

class _EditExpenseView extends StatefulWidget {
  final String id;

  const _EditExpenseView({required this.id});

  @override
  State<_EditExpenseView> createState() => _EditExpenseViewState();
}

class _EditExpenseViewState extends State<_EditExpenseView> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  DateTime? _selectedDate;
  ExpenseCategory? _selectedCategory;
  bool _initialized = false;
  DateTime? _createdAt;

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  void _initFieldsOnce(Expense expense) {
    if (_initialized) return;
    _titleController.text = expense.title;
    _amountController.text = expense.amount.toStringAsFixed(0);
    _selectedDate = expense.date;
    _selectedCategory = expense.category;
    _createdAt = expense.createdAt;
    _initialized = true;
  }

  Future<void> _selectDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      final updatedExpense = Expense(
        id: widget.id,
        title: _titleController.text.trim(),
        amount: double.parse(_amountController.text.trim()),
        date: _selectedDate!,
        category: _selectedCategory!,
        createdAt: _createdAt!,
      );
      context.read<ExpenseCubit>().update(updatedExpense);
      AppNavigator.pop(context: context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ExpenseCubit, ExpenseState>(
      builder: (context, state) {
        if (state is ExpenseInitial || state is ExpenseLoading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (state is ExpenseError) {
          return Scaffold(
            appBar: AppBar(title: const Text('Edit Expense')),
            body: Center(
              child: Text(
                state.message,
                style: AppTypography.bodyMedium.copyWith(color: AppColors.error),
              ),
            ),
          );
        }

        if (state is ExpenseLoaded) {
          final expense = state.items.cast<Expense?>().firstWhere(
                (item) => item?.id == widget.id,
                orElse: () => null,
              );

          if (expense == null) {
            return Scaffold(
              appBar: AppBar(title: const Text('Edit Expense')),
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Expense not found',
                      style: AppTypography.titleMedium,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => AppNavigator.pop(context: context),
                      child: const Text('Back'),
                    ),
                  ],
                ),
              ),
            );
          }

          _initFieldsOnce(expense);

          return Scaffold(
            appBar: AppBar(
              title: const Text('Edit Expense'),
            ),
            body: Form(
              key: _formKey,
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  TextFormField(
                    controller: _titleController,
                    decoration: const InputDecoration(
                      labelText: 'Title',
                      hintText: 'Enter title',
                    ),
                    style: AppTypography.bodyLarge,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Title cannot be empty';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _amountController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Amount',
                      hintText: 'Enter amount',
                      prefixText: 'Rp ',
                    ),
                    style: AppTypography.bodyLarge,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Amount cannot be empty';
                      }
                      final amount = double.tryParse(value);
                      if (amount == null || amount <= 0) {
                        return 'Enter a valid amount';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    readOnly: true,
                    controller: TextEditingController(
                      text: _selectedDate != null
                          ? DateFormatter.format(_selectedDate!)
                          : '',
                    ),
                    decoration: const InputDecoration(
                      labelText: 'Date',
                      suffixIcon: Icon(Icons.calendar_today),
                    ),
                    style: AppTypography.bodyLarge,
                    onTap: () => _selectDate(context),
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<ExpenseCategory>(
                    initialValue: _selectedCategory,
                    decoration: const InputDecoration(
                      labelText: 'Category',
                    ),
                    style: AppTypography.bodyLarge,
                    items: ExpenseCategory.values.map((category) {
                      return DropdownMenuItem<ExpenseCategory>(
                        value: category,
                        child: Row(
                          children: [
                            Text(category.emoji),
                            const SizedBox(width: 8),
                            Text(
                              category.label,
                              style: AppTypography.bodyLarge,
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          _selectedCategory = value;
                        });
                      }
                    },
                  ),
                  const SizedBox(height: 32),
                  ElevatedButton(
                    onPressed: _submit,
                    child: const Text('Save'),
                  ),
                ],
              ),
            ),
          );
        }

        return const SizedBox.shrink();
      },
    );
  }
}
