// lib/core/router/app_navigator.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppNavigator {
  AppNavigator._();

  /// Push — tambah ke stack
  static Future<T?> push<T>({
    required BuildContext context,
    required String path,
    Object? args,
  }) async {
    return await context.push<T>(path, extra: args);
  }

  /// Go — replace entire stack
  static void go({
    required BuildContext context,
    required String path,
    Object? args,
  }) {
    context.go(path, extra: args);
  }

  /// Replace — replace current route
  static void replace({
    required BuildContext context,
    required String path,
    Object? args,
  }) {
    GoRouter.of(context).replace(path, extra: args);
  }

  /// Pop
  static void pop<T>({
    required BuildContext context,
    T? result,
  }) {
    context.pop(result);
  }

  /// Pop multiple times
  static void popTimes({
    required BuildContext context,
    required int count,
  }) {
    for (var i = 0; i < count && context.canPop(); i++) {
      context.pop();
    }
  }

  /// Pop then push
  static Future<T?> popAndPush<T>({
    required BuildContext context,
    required int popCount,
    required String path,
    Object? args,
  }) async {
    assert(popCount >= 0);
    for (var i = 0; i < popCount && context.canPop(); i++) {
      context.pop();
    }
    return await context.push<T>(path, extra: args);
  }

  /// Pop then replace
  static void popAndReplace({
    required BuildContext context,
    required int popCount,
    required String path,
    Object? args,
  }) {
    assert(popCount >= 1);
    for (var i = 1; i < popCount && context.canPop(); i++) {
      context.pop();
    }
    GoRouter.of(context).replace(path, extra: args);
  }

  /// Safe pop — cek dialog dulu
  static void safePop({required BuildContext context}) {
    final rootNav = Navigator.of(context, rootNavigator: true);
    if (rootNav.canPop()) {
      rootNav.pop();
      return;
    }
    final router = GoRouter.of(context);
    if (router.canPop()) router.pop();
  }

  /// Get extra args dari GoRouterState — type safe
  static T getArgs<T>(GoRouterState state) {
    final extra = state.extra;
    if (extra is! T) {
      throw Exception('Invalid or missing argument for type: $T');
    }
    return extra;
  }

  static void goEditExpense(BuildContext context, String id) {
    context.push('/transactions/$id/edit');
  }

  static void goTransactionDetail(BuildContext context, String id) {
    context.push('/transactions/$id');
  }
}
