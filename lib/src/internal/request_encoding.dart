import 'dart:convert';

import '../enums/message_display_type.dart';

/// Joins string values with commas for multi-value API parameters.
String joinCommaSeparated(Iterable<String> values) => values.join(',');

/// Converts a [DateTime] to Unix seconds for the API.
int? unixSeconds(DateTime? value) =>
    value == null ? null : value.millisecondsSinceEpoch ~/ 1000;

/// Encodes a boolean hide flag as `1` when true.
String? hideFlag(bool? hide) => hide == true ? '1' : null;

/// Encodes optional enum values.
String? displayTypeParam(MessageDisplayType? type) => type?.value.toString();

/// JSON-encodes a list of strings for `sendarray` parameters.
String jsonStringList(List<String> values) => jsonEncode(values);

/// JSON-encodes a list of integers for `sendarray` type parameters.
String jsonIntList(List<int> values) => jsonEncode(values);

/// JSON-encodes a list of longs for `sendarray` local message ids.
String jsonLongList(List<int> values) => jsonEncode(values);

/// Builds `application/x-www-form-urlencoded` body bytes, omitting null values.
Map<String, String> omitNull(Map<String, String?> fields) {
  return {
    for (final entry in fields.entries)
      if (entry.value != null) entry.key: entry.value!,
  };
}
