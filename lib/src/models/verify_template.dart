/// Verification template metadata.
class VerifyTemplate {
  /// Creates [VerifyTemplate].
  const VerifyTemplate({
    required this.id,
    required this.name,
    this.smsMessage,
    this.callMessage,
    this.primaryLineNumber,
    this.secondaryLineNumber,
    this.sendPriority,
    this.switchTtl,
    this.approvalStatus,
  });

  /// Parses template list/detail entries.
  factory VerifyTemplate.fromJson(Map<String, dynamic> json) {
    return VerifyTemplate(
      id: _asInt(json['id'] ?? json['templateid']),
      name: json['name']?.toString() ?? '',
      smsMessage:
          json['smsMessage']?.toString() ?? json['textmessage']?.toString(),
      callMessage:
          json['callMessage']?.toString() ?? json['voicemessage']?.toString(),
      primaryLineNumber: json['primaryLineNumber']?.toString() ??
          json['primarylinenumber']?.toString(),
      secondaryLineNumber: json['secondaryLineNumber']?.toString() ??
          json['secondarylinenumber']?.toString(),
      sendPriority: json['sendPriority']?.toString(),
      switchTtl: _optionalInt(json['switchTTL'] ?? json['switchttL']),
      approvalStatus: json['approvalStatus']?.toString(),
    );
  }

  /// Template id.
  final int id;

  /// Template name.
  final String name;

  /// SMS template body.
  final String? smsMessage;

  /// Voice template body.
  final String? callMessage;

  /// Primary line.
  final String? primaryLineNumber;

  /// Secondary line.
  final String? secondaryLineNumber;

  /// `SMS` or `Call`.
  final String? sendPriority;

  /// Fallback switch TTL.
  final int? switchTtl;

  /// Approval state.
  final String? approvalStatus;
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

/// Result of add/update/clone template mutations.
class VerifyTemplateMutation {
  /// Creates [VerifyTemplateMutation].
  const VerifyTemplateMutation({
    required this.templateId,
    required this.name,
    this.sourceType,
    this.sendMethod,
    this.fallBackMethod,
    this.primaryLineNumber,
    this.secondaryLineNumber,
    this.switchTtl,
    this.sourceUrl,
    this.sourceName,
    this.textMessage,
    this.voiceMessage,
  });

  /// Parses mutation response object entries.
  factory VerifyTemplateMutation.fromJson(Map<String, dynamic> json) {
    return VerifyTemplateMutation(
      templateId: json['templateid']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      sourceType: json['sourcetype']?.toString(),
      sendMethod: json['sendmethod']?.toString(),
      fallBackMethod: json['fallbackmethod']?.toString(),
      primaryLineNumber: json['primarylinenumber']?.toString(),
      secondaryLineNumber: json['secondarylinenumber']?.toString(),
      switchTtl: _optionalInt(json['switchttL']),
      sourceUrl: json['sourceurl']?.toString(),
      sourceName: json['sourcename']?.toString(),
      textMessage: json['textmessage']?.toString(),
      voiceMessage: json['voicemessage']?.toString(),
    );
  }

  /// Created/updated template id.
  final String templateId;

  /// Template name.
  final String name;

  /// Source type.
  final String? sourceType;

  /// Send method.
  final String? sendMethod;

  /// Fallback method.
  final String? fallBackMethod;

  /// Primary line.
  final String? primaryLineNumber;

  /// Secondary line.
  final String? secondaryLineNumber;

  /// Switch TTL.
  final int? switchTtl;

  /// Source URL.
  final String? sourceUrl;

  /// Source name.
  final String? sourceName;

  /// SMS text.
  final String? textMessage;

  /// Voice text.
  final String? voiceMessage;
}

/// Clone template result.
class CloneTemplateResult {
  /// Creates [CloneTemplateResult].
  const CloneTemplateResult({required this.id, required this.name});

  /// Parses clone response entry.
  factory CloneTemplateResult.fromJson(Map<String, dynamic> json) {
    return CloneTemplateResult(
      id: _asInt(json['id']),
      name: json['name']?.toString() ?? '',
    );
  }

  /// New template id.
  final int id;

  /// New template name.
  final String name;
}

int? _optionalInt(Object? value) {
  if (value == null) {
    return null;
  }
  if (value is int) {
    return value;
  }
  if (value is String) {
    return int.tryParse(value);
  }
  return null;
}
