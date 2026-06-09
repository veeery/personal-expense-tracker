// lib/core/router/main_shell.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../pages/shell/home/expense/add_expense_page.dart';
import '../../pages/shell/home/home_page.dart';
import '../../pages/shell/home/settings/settings_page.dart';
import 'app_navigator.dart';

class MainShell extends StatelessWidget {
  final Widget child;

  const MainShell({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();

    return Scaffold(
      body: child,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _locationToIndex(location),
        onTap: (index) => _onTap(context, index),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings_outlined),
            activeIcon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => AppNavigator.push(
          context: context,
          path: AddExpensePage.route,
        ),
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  int _locationToIndex(String location) {
    if (location.startsWith(HomePage.route)) return 0;
    if (location.startsWith(SettingsPage.route)) return 1;
    return 0;
  }

  void _onTap(BuildContext context, int index) {
    switch (index) {
      case 0:
        AppNavigator.go(context: context, path: HomePage.route);
      case 1:
        AppNavigator.go(context: context, path: SettingsPage.route);
    }
  }
}
