// lib/pages/shell/home/settings/settings_page.dart

import 'package:flutter/material.dart';
import '../../../../core/theme/theme.dart';

class SettingsPage extends StatelessWidget {
  static const route = '/settings';

  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: Center(
        child: Text(
          'Settings — coming soon',
          style: AppTypography.bodyMedium,
        ),
      ),
    );
  }
}
