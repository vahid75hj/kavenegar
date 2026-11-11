/// Masks an API key wherever it may appear in a string.
String maskApiKey(String value, String apiKey) {
  if (apiKey.isEmpty) {
    return value;
  }
  return value.replaceAll(apiKey, _maskedPlaceholder);
}

const _maskedPlaceholder = '***';

/// Returns a safe placeholder for logging or [Object.toString].
String maskedApiKeyLabel() => _maskedPlaceholder;
