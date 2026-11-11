import 'dart:convert';

import 'package:http/http.dart' as http;

const successEnvelopePrefix = '''
{
  "return": {"status": 200, "message": "ok"},
''';

String listEnvelope(String entriesJson) =>
    '$successEnvelopePrefix"entries": $entriesJson}';

String objectEnvelope(String entriesJson) =>
    '$successEnvelopePrefix"entries": $entriesJson}';

/// UTF-8 JSON [http.Response] for MockClient handlers.
http.Response utf8JsonResponse(String body, {int statusCode = 200}) {
  return http.Response.bytes(
    utf8.encode(body),
    statusCode,
    headers: const {'content-type': 'application/json; charset=utf-8'},
  );
}

const sendEntry = '''
{
  "messageid": 1,
  "message": "test",
  "status": 1,
  "statustext": "queued",
  "sender": "1000",
  "receptor": "09120000000",
  "date": 1700000000,
  "cost": 120
}
''';

const accountInfoEntry = '''
{
  "remaincredit": 1000,
  "expiredate": 2000,
  "type": "master"
}
''';
