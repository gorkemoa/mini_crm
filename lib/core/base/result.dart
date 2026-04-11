sealed class Result<T> {
  const Result();

  factory Result.success(T data) = SuccessResult<T>;
  factory Result.failure(String error) = FailureResult<T>;

  bool get isSuccess => this is SuccessResult<T>;
  bool get isFailure => this is FailureResult<T>;

  T? get data => isSuccess ? (this as SuccessResult<T>).data : null;
  String? get error => isFailure ? (this as FailureResult<T>).error : null;

  R fold<R>({
    required R Function(T data) onSuccess,
    required R Function(String error) onFailure,
  }) {
    return switch (this) {
      SuccessResult<T>(:final data) => onSuccess(data),
      FailureResult<T>(:final error) => onFailure(error),
    };
  }
}

final class SuccessResult<T> extends Result<T> {
  @override
  final T data;
  const SuccessResult(this.data);
}

final class FailureResult<T> extends Result<T> {
  @override
  final String error;
  const FailureResult(this.error);
}
