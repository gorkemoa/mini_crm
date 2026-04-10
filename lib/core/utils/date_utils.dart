import 'package:intl/intl.dart';

abstract class AppDateUtils {
  static final DateFormat _displayDate = DateFormat('dd MMM yyyy', 'tr_TR');
  static final DateFormat _displayDateShort = DateFormat('dd MMM', 'tr_TR');
  static final DateFormat _dbFormat = DateFormat('yyyy-MM-dd');
  static final DateFormat _dbFormatFull = DateFormat('yyyy-MM-dd HH:mm:ss');

  static String toDisplay(DateTime date) => _displayDate.format(date);

  static String toDisplayShort(DateTime date) =>
      _displayDateShort.format(date);

  static String toDB(DateTime date) => _dbFormat.format(date);

  static String toDBFull(DateTime date) => _dbFormatFull.format(date);

  static DateTime? fromDB(String? value) {
    if (value == null || value.isEmpty) return null;
    try {
      return DateTime.parse(value);
    } catch (_) {
      return null;
    }
  }

  static bool isOverdue(DateTime? date) {
    if (date == null) return false;
    final now = DateTime.now();
    return date.isBefore(DateTime(now.year, now.month, now.day));
  }

  static bool isToday(DateTime? date) {
    if (date == null) return false;
    final now = DateTime.now();
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }

  static bool isThisWeek(DateTime? date) {
    if (date == null) return false;
    final now = DateTime.now();
    final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    final endOfWeek = startOfWeek.add(const Duration(days: 6));
    return date.isAfter(startOfWeek.subtract(const Duration(days: 1))) &&
        date.isBefore(endOfWeek.add(const Duration(days: 1)));
  }

  static bool isThisMonth(DateTime? date) {
    if (date == null) return false;
    final now = DateTime.now();
    return date.year == now.year && date.month == now.month;
  }

  static String relativeLabel(DateTime date) {
    if (isToday(date)) return 'Bugün';
    if (isOverdue(date)) {
      final diff = DateTime.now().difference(date).inDays;
      return '$diff gün gecikti';
    }
    final diff = date.difference(DateTime.now()).inDays;
    if (diff == 1) return 'Yarın';
    if (diff <= 7) return '$diff gün sonra';
    return toDisplay(date);
  }
}
