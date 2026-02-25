/// A Result type for type-safe error handling.
///
/// Use this instead of throwing exceptions to handle expected errors.
/// This makes error handling explicit and forces callers to handle both cases.
sealed class Result<T> {
  const Result();

  /// Returns true if this is a successful result.
  bool get isSuccess => this is Success<T>;

  /// Returns true if this is a failure result.
  bool get isFailure => this is Failure<T>;

  /// Returns the data if successful, or null if failed.
  T? get dataOrNull => switch (this) {
        Success(:final data) => data,
        Failure() => null,
      };

  /// Returns the error if failed, or null if successful.
  AppException? get errorOrNull => switch (this) {
        Success() => null,
        Failure(:final error) => error,
      };

  /// Maps the success value to a new type.
  Result<R> map<R>(R Function(T data) transform) => switch (this) {
        Success(:final data) => Success(transform(data)),
        Failure(:final error) => Failure(error),
      };

  /// Executes the appropriate callback based on the result.
  R when<R>({
    required R Function(T data) success,
    required R Function(AppException error) failure,
  }) =>
      switch (this) {
        Success(:final data) => success(data),
        Failure(:final error) => failure(error),
      };
}

/// Represents a successful result containing data.
final class Success<T> extends Result<T> {
  final T data;

  const Success(this.data);

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is Success<T> && data == other.data;

  @override
  int get hashCode => data.hashCode;

  @override
  String toString() => 'Success($data)';
}

/// Represents a failed result containing an error.
final class Failure<T> extends Result<T> {
  final AppException error;

  const Failure(this.error);

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is Failure<T> && error == other.error;

  @override
  int get hashCode => error.hashCode;

  @override
  String toString() => 'Failure($error)';
}

/// Base exception class for application errors.
sealed class AppException implements Exception {
  final String message;
  final Object? cause;

  const AppException(this.message, [this.cause]);

  @override
  String toString() => '$runtimeType: $message';
}

/// Network-related errors (no connection, timeout, etc.)
final class NetworkException extends AppException {
  const NetworkException(super.message, [super.cause]);
}

/// Server errors (500, 502, etc.)
final class ServerException extends AppException {
  final int? statusCode;

  const ServerException(String message, {this.statusCode, Object? cause})
      : super(message, cause);
}

/// Resource not found errors (404)
final class NotFoundException extends AppException {
  const NotFoundException(super.message, [super.cause]);
}

/// Cache-related errors
final class CacheException extends AppException {
  const CacheException(super.message, [super.cause]);
}

/// Validation errors
final class ValidationException extends AppException {
  const ValidationException(super.message, [super.cause]);
}

/// Unknown/unexpected errors
final class UnknownException extends AppException {
  const UnknownException(super.message, [super.cause]);
}
