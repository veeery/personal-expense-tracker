// lib/pages/not_found_page.dart

import 'package:flutter/material.dart';

class NotFoundPage extends StatelessWidget {
  static const route = '/404';

  const NotFoundPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('404')),
      body: const Center(child: Text('Page not found')),
    );
  }
}