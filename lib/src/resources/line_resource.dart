import '../internal/api_transport.dart';
import '../internal/entry_parser.dart';
import '../internal/request_encoding.dart';
import '../models/blocked_line.dart';

/// Blocked-number list management for sender lines.
class LineResource {
  /// Creates [LineResource] for `line/blocked` endpoints.
  LineResource(this._transport);

  final ApiTransport _transport;

  /// Lists numbers that blocked the given line.
  Future<List<BlockedLineEntry>> blockedList({
    required String lineNumber,
    int? blockReason,
    DateTime? startDate,
    int? pageNumber,
  }) async {
    final envelope = await _transport.send(
      scope: 'line/blocked',
      method: 'list',
      httpMethod: HttpMethod.get,
      fields: omitNull({
        'linenumber': lineNumber,
        'blockreason': blockReason?.toString(),
        'startdate': unixSeconds(startDate)?.toString(),
        'pagenumber': pageNumber?.toString(),
      }),
    );
    return parseEntryList(envelope.entries)
        .map(BlockedLineEntry.fromJson)
        .toList(growable: false);
  }

  /// Adds receptors to the blocked list for a line.
  Future<void> blockedAdd({
    required String lineNumber,
    required List<String> receptors,
  }) async {
    await _transport.send(
      scope: 'line/blocked',
      method: 'add',
      fields: {
        'linenumber': lineNumber,
        'receptor': joinCommaSeparated(receptors),
      },
    );
  }

  /// Checks whether receptors have blocked a line.
  Future<List<BlockedLineExistsResult>> blockedExists({
    required String lineNumber,
    required List<String> receptors,
  }) async {
    final envelope = await _transport.send(
      scope: 'line/blocked',
      method: 'exists',
      httpMethod: HttpMethod.get,
      fields: {
        'linenumber': lineNumber,
        'receptor': joinCommaSeparated(receptors),
      },
    );
    return parseEntryList(envelope.entries)
        .map(BlockedLineExistsResult.fromJson)
        .toList(growable: false);
  }

  /// Removes receptors from the blocked list.
  Future<void> blockedRemove({
    required String lineNumber,
    required List<String> receptors,
  }) async {
    await _transport.send(
      scope: 'line/blocked',
      method: 'remove',
      httpMethod: HttpMethod.delete,
      fields: {
        'linenumber': lineNumber,
        'receptor': joinCommaSeparated(receptors),
      },
    );
  }
}
