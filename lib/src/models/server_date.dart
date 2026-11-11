/// Server date from `utils/getdate`.
class ServerDate {
  /// Creates [ServerDate].
  const ServerDate({
    required this.datetime,
    required this.year,
    required this.month,
    required this.day,
    required this.hour,
    required this.minute,
    required this.second,
    required this.unixtime,
  });

  /// Parses getdate `entries`.
  factory ServerDate.fromJson(Map<String, dynamic> json) {
    return ServerDate(
      datetime: json['datetime']?.toString() ?? '',
      year: _asInt(json['year']),
      month: _asInt(json['month']),
      day: _asInt(json['day']),
      hour: _asInt(json['hour']),
      minute: _asInt(json['minute']),
      second: _asInt(json['second']),
      unixtime: _asInt(json['unixtime']),
    );
  }

  /// Formatted server datetime string.
  final String datetime;

  /// Year component.
  final int year;

  /// Month component.
  final int month;

  /// Day component.
  final int day;

  /// Hour component.
  final int hour;

  /// Minute component.
  final int minute;

  /// Second component.
  final int second;

  /// Unix timestamp (seconds).
  final int unixtime;
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
