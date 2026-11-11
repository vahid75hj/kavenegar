/// A number that blocked a sender line.
class BlockedLineEntry {
  /// Creates [BlockedLineEntry].
  const BlockedLineEntry({
    required this.number,
    required this.blockReason,
    required this.date,
    this.totalCount,
    this.currentPage,
    this.totalPages,
    this.pageSize,
  });

  /// Parses blocked list entries (metadata fields may repeat per row).
  factory BlockedLineEntry.fromJson(Map<String, dynamic> json) {
    return BlockedLineEntry(
      number: json['number']?.toString() ?? '',
      blockReason: json['blockreason']?.toString() ?? '',
      date: _asInt(json['date']),
      totalCount: json['totalcount']?.toString(),
      currentPage: json['currentpage']?.toString(),
      totalPages: json['totalpages']?.toString(),
      pageSize: json['pagesize']?.toString(),
    );
  }

  /// Blocked phone number.
  final String number;

  /// Block reason label/code.
  final String blockReason;

  /// Block registration time.
  final int date;

  /// Total count (paging metadata when included).
  final String? totalCount;

  /// Current page metadata.
  final String? currentPage;

  /// Total pages metadata.
  final String? totalPages;

  /// Page size metadata.
  final String? pageSize;
}

/// Result of checking whether numbers are blocked.
class BlockedLineExistsResult {
  /// Creates [BlockedLineExistsResult].
  const BlockedLineExistsResult({
    required this.number,
    required this.exists,
  });

  /// Parses exists response rows.
  factory BlockedLineExistsResult.fromJson(Map<String, dynamic> json) {
    return BlockedLineExistsResult(
      number: json['number']?.toString() ?? json['receptor']?.toString() ?? '',
      exists: json['exists'] == true ||
          json['exists']?.toString() == '1' ||
          json['exists']?.toString().toLowerCase() == 'true',
    );
  }

  /// Queried number.
  final String number;

  /// Whether the number blocked the line.
  final bool exists;
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
