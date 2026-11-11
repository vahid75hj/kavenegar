/// Aggregated inbox statistics.
class CountInboxResult {
  /// Creates a [CountInboxResult].
  const CountInboxResult({
    required this.startDate,
    required this.endDate,
    required this.sumCount,
  });

  /// Parses one countinbox entry.
  factory CountInboxResult.fromJson(Map<String, dynamic> json) {
    return CountInboxResult(
      startDate: _asInt(json['startdate']),
      endDate: _asInt(json['enddate']),
      sumCount: _asInt(json['sumcount']),
    );
  }

  /// Range start (Unix seconds).
  final int startDate;

  /// Range end (Unix seconds).
  final int endDate;

  /// Total received messages in range.
  final int sumCount;
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
