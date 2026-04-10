class AppException implements Exception {
  final String message;
  final String? code;

  const AppException(this.message, {this.code});

  @override
  String toString() => 'AppException($code): $message';
}

class DatabaseException extends AppException {
  const DatabaseException(super.message, {super.code});
}

class ValidationException extends AppException {
  const ValidationException(super.message, {super.code});
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
