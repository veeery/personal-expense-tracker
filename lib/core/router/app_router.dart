// lib/core/router/app_router.dart

import 'package:go_router/go_router.dart';
import '../../pages/not_found_page.dart';
import '../../pages/shell/home/home_page.dart';
import 'app_routes.dart';

final appRouter = GoRouter(
  initialLocation: HomePage.route,
  routes: AppRoutes.routes,
  errorBuilder: (context, state) => const NotFoundPage(),
);