import 'package:intl/intl.dart';

abstract class AppDateUtils {
  static String formatDate(DateTime? date) {
    if (date == null) return '—';
    return DateFormat('MMM d, yyyy').format(date);
  }

  static String formatDateShort(DateTime? date) {
    if (date == null) return '—';
    return DateFormat('MMM d').format(date);
  }

  static String formatDateFull(DateTime? date) {
    if (date == null) return '—';
    return DateFormat('MMMM d, yyyy').format(date);
  }

  static String formatDateTime(DateTime? date) {
    if (date == null) return '—';
    return DateFormat('MMM d, yyyy – HH:mm').format(date);
  }

  static bool isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year && date.month == now.month && date.day == now.day;
  }

  static bool isTomorrow(DateTime date) {
    final tomorrow = DateTime.now().add(const Duration(days: 1));
    return date.year == tomorrow.year && date.month == tomorrow.month && date.day == tomorrow.day;
  }

  static bool isOverdue(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final d = DateTime(date.year, date.month, date.day);
    return d.isBefore(today);
  }

  static int daysUntil(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final d = DateTime(date.year, date.month, date.day);
    return d.difference(today).inDays;
  }

  static int daysOverdue(DateTime date) {
    return -daysUntil(date);
  }

  static bool isThisWeek(DateTime date) {
    final now = DateTime.now();
    final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    final endOfWeek = startOfWeek.add(const Duration(days: 6));
    return date.isAfter(startOfWeek.subtract(const Duration(days: 1))) &&
        date.isBefore(endOfWeek.add(const Duration(days: 1)));
  }

  static bool isThisMonth(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year && date.month == now.month;
  }

  static DateTime startOfMonth() {
    final now = DateTime.now();
    return DateTime(now.year, now.month, 1);
  }

  static DateTime endOfMonth() {
    final now = DateTime.now();
    return DateTime(now.year, now.month + 1, 0, 23, 59, 59);
  }

  static String? toIso(DateTime? date) => date?.toIso8601String();
  static DateTime? fromIso(String? s) => s == null ? null : DateTime.tryParse(s);
}
