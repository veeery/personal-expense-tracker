// lib/pages/shell/home/expense/add_expense_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/di/injection_container.dart';
import '../../../../core/enums/enums.dart';
import '../../../../core/router/app_navigator.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/utils/utils.dart';
import '../../../../features/expense/expense.dart';

class AddExpensePage extends StatelessWidget {
  static const route = '/add';

  const AddExpensePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<ExpenseCubit>(),
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
        child: const _AddExpenseView(),
      ),
    );
  }
}

class _AddExpenseView extends StatefulWidget {
  const _AddExpenseView();

  @override
  State<_AddExpenseView> createState() => _AddExpenseViewState();
}

class _AddExpenseViewState extends State<_AddExpenseView> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  ExpenseCategory _selectedCategory = ExpenseCategory.food;

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
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
      final expense = Expense(
        id: const Uuid().v4(),
        title: _titleController.text.trim(),
        amount: double.parse(_amountController.text.trim()),
        date: _selectedDate,
        category: _selectedCategory,
        createdAt: DateTime.now(),
      );
      context.read<ExpenseCubit>().add(expense);
      AppNavigator.pop(context: context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Expense'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Name of Product',
                hintText: 'ex: Coffee, Banana and etc',
              ),
              style: AppTypography.bodyLarge,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Product name cannot be empty';
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
                text: DateFormatter.format(_selectedDate),
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
}
