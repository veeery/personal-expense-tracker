import 'package:flutter/material.dart';

class TransactionDetailPage extends StatelessWidget {
  static const route = 'detail';

  final String id;

  const TransactionDetailPage({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Detail')),
      body: Center(child: Text('Expense ID: $id')),
    );
  }
}
