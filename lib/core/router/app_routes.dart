// lib/core/router/app_routes.dart

import 'package:go_router/go_router.dart';

import '../../pages/shell/home/expense/add_expense_page.dart';
import '../../pages/shell/home/expense/edit_expense_page.dart';
import '../../pages/shell/home/home_page.dart';
import '../../pages/not_found_page.dart';
import '../../pages/shell/home/settings/settings_page.dart';
import '../../pages/shell/home/transaction/transaction_detail_page.dart';
import 'main_shell.dart';

class AppRoutes {
  AppRoutes._();

  static final List<RouteBase> routes = [
    // ── Shell — bottom nav ─────────────────
    ShellRoute(
      builder: (context, state, child) => MainShell(child: child),
      routes: [
        GoRoute(
          name: HomePage.route,
          path: HomePage.route,
          builder: (context, state) => const HomePage(),
        ),
        GoRoute(
          name: SettingsPage.route,
          path: SettingsPage.route,
          builder: (context, state) => const SettingsPage(),
        ),
      ],
    ),

    // ── Detached — no shell ────────────────
    GoRoute(
      name: AddExpensePage.route,
      path: AddExpensePage.route,
      builder: (context, state) => const AddExpensePage(),
    ),
    GoRoute(
      path: '/transactions/:id',
      builder: (context, state) => TransactionDetailPage(
        id: state.pathParameters['id']!,
      ),
      routes: [
        GoRoute(
          name: EditExpensePage.route,
          path: 'edit',
          builder: (context, state) => EditExpensePage(
            id: state.pathParameters['id']!,
          ),
        ),
      ],
    ),
    GoRoute(
      name: NotFoundPage.route,
      path: NotFoundPage.route,
      builder: (context, state) => const NotFoundPage(),
    ),
  ];
}
