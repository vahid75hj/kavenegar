import '../enums/message_delivery_status.dart';

/// Result of sending an SMS or OTP (send, lookup, maketts).
class SendResult {
  /// Creates a [SendResult].
  const SendResult({
    required this.messageId,
    required this.message,
    required this.deliveryStatus,
    required this.statusText,
    required this.sender,
    required this.receptor,
    required this.date,
    required this.cost,
  });

  /// Parses one entry from the API `entries` array or object.
  factory SendResult.fromJson(Map<String, dynamic> json) {
    return SendResult(
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

  /// Unique message id (use with status APIs).
  final int messageId;

  /// Message body that was sent.
  final String message;

  /// Parsed delivery status.
  final MessageDeliveryStatus deliveryStatus;

  /// Human-readable status from the API.
  final String statusText;

  /// Sender line number.
  final String sender;

  /// Recipient number.
  final String receptor;

  /// Send time as Unix seconds.
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
  if (value is double) {
    return value.toInt();
  }
  return 0;
}
