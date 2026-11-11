/// Inbound SMS from receive/inbox APIs.
class ReceivedMessage {
  /// Creates a [ReceivedMessage].
  const ReceivedMessage({
    required this.messageId,
    required this.message,
    required this.sender,
    required this.receptor,
    required this.date,
  });

  /// Parses a received message entry.
  factory ReceivedMessage.fromJson(Map<String, dynamic> json) {
    return ReceivedMessage(
      messageId: _asInt(json['messageid']),
      message: json['message']?.toString() ?? '',
      sender: json['sender']?.toString() ?? '',
      receptor: json['receptor']?.toString() ?? '',
      date: _asInt(json['date']),
    );
  }

  /// Inbound message id.
  final int messageId;

  /// Message body.
  final String message;

  /// Mobile sender.
  final String sender;

  /// Your line number.
  final String receptor;

  /// Receive time (Unix seconds).
  final int date;
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
