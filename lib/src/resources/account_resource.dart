import '../internal/api_transport.dart';
import '../internal/entry_parser.dart';
import '../internal/request_encoding.dart';
import '../models/account_config.dart';
import '../models/account_info.dart';

/// Account info and configuration.
class AccountResource {
  /// Creates [AccountResource].
  AccountResource(this._transport);

  final ApiTransport _transport;

  /// Returns remaining credit and account metadata.
  Future<AccountInfo> info() async {
    final envelope = await _transport.send(
      scope: 'account',
      method: 'info',
      httpMethod: HttpMethod.get,
    );
    return AccountInfo.fromJson(parseEntryObject(envelope.entries));
  }

  /// Reads or updates account configuration values.
  Future<AccountConfig> config({
    String? apiLogs,
    String? debugMode,
    String? defaultSender,
    int? minCreditAlarm,
    String? resendFailed,
  }) async {
    final envelope = await _transport.send(
      scope: 'account',
      method: 'config',
      fields: omitNull({
        'apilogs': apiLogs,
        'debugmode': debugMode,
        'defaultsender': defaultSender,
        'mincreditalarm': minCreditAlarm?.toString(),
        'resendfailed': resendFailed,
      }),
    );
    return AccountConfig.fromJson(parseEntryObject(envelope.entries));
  }
}
