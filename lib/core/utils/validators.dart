abstract class Validators {
  static String? required(String? value, {String fieldName = ''}) {
    if (value == null || value.trim().isEmpty) {
      return 'validationRequired';
    }
    return null;
  }

  static String? amount(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'validationAmountRequired';
    }
    final parsed = double.tryParse(value.replaceAll(',', '.'));
    if (parsed == null) return 'validationAmountInvalid';
    if (parsed <= 0) return 'validationAmountPositive';
    return null;
  }

  static String? email(String? value) {
    if (value == null || value.trim().isEmpty) return null;
    final regex = RegExp(r'^[a-zA-Z0-9._%+\-]+@[a-zA-Z0-9.\-]+\.[a-zA-Z]{2,}$');
    if (!regex.hasMatch(value.trim())) return 'validationEmail';
    return null;
  }

  static String? phone(String? value) {
    if (value == null || value.trim().isEmpty) return null;
    final digits = value.replaceAll(RegExp(r'\D'), '');
    if (digits.length < 10) return 'validationPhone';
    return null;
  }

  static double? parseAmount(String value) {
    return double.tryParse(value.trim().replaceAll(',', '.'));
  }
}
