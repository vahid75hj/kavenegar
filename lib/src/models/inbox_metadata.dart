/// Paging metadata returned with `SmsResource.inboxPaged`.
class InboxMetadata {
  /// Creates [InboxMetadata].
  const InboxMetadata({
    required this.totalCount,
    required this.currentPage,
    required this.totalPages,
    required this.pageSize,
  });

  /// Parses the `metadata` object.
  factory InboxMetadata.fromJson(Map<String, dynamic> json) {
    return InboxMetadata(
      totalCount: json['totalcount']?.toString() ?? '0',
      currentPage: json['currentpage']?.toString() ?? '1',
      totalPages: json['totalpages']?.toString() ?? '1',
      pageSize: json['pagesize']?.toString() ?? '0',
    );
  }

  /// Total messages for the query.
  final String totalCount;

  /// Current page number.
  final String currentPage;

  /// Total pages.
  final String totalPages;

  /// Page size.
  final String pageSize;
}
