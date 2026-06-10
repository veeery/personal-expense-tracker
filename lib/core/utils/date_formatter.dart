// lib/core/utils/date_formatter.dart

import 'package:intl/intl.dart';

class DateFormatter {
  DateFormatter._();

  static final _dateFormat = DateFormat('dd MMM yyyy', 'id_ID');
  static final _monthYear = DateFormat('MMMM yyyy', 'id_ID');
  static final _dayMonthYear = DateFormat('EEEE, dd MMMM yyyy', 'id_ID');

  // 10 Jun 2025
  static String format(DateTime date) => _dateFormat.format(date);

  // Juni 2025
  static String formatMonthYear(DateTime date) => _monthYear.format(date);

  // Selasa, 10 Juni 2025
  static String formatFull(DateTime date) => _dayMonthYear.format(date);

  // Grouping label di list — "Hari ini", "Kemarin", atau tanggal
  static String formatRelative(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final target = DateTime(date.year, date.month, date.day);
    final diff = today.difference(target).inDays;

    return switch (diff) {
      0 => 'Hari ini',
      1 => 'Kemarin',
      _ => format(date),
    };
  }
}
