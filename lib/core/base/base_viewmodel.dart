import 'package:flutter/foundation.dart';

abstract class BaseViewModel extends ChangeNotifier {
  bool _isLoading = false;
  bool _isDisposed = false;
  String? _errorMessage;

  bool get isLoading => _isLoading;
  bool get hasError => _errorMessage != null;
  String? get errorMessage => _errorMessage;

  void setLoading(bool value) {
    if (_isDisposed) return;
    _isLoading = value;
    notifyListeners();
  }

  void setError(String? message) {
    if (_isDisposed) return;
    _errorMessage = message;
    notifyListeners();
  }

  void clearError() {
    if (_errorMessage == null) return;
    _errorMessage = null;
    if (!_isDisposed) notifyListeners();
  }

  void safeNotify() {
    if (!_isDisposed) notifyListeners();
  }

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }
}
