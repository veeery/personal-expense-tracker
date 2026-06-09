// lib/pages/shell/home/settings/settings_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/theme/theme.dart';
import '../../../features/theme/theme.dart';

class SettingsPage extends StatelessWidget {
  static const route = '/settings';

  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: BlocBuilder<ThemeCubit, ThemeState>(
        builder: (context, state) {
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Text(
                'Appearance',
                style: AppTypography.labelMedium.copyWith(
                  color: colorScheme.onSurface.withValues(alpha: 0.6),
                ),
              ),
              const SizedBox(height: 8),
              Card(
                child: SwitchListTile(
                  title: Text(
                    'Dark Mode',
                    style: AppTypography.titleMedium,
                  ),
                  subtitle: Text(
                    'Switch between light and dark theme',
                    style: AppTypography.bodySmall.copyWith(
                      color: colorScheme.onSurface.withValues(alpha: 0.6),
                    ),
                  ),
                  value: state.themeMode == ThemeMode.dark,
                  onChanged: (isDark) => context.read<ThemeCubit>().setTheme(
                    isDark ? ThemeMode.dark : ThemeMode.light,
                  ),
                  secondary: Icon(
                    state.themeMode == ThemeMode.dark
                        ? Icons.dark_mode
                        : Icons.light_mode,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
