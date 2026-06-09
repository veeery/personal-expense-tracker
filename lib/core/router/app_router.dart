// lib/core/router/app_router.dart

import 'package:go_router/go_router.dart';
import '../../pages/not_found_page.dart';
import 'app_routes.dart';

final appRouter = GoRouter(
  initialLocation: TransactionListPageRoute,
  routes: AppRoutes.routes,
  errorBuilder: (context, state) => const NotFoundPage(),
);

// Route constants — referenced di AppRoutes dan pages
const TransactionListPageRoute = '/transactions';