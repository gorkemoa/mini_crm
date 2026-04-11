abstract class Validators {
  static String? required(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'This field is required';
    }
    return null;
  }

  static String? email(String? value) {
    if (value == null || value.trim().isEmpty) return null;
    final regex = RegExp(r'^[\w.+\-]+@[a-zA-Z0-9\-]+\.[a-zA-Z]{2,}$');
    if (!regex.hasMatch(value.trim())) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  static String? phone(String? value) {
    if (value == null || value.trim().isEmpty) return null;
    final cleaned = value.replaceAll(RegExp(r'[\s\-\+\(\)]'), '');
    if (cleaned.length < 7 || cleaned.length > 15 || !RegExp(r'^\d+$').hasMatch(cleaned)) {
      return 'Please enter a valid phone number';
    }
    return null;
  }

  static String? amount(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'This field is required';
    }
    final parsed = double.tryParse(value.trim().replaceAll(',', '.'));
    if (parsed == null) return 'Please enter a valid amount';
    if (parsed <= 0) return 'Amount must be greater than zero';
    return null;
  }

  static String? positiveNumber(String? value) {
    if (value == null || value.trim().isEmpty) return null;
    final parsed = double.tryParse(value.trim().replaceAll(',', '.'));
    if (parsed == null) return 'Please enter a valid number';
    if (parsed < 0) return 'Value must be zero or greater';
    return null;
  }

  static String? Function(String?) combine(List<String? Function(String?)> validators) {
    return (value) {
      for (final v in validators) {
        final result = v(value);
        if (result != null) return result;
      }
      return null;
    };
  }
}
