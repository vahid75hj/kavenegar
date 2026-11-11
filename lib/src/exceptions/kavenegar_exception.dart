import '../internal/masked_api_key.dart';

/// Base type for all Kavenegar client errors.
sealed class KavenegarException implements Exception {
  /// Creates a [KavenegarException].
  const KavenegarException(this.message);

  /// Human-readable error description (API key values are masked).
  final String message;

  @override
  String toString() => '$runtimeType: $message';
}

/// Thrown when the API responds with `return.status != 200`.
final class KavenegarApiException extends KavenegarException {
  /// Creates an API-level error from the envelope `return` block.
  KavenegarApiException({
    required this.status,
    required String message,
    required String apiKey,
  }) : super(maskApiKey(message, apiKey));

  /// Kavenegar API return code (see [KavenegarApiErrorCodes]).
  final int status;

  @override
  String toString() => 'KavenegarApiException($status): $message';
}

/// Thrown for network failures, timeouts, or malformed JSON responses.
final class KavenegarHttpException extends KavenegarException {
  /// Creates an HTTP/transport level error.
  KavenegarHttpException(
    String message, {
    this.httpStatus,
    required String apiKey,
  }) : super(maskApiKey(message, apiKey));

  /// HTTP status code when available.
  final int? httpStatus;

  @override
  String toString() {
    final status = httpStatus;
    if (status == null) {
      return 'KavenegarHttpException: $message';
    }
    return 'KavenegarHttpException($status): $message';
  }
}
