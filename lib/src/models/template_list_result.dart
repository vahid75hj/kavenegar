import 'verify_template.dart';

/// Template list response including metadata.
class TemplateListResult {
  /// Creates [TemplateListResult].
  const TemplateListResult({
    required this.templates,
    this.totalCount,
    this.currentPage,
    this.totalPages,
    this.pageSize,
  });

  /// Parses templatelist response.
  factory TemplateListResult.fromEntries(
    Object? entries, {
    Map<String, dynamic>? metadata,
  }) {
    final templates = <VerifyTemplate>[];
    if (entries is List) {
      for (final item in entries) {
        if (item is Map<String, dynamic>) {
          templates.add(VerifyTemplate.fromJson(item));
        }
      }
    }

    String? totalCount;
    String? currentPage;
    String? totalPages;
    String? pageSize;
    if (metadata != null) {
      totalCount = metadata['TotalCount']?.toString() ??
          metadata['totalcount']?.toString();
      currentPage = metadata['CurrentPage']?.toString() ??
          metadata['currentpage']?.toString();
      totalPages = metadata['TotalPages']?.toString() ??
          metadata['totalpages']?.toString();
      pageSize =
          metadata['PageSize']?.toString() ?? metadata['pagesize']?.toString();
    }

    return TemplateListResult(
      templates: templates,
      totalCount: totalCount,
      currentPage: currentPage,
      totalPages: totalPages,
      pageSize: pageSize,
    );
  }

  /// Templates on this page.
  final List<VerifyTemplate> templates;

  /// Total templates (when metadata is returned).
  final String? totalCount;

  /// Current page.
  final String? currentPage;

  /// Total pages.
  final String? totalPages;

  /// Page size.
  final String? pageSize;
}
