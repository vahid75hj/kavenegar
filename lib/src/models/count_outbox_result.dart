/// Aggregated outbox statistics.
class CountOutboxResult {
  /// Creates a [CountOutboxResult].
  const CountOutboxResult({
    required this.startDate,
    required this.endDate,
    required this.sumPart,
    required this.sumCount,
    required this.cost,
  });

  /// Parses one countoutbox entry.
  factory CountOutboxResult.fromJson(Map<String, dynamic> json) {
    return CountOutboxResult(
      startDate: _asInt(json['startdate']),
      endDate: _asInt(json['enddate']),
      sumPart: _asInt(json['sumpart']),
      sumCount: _asInt(json['sumcount']),
      cost: _asInt(json['cost']),
    );
  }

  /// Range start (Unix seconds).
  final int startDate;

  /// Range end (Unix seconds).
  final int endDate;

  /// Total message parts.
  final int sumPart;

  /// Total messages.
  final int sumCount;

  /// Total cost in IRR.
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
