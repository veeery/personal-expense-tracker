// lib/core/utils/currency_formatter.dart

import 'package:intl/intl.dart';

class CurrencyFormatter {
  CurrencyFormatter._();

  static final _formatter = NumberFormat.currency(
    locale: 'id_ID',
    symbol: 'Rp ',
    decimalDigits: 0,
  );

  static String format(double amount) => _formatter.format(amount);

  // Rp 50.000 → 50000.0
  static double parse(String value) {
    final cleaned =
        value.replaceAll('Rp ', '').replaceAll('.', '').replaceAll(',', '.');
    return double.tryParse(cleaned) ?? 0.0;
  }
}
