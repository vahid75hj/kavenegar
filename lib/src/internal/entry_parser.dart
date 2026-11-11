/// Helpers to parse `entries` list/object shapes from the API envelope.
List<Map<String, dynamic>> parseEntryList(Object? entries) {
  if (entries == null) {
    return const [];
  }
  if (entries is List) {
    return [
      for (final item in entries)
        if (item is Map<String, dynamic>) item,
    ];
  }
  if (entries is Map<String, dynamic>) {
    return [entries];
  }
  return const [];
}

/// Parses a single object `entries` value.
Map<String, dynamic> parseEntryObject(Object? entries) {
  if (entries is Map<String, dynamic>) {
    return entries;
  }
  throw const FormatException('Expected entries object');
}
