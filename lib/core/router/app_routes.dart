import 'package:go_router/go_router.dart';

import '../../pages/shell/home/expense/add_expense_page.dart';
import '../../pages/shell/home/home_page.dart';
import '../../pages/not_found_page.dart';
import '../../pages/shell/home/transaction/transaction_detail_page.dart';
import '../../pages/shell/home/transaction/transaction_list_page.dart';
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
          name: TransactionListPage.route,
          path: TransactionListPage.route,
          builder: (context, state) => const TransactionListPage(),
          routes: [
            GoRoute(
              name: TransactionDetailPage.route,
              path: ':id',
              builder: (context, state) => TransactionDetailPage(
                id: state.pathParameters['id']!,
              ),
            ),
          ],
        ),
        GoRoute(
          name: AddExpensePage.route,
          path: AddExpensePage.route,
          builder: (context, state) => const AddExpensePage(),
        ),
      ],
    ),

// ── Detached — no shell ────────────────
    GoRoute(
      name: NotFoundPage.route,
      path: NotFoundPage.route,
      builder: (context, state) => const NotFoundPage(),
    ),
  ];
}
