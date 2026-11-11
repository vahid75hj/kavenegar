/// Message display type on the handset (Kavenegar table 3).
enum MessageDisplayType {
  /// Flash SMS (not stored by default).
  flash(0),

  /// Normal SMS (default).
  normal(1),

  /// Stored on the SIM card.
  sim(2),

  /// Stored by a terminal application.
  application(3);

  const MessageDisplayType(this.value);

  /// API numeric value.
  final int value;

  /// Parses an API value.
  static MessageDisplayType? fromValue(int? value) {
    if (value == null) {
      return null;
    }
    for (final type in MessageDisplayType.values) {
      if (type.value == value) {
        return type;
      }
    }
    return null;
  }
}
