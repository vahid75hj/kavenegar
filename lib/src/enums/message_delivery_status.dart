/// SMS delivery status values from Kavenegar table 2.
enum MessageDeliveryStatus {
  /// In the send queue.
  queued(1),

  /// Scheduled for a future send time.
  scheduled(2),

  /// Sent to the operator.
  sentToOperator(4),

  /// Sent to the operator (same meaning as [sentToOperator]).
  sentToOperatorAlt(5),

  /// Failed at the SMSC.
  failed(6),

  /// Delivered to the handset.
  delivered(10),

  /// Not delivered to the handset.
  undelivered(11),

  /// Send was canceled or failed; cost refunded.
  canceled(13),

  /// Blocked (e.g. promotional opt-out); cost refunded.
  blocked(14),

  /// Message id is unknown or does not belong to this account.
  invalidMessageId(100),

  /// Status code was not recognized.
  unknown(-1);

  const MessageDeliveryStatus(this.code);

  /// Numeric API status code.
  final int code;

  /// Maps an API integer to [MessageDeliveryStatus].
  static MessageDeliveryStatus fromCode(int? value) {
    if (value == null) {
      return unknown;
    }
    for (final status in MessageDeliveryStatus.values) {
      if (status.code == value) {
        return status;
      }
    }
    return unknown;
  }
}
