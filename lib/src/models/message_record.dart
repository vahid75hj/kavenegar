import '../enums/message_delivery_status.dart';

/// Outbound SMS record (select / outbox APIs).
class MessageRecord {
  /// Creates a [MessageRecord].
  const MessageRecord({
    required this.messageId,
    required this.message,
    required this.deliveryStatus,
    required this.statusText,
    required this.sender,
    required this.receptor,
    required this.date,
    required this.cost,
  });

  /// Parses an outbox/select entry.
  factory MessageRecord.fromJson(Map<String, dynamic> json) {
    return MessageRecord(
      messageId: _asInt(json['messageid']),
      message: json['message']?.toString() ?? '',
      deliveryStatus: MessageDeliveryStatus.fromCode(_asInt(json['status'])),
      statusText: json['statustext']?.toString() ?? '',
      sender: json['sender']?.toString() ?? '',
      receptor: json['receptor']?.toString() ?? '',
      date: _asInt(json['date']),
      cost: _asInt(json['cost']),
    );
  }

  /// Message id.
  final int messageId;

  /// Message text.
  final String message;

  /// Delivery status.
  final MessageDeliveryStatus deliveryStatus;

  /// Status text from API.
  final String statusText;

  /// Sender line.
  final String sender;

  /// Recipient.
  final String receptor;

  /// Unix send time.
  final int date;

  /// Cost in IRR.
  final int cost;
}

int _asInt(Object? value) {
  if (value is int) {
    return value;
  }
  if (value is String) {
    return int.tryParse(value) ?? 0;
  }
  return 0;
}
