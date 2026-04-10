import 'package:intl/intl.dart';

abstract class CurrencyUtils {
  static String format(double amount, String currency) {
    final format = NumberFormat.currency(
      locale: _localeForCurrency(currency),
      symbol: _symbolForCurrency(currency),
      decimalDigits: amount == amount.truncateToDouble() ? 0 : 2,
    );
    return format.format(amount);
  }

  static String formatCompact(double amount, String currency) {
    final symbol = _symbolForCurrency(currency);
    if (amount >= 1000000) {
      return '$symbol${(amount / 1000000).toStringAsFixed(1)}M';
    }
    if (amount >= 1000) {
      return '$symbol${(amount / 1000).toStringAsFixed(1)}K';
    }
    return format(amount, currency);
  }

  static String _symbolForCurrency(String currency) {
    switch (currency) {
      case 'TRY':
        return '₺';
      case 'USD':
        return '\$';
      case 'EUR':
        return '€';
      case 'GBP':
        return '£';
      default:
        return currency;
    }
  }

  static String _localeForCurrency(String currency) {
    switch (currency) {
      case 'TRY':
        return 'tr_TR';
      case 'USD':
        return 'en_US';
      case 'EUR':
        return 'de_DE';
      case 'GBP':
        return 'en_GB';
      default:
        return 'tr_TR';
    }
  }
}
