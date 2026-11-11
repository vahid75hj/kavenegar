import 'dart:convert';

import 'package:http/http.dart' as http;

import '../exceptions/kavenegar_exception.dart';
import 'masked_api_key.dart';

/// HTTP verbs supported by the Kavenegar API.
enum HttpMethod {
  /// GET request.
  get,

  /// POST request with form body.
  post,

  /// DELETE request (query parameters).
  delete,
}

/// Raw successful API payload.
class ApiEnvelope {
  /// Creates an [ApiEnvelope].
  const ApiEnvelope({
    required this.entries,
    this.metadata,
  });

  /// Parsed `entries` field (list or map).
  final Object? entries;

  /// Optional top-level `metadata` field (e.g. inbox paging).
  final Map<String, dynamic>? metadata;
}

/// Low-level HTTP transport for Kavenegar REST calls.
class ApiTransport {
  /// Creates an [ApiTransport].
  ApiTransport({
    required this.apiKey,
    required http.Client httpClient,
    required this.baseUrl,
    required this.timeout,
  }) : _httpClient = httpClient;

  /// API key embedded in the URL path (never logged in plain text).
  final String apiKey;

  /// Injectable HTTP client.
  final http.Client _httpClient;

  /// API origin without trailing slash.
  final String baseUrl;

  /// Per-request timeout.
  final Duration timeout;

  /// Sends a request and parses the standard response envelope.
  Future<ApiEnvelope> send({
    required String scope,
    required String method,
    Map<String, String>? fields,
    HttpMethod httpMethod = HttpMethod.post,
    List<http.MultipartFile>? files,
  }) async {
    final uri = _buildUri(scope, method, fields, httpMethod);
    try {
      final http.StreamedResponse streamed;
      if (files != null && files.isNotEmpty) {
        final request =
            http.MultipartRequest(httpMethod.name.toUpperCase(), uri);
        if (fields != null) {
          request.fields.addAll(fields);
        }
        request.files.addAll(files);
        streamed = await _httpClient.send(request).timeout(timeout);
      } else {
        switch (httpMethod) {
          case HttpMethod.get:
            streamed = await _httpClient.send(http.Request('GET', uri)).timeout(
                  timeout,
                );
          case HttpMethod.delete:
            streamed =
                await _httpClient.send(http.Request('DELETE', uri)).timeout(
                      timeout,
                    );
          case HttpMethod.post:
            final request = http.Request('POST', uri);
            request.headers['Content-Type'] =
                'application/x-www-form-urlencoded; charset=utf-8';
            request.headers['Accept'] = 'application/json';
            request.body = _encodeFields(fields);
            streamed = await _httpClient.send(request).timeout(timeout);
        }
      }

      final response =
          await http.Response.fromStream(streamed).timeout(timeout);
      return _parseResponse(response);
    } on KavenegarException {
      rethrow;
    } on Exception catch (error) {
      throw KavenegarHttpException(
        'Request failed: $error',
        apiKey: apiKey,
      );
    }
  }

  Uri _buildUri(
    String scope,
    String method,
    Map<String, String>? fields,
    HttpMethod httpMethod,
  ) {
    final base = Uri.parse(baseUrl);
    final path = '/v1/$apiKey/$scope/$method.json';
    if (httpMethod == HttpMethod.get || httpMethod == HttpMethod.delete) {
      return base.replace(
        path: path,
        queryParameters:
            fields == null ? null : Map<String, String>.from(fields),
      );
    }
    return base.replace(path: path);
  }

  String _encodeFields(Map<String, String>? fields) {
    if (fields == null || fields.isEmpty) {
      return '';
    }
    return fields.entries
        .map(
          (e) =>
              '${Uri.encodeQueryComponent(e.key)}=${Uri.encodeQueryComponent(e.value)}',
        )
        .join('&');
  }

  ApiEnvelope _parseResponse(http.Response response) {
    Map<String, dynamic> json;
    try {
      final decoded = jsonDecode(response.body);
      if (decoded is! Map<String, dynamic>) {
        throw const FormatException('Expected a JSON object');
      }
      json = decoded;
    } catch (error) {
      throw KavenegarHttpException(
        'Invalid JSON response: $error',
        httpStatus: response.statusCode,
        apiKey: apiKey,
      );
    }

    final returnBlock = json['return'];
    if (returnBlock is! Map<String, dynamic>) {
      throw KavenegarHttpException(
        'Missing return block in response',
        httpStatus: response.statusCode,
        apiKey: apiKey,
      );
    }

    final status = returnBlock['status'];
    final message = returnBlock['message']?.toString() ?? '';
    if (status != 200) {
      throw KavenegarApiException(
        status: status is int ? status : int.tryParse('$status') ?? 0,
        message: message,
        apiKey: apiKey,
      );
    }

    Map<String, dynamic>? metadata;
    final rawMetadata = json['metadata'];
    if (rawMetadata is Map<String, dynamic>) {
      metadata = rawMetadata;
    }

    return ApiEnvelope(entries: json['entries'], metadata: metadata);
  }

  /// URL path used for a call (with API key masked).
  String maskedEndpoint(String scope, String method) {
    return maskApiKey(
      '$baseUrl/v1/$apiKey/$scope/$method.json',
      apiKey,
    );
  }
}
