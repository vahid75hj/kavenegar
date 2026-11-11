import '../enums/message_delivery_status.dart';
import '../enums/message_display_type.dart';
import '../internal/api_transport.dart';
import '../internal/entry_parser.dart';
import '../internal/request_encoding.dart';
import '../models/count_inbox_result.dart';
import '../models/count_outbox_result.dart';
import '../models/inbox_metadata.dart';
import '../models/message_record.dart';
import '../models/received_message.dart';
import '../models/send_result.dart';
import '../models/status_result.dart';

/// SMS send, status, and inbox operations.
class SmsResource {
  /// Creates [SmsResource].
  SmsResource(this._transport);

  final ApiTransport _transport;

  /// Sends one message to one or more receptors.
  Future<List<SendResult>> send({
    required List<String> receptors,
    required String message,
    String? sender,
    DateTime? date,
    MessageDisplayType? type,
    List<int>? localIds,
    bool hide = false,
    String? tag,
    String? policy,
    String? mediaId,
  }) async {
    final envelope = await _transport.send(
      scope: 'sms',
      method: 'send',
      fields: omitNull({
        'receptor': joinCommaSeparated(receptors),
        'message': message,
        'sender': sender,
        'date': unixSeconds(date)?.toString(),
        'type': displayTypeParam(type),
        'localid': localIds == null
            ? null
            : joinCommaSeparated(localIds.map((e) => e.toString())),
        'hide': hideFlag(hide),
        'tag': tag,
        'policy': policy,
        'mediaid': mediaId,
      }),
    );
    return parseEntryList(envelope.entries)
        .map(SendResult.fromJson)
        .toList(growable: false);
  }

  /// Sends different messages to different receptors (POST only).
  Future<List<SendResult>> sendArray({
    required List<String> receptors,
    required List<String> senders,
    required List<String> messages,
    DateTime? date,
    List<int>? types,
    List<int>? localMessageIds,
    bool hide = false,
    String? tag,
    String? policy,
    String? mediaId,
  }) async {
    final envelope = await _transport.send(
      scope: 'sms',
      method: 'sendarray',
      fields: omitNull({
        'receptor': jsonStringList(receptors),
        'sender': jsonStringList(senders),
        'message': jsonStringList(messages),
        'date': unixSeconds(date)?.toString(),
        'type': types == null ? null : jsonIntList(types),
        'localmessageids':
            localMessageIds == null ? null : jsonLongList(localMessageIds),
        'hide': hideFlag(hide),
        'tag': tag,
        'policy': policy,
        'mediaid': mediaId,
      }),
    );
    return parseEntryList(envelope.entries)
        .map(SendResult.fromJson)
        .toList(growable: false);
  }

  /// Checks delivery status for up to 500 message ids.
  Future<List<StatusResult>> status(List<int> messageIds) async {
    final envelope = await _transport.send(
      scope: 'sms',
      method: 'status',
      fields: {'messageid': joinCommaSeparated(messageIds.map((e) => '$e'))},
    );
    return parseEntryList(envelope.entries)
        .map(StatusResult.fromJson)
        .toList(growable: false);
  }

  /// Checks status by local ids provided during send.
  Future<List<StatusResult>> statusByLocalMessageId(List<int> localIds) async {
    final envelope = await _transport.send(
      scope: 'sms',
      method: 'statuslocalmessageid',
      fields: {'localid': joinCommaSeparated(localIds.map((e) => '$e'))},
    );
    return parseEntryList(envelope.entries)
        .map(StatusResult.fromJson)
        .toList(growable: false);
  }

  /// Lists statuses for messages sent to a receptor in a time window.
  Future<List<StatusResult>> statusByReceptor({
    required String receptor,
    required DateTime startDate,
    DateTime? endDate,
  }) async {
    final envelope = await _transport.send(
      scope: 'sms',
      method: 'statusbyreceptor',
      fields: omitNull({
        'receptor': receptor,
        'startdate': unixSeconds(startDate).toString(),
        'enddate': unixSeconds(endDate)?.toString(),
      }),
    );
    return parseEntryList(envelope.entries)
        .map(StatusResult.fromJson)
        .toList(growable: false);
  }

  /// Fetches full records for message ids (requires IP whitelist).
  Future<List<MessageRecord>> select(List<int> messageIds) async {
    final envelope = await _transport.send(
      scope: 'sms',
      method: 'select',
      fields: {'messageid': joinCommaSeparated(messageIds.map((e) => '$e'))},
    );
    return parseEntryList(envelope.entries)
        .map(MessageRecord.fromJson)
        .toList(growable: false);
  }

  /// Lists sent messages in a date range.
  Future<List<MessageRecord>> selectOutbox({
    required DateTime startDate,
    DateTime? endDate,
    String? sender,
  }) async {
    final envelope = await _transport.send(
      scope: 'sms',
      method: 'selectoutbox',
      fields: omitNull({
        'startdate': unixSeconds(startDate).toString(),
        'enddate': unixSeconds(endDate)?.toString(),
        'sender': sender,
      }),
    );
    return parseEntryList(envelope.entries)
        .map(MessageRecord.fromJson)
        .toList(growable: false);
  }

  /// Returns the latest outbox rows.
  Future<List<MessageRecord>> latestOutbox({
    int? pageSize,
    String? sender,
  }) async {
    final envelope = await _transport.send(
      scope: 'sms',
      method: 'latestoutbox',
      fields: omitNull({
        'pagesize': pageSize?.toString(),
        'sender': sender,
      }),
    );
    return parseEntryList(envelope.entries)
        .map(MessageRecord.fromJson)
        .toList(growable: false);
  }

  /// Returns outbox statistics for a date range.
  Future<List<CountOutboxResult>> countOutbox({
    required DateTime startDate,
    DateTime? endDate,
    MessageDeliveryStatus? status,
  }) async {
    final envelope = await _transport.send(
      scope: 'sms',
      method: 'countoutbox',
      fields: omitNull({
        'startdate': unixSeconds(startDate).toString(),
        'enddate': unixSeconds(endDate)?.toString(),
        'status': status == null || status == MessageDeliveryStatus.unknown
            ? null
            : status.code.toString(),
      }),
    );
    return parseEntryList(envelope.entries)
        .map(CountOutboxResult.fromJson)
        .toList(growable: false);
  }

  /// Cancels scheduled messages by id.
  Future<List<StatusResult>> cancel(List<int> messageIds) async {
    final envelope = await _transport.send(
      scope: 'sms',
      method: 'cancel',
      fields: {'messageid': joinCommaSeparated(messageIds.map((e) => '$e'))},
    );
    return parseEntryList(envelope.entries)
        .map(StatusResult.fromJson)
        .toList(growable: false);
  }

  /// Pulls unread/read inbound messages for a line (up to 100 per call).
  Future<List<ReceivedMessage>> receive({
    required String lineNumber,
    required int isRead,
  }) async {
    final envelope = await _transport.send(
      scope: 'sms',
      method: 'receive',
      fields: {
        'linenumber': lineNumber,
        'isread': isRead.toString(),
      },
    );
    return parseEntryList(envelope.entries)
        .map(ReceivedMessage.fromJson)
        .toList(growable: false);
  }

  /// Pulls inbound messages with paging metadata.
  Future<({List<ReceivedMessage> messages, InboxMetadata? metadata})>
      inboxPaged({
    required String lineNumber,
    required int isRead,
    DateTime? startDate,
    DateTime? endDate,
    int? pageNumber,
  }) async {
    final envelope = await _transport.send(
      scope: 'sms',
      method: 'inboxpaged',
      fields: omitNull({
        'linenumber': lineNumber,
        'isread': isRead.toString(),
        'startdate': unixSeconds(startDate)?.toString(),
        'enddate': unixSeconds(endDate)?.toString(),
        'pagenumber': pageNumber?.toString(),
      }),
    );
    final messages = parseEntryList(envelope.entries)
        .map(ReceivedMessage.fromJson)
        .toList(growable: false);
    final metadata = envelope.metadata == null
        ? null
        : InboxMetadata.fromJson(envelope.metadata!);
    return (messages: messages, metadata: metadata);
  }

  /// Returns inbox counts for a date range.
  Future<List<CountInboxResult>> countInbox({
    required DateTime startDate,
    DateTime? endDate,
    String? lineNumber,
    int? isRead,
  }) async {
    final envelope = await _transport.send(
      scope: 'sms',
      method: 'countinbox',
      fields: omitNull({
        'startdate': unixSeconds(startDate).toString(),
        'enddate': unixSeconds(endDate)?.toString(),
        'linenumber': lineNumber,
        'isread': isRead?.toString(),
      }),
    );
    return parseEntryList(envelope.entries)
        .map(CountInboxResult.fromJson)
        .toList(growable: false);
  }
}
