import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:kavenegar/kavenegar.dart';
import 'package:test/test.dart';

import 'helpers/test_responses.dart';

const _apiKey = 'secret-api-key-12345';
const _baseUrl = 'https://example.test';

void main() {
  group('KavenegarClient', () {
    test('masks api key in toString', () {
      final client = KavenegarClient(apiKey: _apiKey);
      addTearDown(client.close);
      expect(client.toString(), isNot(contains(_apiKey)));
      expect(client.toString(), contains('***'));
    });

    test('close disposes owned http client', () {
      final client = KavenegarClient(apiKey: _apiKey);
      expect(() => client.close(), returnsNormally);
    });
  });

  group('transport', () {
    test('sms.send builds POST url and form body', () async {
      late http.Request captured;
      final mock = MockClient((request) async {
        captured = request;
        return utf8JsonResponse(listEnvelope('[$sendEntry]'));
      });
      final client = KavenegarClient(
        apiKey: _apiKey,
        httpClient: mock,
        baseUrl: _baseUrl,
      );
      addTearDown(client.close);

      final result = await client.sms.send(
        receptors: ['09120000001', '09120000002'],
        message: 'hello',
        sender: '1000',
        hide: true,
      );

      expect(result, hasLength(1));
      expect(captured.method, 'POST');
      expect(captured.url.path, '/v1/$_apiKey/sms/send.json');
      expect(captured.url.host, 'example.test');
      expect(captured.headers['Content-Type'],
          contains('application/x-www-form-urlencoded'));
      expect(captured.body, contains('receptor=09120000001%2C09120000002'));
      expect(captured.body, contains('hide=1'));
    });

    test('sms.sendArray JSON-encodes array fields', () async {
      late String body;
      final mock = MockClient((request) async {
        body = request.body;
        return utf8JsonResponse(listEnvelope('[$sendEntry]'));
      });
      final client = KavenegarClient(
        apiKey: _apiKey,
        httpClient: mock,
        baseUrl: _baseUrl,
      );
      addTearDown(client.close);

      await client.sms.sendArray(
        receptors: ['0912', '0913'],
        senders: ['1000', '1001'],
        messages: ['a', 'b'],
      );

      expect(body, contains('receptor='));
      expect(Uri.decodeComponent(body), contains('["0912","0913"]'));
    });

    test('account.info parses object entries', () async {
      final mock = MockClient((request) async {
        expect(request.method, 'GET');
        expect(request.url.path, contains('/account/info.json'));
        return utf8JsonResponse(objectEnvelope(accountInfoEntry));
      });
      final client = KavenegarClient(
        apiKey: _apiKey,
        httpClient: mock,
        baseUrl: _baseUrl,
      );
      addTearDown(client.close);

      final info = await client.account.info();
      expect(info.remainCredit, 1000);
      expect(info.type, 'master');
    });

    test('call.maketts parses single object entries', () async {
      final mock = MockClient((request) async {
        return utf8JsonResponse(objectEnvelope(sendEntry));
      });
      final client = KavenegarClient(
        apiKey: _apiKey,
        httpClient: mock,
        baseUrl: _baseUrl,
      );
      addTearDown(client.close);

      final results = await client.call.makeTts(
        receptors: ['09120000000'],
        message: 'hello',
      );
      expect(results, hasLength(1));
      expect(results.first.messageId, 1);
    });

    test('throws KavenegarApiException when return.status != 200', () async {
      final mock = MockClient((_) async {
        return utf8JsonResponse(
          jsonEncode({
            'return': {'status': 418, 'message': 'key $_apiKey'},
            'entries': null,
          }),
        );
      });
      final client = KavenegarClient(
        apiKey: _apiKey,
        httpClient: mock,
        baseUrl: _baseUrl,
      );
      addTearDown(client.close);

      expect(
        () => client.account.info(),
        throwsA(
          isA<KavenegarApiException>()
              .having((e) => e.status, 'status', 418)
              .having((e) => e.message, 'message', isNot(contains(_apiKey))),
        ),
      );
    });

    test('throws KavenegarHttpException on invalid JSON', () async {
      final mock = MockClient((_) async => http.Response('not-json', 200));
      final client = KavenegarClient(
        apiKey: _apiKey,
        httpClient: mock,
        baseUrl: _baseUrl,
      );
      addTearDown(client.close);

      expect(
        () => client.utils.getDate(),
        throwsA(isA<KavenegarHttpException>()),
      );
    });

    test('line.blocked.remove uses DELETE', () async {
      late http.Request captured;
      final mock = MockClient((request) async {
        captured = request;
        return utf8JsonResponse(objectEnvelope('{"deleted": true}'));
      });
      final client = KavenegarClient(
        apiKey: _apiKey,
        httpClient: mock,
        baseUrl: _baseUrl,
      );
      addTearDown(client.close);

      await client.line.blockedRemove(
        lineNumber: '1000',
        receptors: ['0912'],
      );
      expect(captured.method, 'DELETE');
      expect(captured.url.query, contains('linenumber=1000'));
    });

    test('media.delete uses DELETE', () async {
      late http.Request captured;
      final mock = MockClient((request) async {
        captured = request;
        return utf8JsonResponse(
          objectEnvelope('{"id": "guid", "deleted": true}'),
        );
      });
      final client = KavenegarClient(
        apiKey: _apiKey,
        httpClient: mock,
        baseUrl: _baseUrl,
      );
      addTearDown(client.close);

      await client.media.delete('guid');
      expect(captured.method, 'DELETE');
      expect(captured.url.query, contains('id=guid'));
    });

    test('verify.lookup success parsing', () async {
      final mock = MockClient((request) async {
        expect(request.url.path, contains('/verify/lookup.json'));
        return utf8JsonResponse(listEnvelope('[$sendEntry]'));
      });
      final client = KavenegarClient(
        apiKey: _apiKey,
        httpClient: mock,
        baseUrl: _baseUrl,
      );
      addTearDown(client.close);

      final items = await client.verify.lookup(
        receptor: '09120000000',
        token: '12345',
        template: 'login',
      );
      expect(items.first.deliveryStatus, MessageDeliveryStatus.queued);
    });

    test('utils.getdate parses datetime entry', () async {
      final mock = MockClient((_) async {
        return utf8JsonResponse(
          objectEnvelope(
            '{"datetime":"01/01/2020","year":2020,"month":1,"day":1,"hour":0,"minute":0,"second":0,"unixtime":1577836800}',
          ),
        );
      });
      final client = KavenegarClient(
        apiKey: _apiKey,
        httpClient: mock,
        baseUrl: _baseUrl,
      );
      addTearDown(client.close);

      final date = await client.utils.getDate();
      expect(date.unixtime, 1577836800);
    });

    test('timeout surfaces as KavenegarHttpException', () async {
      final mock = MockClient((_) async {
        await Future<void>.delayed(const Duration(seconds: 2));
        return utf8JsonResponse(objectEnvelope(accountInfoEntry));
      });
      final client = KavenegarClient(
        apiKey: _apiKey,
        httpClient: mock,
        baseUrl: _baseUrl,
        timeout: const Duration(milliseconds: 50),
      );
      addTearDown(client.close);

      expect(
        () => client.account.info(),
        throwsA(isA<KavenegarHttpException>()),
      );
    });
  });

  group('KavenegarApiErrorCodes', () {
    test('documents known status codes', () {
      expect(
        KavenegarApiErrorCodes.description(412),
        isNotNull,
      );
      expect(
        KavenegarApiErrorCodes.description(813),
        contains('Media'),
      );
    });
  });
}
