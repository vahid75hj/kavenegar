import '../internal/api_transport.dart';
import '../internal/entry_parser.dart';
import '../internal/request_encoding.dart';
import '../models/send_result.dart';

/// Voice call (TTS) operations.
class CallResource {
  /// Creates [CallResource].
  CallResource(this._transport);

  final ApiTransport _transport;

  /// Places a text-to-speech call to one or more receptors.
  Future<List<SendResult>> makeTts({
    required List<String> receptors,
    required String message,
    DateTime? date,
    List<String>? localIds,
    String? tag,
  }) async {
    final envelope = await _transport.send(
      scope: 'call',
      method: 'maketts',
      fields: omitNull({
        'receptor': joinCommaSeparated(receptors),
        'message': message,
        'date': unixSeconds(date)?.toString(),
        'localid': localIds == null ? null : joinCommaSeparated(localIds),
        'tag': tag,
      }),
    );
    final list = parseEntryList(envelope.entries);
    if (list.isNotEmpty) {
      return list.map(SendResult.fromJson).toList(growable: false);
    }
    if (envelope.entries is Map<String, dynamic>) {
      return [
        SendResult.fromJson(envelope.entries! as Map<String, dynamic>),
      ];
    }
    return const [];
  }
}
