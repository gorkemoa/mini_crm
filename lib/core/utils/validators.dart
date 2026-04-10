abstract class Validators {
  static String? required(String? value, {String fieldName = 'Bu alan'}) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName zorunludur.';
    }
    return null;
  }

  static String? amount(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Tutar zorunludur.';
    }
    final parsed = double.tryParse(value.replaceAll(',', '.'));
    if (parsed == null) return 'Geçerli bir tutar girin.';
    if (parsed <= 0) return 'Tutar 0\'dan büyük olmalıdır.';
    return null;
  }

  static String? email(String? value) {
    if (value == null || value.trim().isEmpty) return null;
    final regex = RegExp(r'^[a-zA-Z0-9._%+\-]+@[a-zA-Z0-9.\-]+\.[a-zA-Z]{2,}$');
    if (!regex.hasMatch(value.trim())) return 'Geçerli bir e-posta adresi girin.';
    return null;
  }

  static String? phone(String? value) {
    if (value == null || value.trim().isEmpty) return null;
    final digits = value.replaceAll(RegExp(r'\D'), '');
    if (digits.length < 10) return 'Geçerli bir telefon numarası girin.';
    return null;
  }

  static double? parseAmount(String value) {
    return double.tryParse(value.trim().replaceAll(',', '.'));
  }
}
