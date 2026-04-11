import 'package:intl/intl.dart';

abstract class CurrencyUtils {
  static const List<String> supportedCurrencies = [
    'USD', 'EUR', 'TRY', 'GBP', 'JPY', 'CNY', 'INR',
    'BRL', 'AUD', 'CAD', 'KRW', 'MXN', 'RUB', 'IDR',
  ];

  static String format(double amount, String currency) {
    try {
      final formatter = NumberFormat.currency(
        symbol: _symbol(currency),
        decimalDigits: currency == 'JPY' || currency == 'KRW' ? 0 : 2,
      );
      return formatter.format(amount);
    } catch (_) {
      return '$currency ${amount.toStringAsFixed(2)}';
    }
  }

  static String formatCompact(double amount, String currency) {
    if (amount >= 1000000) {
      return '${_symbol(currency)}${(amount / 1000000).toStringAsFixed(1)}M';
    } else if (amount >= 1000) {
      return '${_symbol(currency)}${(amount / 1000).toStringAsFixed(1)}K';
    }
    return format(amount, currency);
  }

  static String _symbol(String currency) {
    switch (currency.toUpperCase()) {
      case 'USD': return '\$';
      case 'EUR': return '€';
      case 'TRY': return '₺';
      case 'GBP': return '£';
      case 'JPY': return '¥';
      case 'CNY': return '¥';
      case 'INR': return '₹';
      case 'BRL': return 'R\$';
      case 'KRW': return '₩';
      case 'RUB': return '₽';
      default: return currency;
    }
  }
}
