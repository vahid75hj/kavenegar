import '../internal/api_transport.dart';
import '../internal/entry_parser.dart';
import '../models/server_date.dart';

/// Utility endpoints.
class UtilsResource {
  /// Creates [UtilsResource].
  UtilsResource(this._transport);

  final ApiTransport _transport;

  /// Returns the Kavenegar server date/time.
  Future<ServerDate> getDate() async {
    final envelope = await _transport.send(
      scope: 'utils',
      method: 'getdate',
      httpMethod: HttpMethod.get,
    );
    return ServerDate.fromJson(parseEntryObject(envelope.entries));
  }
}
