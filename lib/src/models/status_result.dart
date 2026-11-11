import '../enums/message_delivery_status.dart';

/// Message delivery status from status APIs.
class StatusResult {
  /// Creates a [StatusResult].
  const StatusResult({
    required this.messageId,
    required this.deliveryStatus,
    required this.statusText,
    this.localId,
    this.receptor,
  });

  /// Parses a status entry.
  factory StatusResult.fromJson(Map<String, dynamic> json) {
    return StatusResult(
      messageId: _asInt(json['messageid']),
      deliveryStatus: MessageDeliveryStatus.fromCode(_asInt(json['status'])),
      statusText: json['statustext']?.toString() ?? '',
      localId: json['localid']?.toString(),
      receptor: json['receptor']?.toString(),
    );
  }

  /// Message id.
  final int messageId;

  /// Delivery status.
  final MessageDeliveryStatus deliveryStatus;

  /// Status description from the API.
  final String statusText;

  /// Local id when returned by `statusByLocalMessageId`.
  final String? localId;

  /// Receptor when returned by `statusByReceptor`.
  final String? receptor;
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
