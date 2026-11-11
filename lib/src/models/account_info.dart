/// Account summary from `account/info`.
class AccountInfo {
  /// Creates [AccountInfo].
  const AccountInfo({
    required this.remainCredit,
    required this.expireDate,
    required this.type,
  });

  /// Parses `entries` from account info.
  factory AccountInfo.fromJson(Map<String, dynamic> json) {
    return AccountInfo(
      remainCredit: _asInt(json['remaincredit']),
      expireDate: _asInt(json['expiredate']),
      type: json['type']?.toString() ?? '',
    );
  }

  /// Remaining credit in IRR.
  final int remainCredit;

  /// Security expiry timestamp (Unix seconds).
  final int expireDate;

  /// Account type (`master` or `child`).
  final String type;
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
