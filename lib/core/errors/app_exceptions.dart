class AppException implements Exception {
  final String message;
  final String? code;
  const AppException(this.message, {this.code});

  @override
  String toString() => 'AppException: $message${code != null ? ' (code: $code)' : ''}';
}

class DatabaseException extends AppException {
  const DatabaseException(super.message, {super.code});
}

class ValidationException extends AppException {
  final Map<String, String>? fieldErrors;
  const ValidationException(super.message, {this.fieldErrors, super.code});
}

class ImportException extends AppException {
  const ImportException(super.message, {super.code});
}

class ExportException extends AppException {
  const ExportException(super.message, {super.code});
}

class NotFoundException extends AppException {
  const NotFoundException(super.message, {super.code});
}
