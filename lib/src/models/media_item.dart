/// Uploaded media file metadata.
class MediaItem {
  /// Creates [MediaItem].
  const MediaItem({
    required this.id,
    required this.name,
    required this.mimeType,
    required this.extension,
    required this.size,
    required this.duration,
    required this.resolution,
    required this.status,
    required this.statusDesc,
    this.review,
  });

  /// Parses media upload/get/list DTO.
  factory MediaItem.fromJson(Map<String, dynamic> json) {
    final reviewJson = json['review'];
    return MediaItem(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      mimeType: json['mime_type']?.toString() ?? '',
      extension: json['extension']?.toString() ?? '',
      size: _asInt(json['size']),
      duration: _asInt(json['duration']),
      resolution: json['resolution']?.toString() ?? '',
      status: _asInt(json['status']),
      statusDesc: json['status_desc']?.toString() ?? '',
      review: reviewJson is Map<String, dynamic>
          ? MediaReview.fromJson(reviewJson)
          : null,
    );
  }

  /// Media GUID.
  final String id;

  /// File name.
  final String name;

  /// MIME type.
  final String mimeType;

  /// File extension.
  final String extension;

  /// Size in bytes.
  final int size;

  /// Duration in seconds (video).
  final int duration;

  /// Resolution string for images/video.
  final String resolution;

  /// Processing status code.
  final int status;

  /// Processing status description.
  final String statusDesc;

  /// Review details when present.
  final MediaReview? review;
}

/// Media review status.
class MediaReview {
  /// Creates [MediaReview].
  const MediaReview({
    required this.status,
    required this.statusDesc,
    required this.reason,
    required this.reasonDesc,
  });

  /// Parses nested review object.
  factory MediaReview.fromJson(Map<String, dynamic> json) {
    return MediaReview(
      status: _asInt(json['status']),
      statusDesc: json['status_desc']?.toString() ?? '',
      reason: _asInt(json['reason']),
      reasonDesc: json['reason_desc']?.toString() ?? '',
    );
  }

  /// Review status.
  final int status;

  /// Review status text.
  final String statusDesc;

  /// Reason code.
  final int reason;

  /// Reason description.
  final String reasonDesc;
}

/// Media list response.
class MediaListResult {
  /// Creates [MediaListResult].
  const MediaListResult({
    required this.page,
    required this.size,
    required this.total,
    required this.items,
  });

  /// Parses media list `entries` object.
  factory MediaListResult.fromJson(Map<String, dynamic> json) {
    final list = json['list'];
    final items = <MediaItem>[];
    if (list is List) {
      for (final entry in list) {
        if (entry is Map<String, dynamic>) {
          items.add(MediaItem.fromJson(entry));
        }
      }
    }
    return MediaListResult(
      page: _asInt(json['page']),
      size: _asInt(json['size']),
      total: _asInt(json['total']),
      items: items,
    );
  }

  /// Current page.
  final int page;

  /// Page size.
  final int size;

  /// Total media count.
  final int total;

  /// Media on this page.
  final List<MediaItem> items;
}

/// Result of deleting media.
class MediaDeleteResult {
  /// Creates [MediaDeleteResult].
  const MediaDeleteResult({required this.id, required this.deleted});

  /// Parses delete response entry.
  factory MediaDeleteResult.fromJson(Map<String, dynamic> json) {
    return MediaDeleteResult(
      id: json['id']?.toString() ?? '',
      deleted: json['deleted'] == true || json['deleted']?.toString() == 'true',
    );
  }

  /// Deleted media id.
  final String id;

  /// Whether deletion succeeded.
  final bool deleted;
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
