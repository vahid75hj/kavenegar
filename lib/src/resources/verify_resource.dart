import '../enums/verify_delivery_type.dart';
import '../internal/api_transport.dart';
import '../internal/entry_parser.dart';
import '../internal/request_encoding.dart';
import '../models/send_result.dart';
import '../models/template_list_result.dart';
import '../models/verify_template.dart';

/// OTP / lookup and verification template management.
class VerifyResource {
  /// Creates [VerifyResource].
  VerifyResource(this._transport);

  final ApiTransport _transport;

  /// Sends a verification code using a predefined template.
  Future<List<SendResult>> lookup({
    required String receptor,
    required String token,
    required String template,
    String? token2,
    String? token3,
    String? token10,
    String? token20,
    VerifyDeliveryType type = VerifyDeliveryType.sms,
    String? tag,
  }) async {
    final envelope = await _transport.send(
      scope: 'verify',
      method: 'lookup',
      fields: omitNull({
        'receptor': receptor,
        'token': token,
        'token2': token2,
        'token3': token3,
        'token10': token10,
        'token20': token20,
        'template': template,
        'type': type.apiValue,
        'tag': tag,
      }),
    );
    return parseEntryList(envelope.entries)
        .map(SendResult.fromJson)
        .toList(growable: false);
  }

  /// Lists verification templates.
  Future<TemplateListResult> templateList({
    int? page,
    String? subAccountApiKey,
    String? localId,
  }) async {
    final envelope = await _transport.send(
      scope: 'verify',
      method: 'templatelist',
      httpMethod: HttpMethod.get,
      fields: omitNull({
        'page': page?.toString(),
        'apiKey': subAccountApiKey,
        'localId': localId,
      }),
    );
    return TemplateListResult.fromEntries(
      envelope.entries,
      metadata: envelope.metadata,
    );
  }

  /// Clones an existing approved template.
  Future<CloneTemplateResult> cloneTemplate({
    required String newTemplateName,
    int? sourceTemplateId,
    String? sourceTemplateName,
    String? subAccountApiKey,
    String? localId,
  }) async {
    final envelope = await _transport.send(
      scope: 'verify',
      method: 'clonetemplate',
      fields: omitNull({
        'sourceTemplateId': sourceTemplateId?.toString(),
        'sourceTemplateName': sourceTemplateName,
        'newTemplateName': newTemplateName,
        'apiKey': subAccountApiKey,
        'localId': localId,
      }),
    );
    return CloneTemplateResult.fromJson(parseEntryObject(envelope.entries));
  }

  /// Creates a verification template.
  Future<VerifyTemplateMutation> addTemplate({
    required int sourceType,
    required int sendMethod,
    required String name,
    String? textMessage,
    String? voiceMessage,
    int? fallBackMethod,
    String? primaryLineNumber,
    String? secondaryLineNumber,
    int? switchTtl,
    String? sourceUrl,
    String? sourceName,
    String? subAccountApiKey,
    String? localId,
  }) async {
    final envelope = await _transport.send(
      scope: 'verify',
      method: 'addtemplate',
      fields: omitNull({
        'sourceType': sourceType.toString(),
        'sendMethod': sendMethod.toString(),
        'fallBackMethod': fallBackMethod?.toString(),
        'primaryLineNumber': primaryLineNumber,
        'secondaryLineNumber': secondaryLineNumber,
        'switchTTL': switchTtl?.toString(),
        'sourceUrl': sourceUrl,
        'sourceName': sourceName,
        'name': name,
        'textMessage': textMessage,
        'voiceMessage': voiceMessage,
        'apiKey': subAccountApiKey,
        'localId': localId,
      }),
    );
    return VerifyTemplateMutation.fromJson(parseEntryObject(envelope.entries));
  }

  /// Updates a verification template.
  Future<VerifyTemplateMutation> updateTemplate({
    required int templateId,
    required int sourceType,
    required int sendMethod,
    required String name,
    String? textMessage,
    String? voiceMessage,
    int? fallBackMethod,
    String? primaryLineNumber,
    String? secondaryLineNumber,
    int? switchTtl,
    String? sourceUrl,
    String? sourceName,
    String? subAccountApiKey,
    String? localId,
  }) async {
    final envelope = await _transport.send(
      scope: 'verify',
      method: 'updatetemplate',
      fields: omitNull({
        'templateId': templateId.toString(),
        'sourceType': sourceType.toString(),
        'sendMethod': sendMethod.toString(),
        'fallBackMethod': fallBackMethod?.toString(),
        'primaryLineNumber': primaryLineNumber,
        'secondaryLineNumber': secondaryLineNumber,
        'switchTTL': switchTtl?.toString(),
        'sourceUrl': sourceUrl,
        'sourceName': sourceName,
        'name': name,
        'textMessage': textMessage,
        'voiceMessage': voiceMessage,
        'apiKey': subAccountApiKey,
        'localId': localId,
      }),
    );
    return VerifyTemplateMutation.fromJson(parseEntryObject(envelope.entries));
  }

  /// Fetches a single template by id.
  Future<VerifyTemplate> getTemplate(
    int id, {
    String? subAccountApiKey,
    String? localId,
  }) async {
    final envelope = await _transport.send(
      scope: 'verify',
      method: 'gettemplate',
      httpMethod: HttpMethod.get,
      fields: omitNull({
        'id': id.toString(),
        'apiKey': subAccountApiKey,
        'localId': localId,
      }),
    );
    return VerifyTemplate.fromJson(parseEntryObject(envelope.entries));
  }

  /// Deletes a template by id.
  Future<void> deleteTemplate(
    int id, {
    String? subAccountApiKey,
    String? localId,
  }) async {
    await _transport.send(
      scope: 'verify',
      method: 'deletetemplate',
      fields: omitNull({
        'id': id.toString(),
        'apiKey': subAccountApiKey,
        'localId': localId,
      }),
    );
  }
}
