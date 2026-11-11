/// Delivery channel for [VerifyResource.lookup].
enum VerifyDeliveryType {
  /// Text SMS (default).
  sms('sms'),

  /// Voice call.
  call('call');

  const VerifyDeliveryType(this.apiValue);

  /// String sent as the `type` parameter.
  final String apiValue;
}
