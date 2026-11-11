/// Account configuration from `account/config`.
class AccountConfig {
  /// Creates [AccountConfig].
  const AccountConfig({
    required this.apiLogs,
    required this.debugMode,
    required this.defaultSender,
    required this.minCreditAlarm,
    required this.resendFailed,
    this.dailyReport,
  });

  /// Parses config `entries`.
  factory AccountConfig.fromJson(Map<String, dynamic> json) {
    return AccountConfig(
      apiLogs: json['apilogs']?.toString() ?? '',
      debugMode: json['debugmode']?.toString() ?? '',
      defaultSender: json['defaultsender']?.toString() ?? '',
      minCreditAlarm: json['mincreditalarm']?.toString() ?? '',
      resendFailed: json['resendfailed']?.toString() ?? '',
      dailyReport: json['dailyreport']?.toString(),
    );
  }

  /// API log mode (`disabled`, `enabled`, `justfaults`).
  final String apiLogs;

  /// Debug mode (`enabled` / `disabled`).
  final String debugMode;

  /// Default sender line.
  final String defaultSender;

  /// Minimum credit alarm threshold (IRR).
  final String minCreditAlarm;

  /// Automatic resend for undelivered messages.
  final String resendFailed;

  /// Daily report setting when present.
  final String? dailyReport;
}
