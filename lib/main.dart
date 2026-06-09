// lib/main.dart

import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'app.dart';
import 'core/di/injection_container.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Init locale untuk intl — format Rupiah dan tanggal Indonesia
  await initializeDateFormatting('id_ID');

  // Setup semua dependencies
  await setupDependencies();

  runApp(const App());
}