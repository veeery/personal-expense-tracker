import 'package:flutter/material.dart';

class TransactionListPage extends StatelessWidget {

  static const route = '/transactions';

  const TransactionListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Transactions')),
      body: const Center(child: Text('Transaction List')),
    );
  }
}
