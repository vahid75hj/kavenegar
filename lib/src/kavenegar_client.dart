import 'package:http/http.dart' as http;

import 'internal/api_transport.dart';
import 'internal/masked_api_key.dart';
import 'resources/account_resource.dart';
import 'resources/call_resource.dart';
import 'resources/line_resource.dart';
import 'resources/media_resource.dart';
import 'resources/sms_resource.dart';
import 'resources/utils_resource.dart';
import 'resources/verify_resource.dart';

/// Client for the [Kavenegar REST API](https://kavenegar.com/rest.html).
///
/// Create one instance per API key and reuse it for all calls (for example in a
/// Serverpod `server.dart` bootstrap). Call [close] when the client is no longer
/// needed.
final class KavenegarClient {
  /// Creates a Kavenegar API client.
  KavenegarClient({
    required String apiKey,
    http.Client? httpClient,
    this.baseUrl = 'https://api.kavenegar.com',
    this.timeout = const Duration(seconds: 30),
  })  : _ownsClient = httpClient == null,
        _httpClient = httpClient ?? http.Client(),
        _apiKey = apiKey.trim() {
    final transport = ApiTransport(
      apiKey: _apiKey,
      httpClient: _httpClient,
      baseUrl: baseUrl,
      timeout: timeout,
    );
    sms = SmsResource(transport);
    verify = VerifyResource(transport);
    call = CallResource(transport);
    account = AccountResource(transport);
    line = LineResource(transport);
    media = MediaResource(transport);
    utils = UtilsResource(transport);
  }

  /// API key (never included in [toString]).
  final String _apiKey;

  /// Optional custom API origin (used in tests).
  final String baseUrl;

  /// Per-request timeout.
  final Duration timeout;

  final http.Client _httpClient;
  final bool _ownsClient;

  /// SMS operations.
  late final SmsResource sms;

  /// Verification / template operations.
  late final VerifyResource verify;

  /// Voice call operations.
  late final CallResource call;

  /// Account info and config.
  late final AccountResource account;

  /// Line block list operations.
  late final LineResource line;

  /// Media upload and management.
  late final MediaResource media;

  /// Utility endpoints.
  late final UtilsResource utils;

  /// Closes the underlying [http.Client] when this instance created it.
  void close() {
    if (_ownsClient) {
      _httpClient.close();
    }
  }

  @override
  String toString() =>
      'KavenegarClient(baseUrl: $baseUrl, apiKey: ${maskedApiKeyLabel()})';
}
