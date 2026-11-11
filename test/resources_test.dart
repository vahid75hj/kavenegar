import 'package:http/testing.dart';
import 'package:kavenegar/kavenegar.dart';
import 'package:test/test.dart';

import 'helpers/test_responses.dart';

const _apiKey = 'test-key';
const _base = 'https://mock.local';

void main() {
  group('resource routing', () {
    Future<KavenegarClient> clientWith(MockClient mock) async {
      final client = KavenegarClient(
        apiKey: _apiKey,
        httpClient: mock,
        baseUrl: _base,
      );
      return client;
    }

    test('sms.statuslocalmessageid uses correct method path', () async {
      late Uri url;
      final mock = MockClient((request) async {
        url = request.url;
        return utf8JsonResponse(listEnvelope('[]'));
      });
      final client = await clientWith(mock);
      addTearDown(client.close);
      await client.sms.statusByLocalMessageId([1, 2]);
      expect(url.path, '/v1/$_apiKey/sms/statuslocalmessageid.json');
    });

    test('sms.inboxPaged includes metadata', () async {
      final mock = MockClient((_) async {
        return utf8JsonResponse('''
{
  "return": {"status": 200, "message": "ok"},
  "entries": [],
  "metadata": {"totalcount": "0", "currentpage": "1", "totalpages": "1", "pagesize": "200"}
}
''');
      });
      final client = await clientWith(mock);
      addTearDown(client.close);
      final page = await client.sms.inboxPaged(
        lineNumber: '3000',
        isRead: 0,
      );
      expect(page.metadata?.totalCount, '0');
    });

    test('verify.templatelist uses GET', () async {
      late String method;
      final mock = MockClient((request) async {
        method = request.method;
        return utf8JsonResponse(listEnvelope('[]'));
      });
      final client = await clientWith(mock);
      addTearDown(client.close);
      await client.verify.templateList(page: 1);
      expect(method, 'GET');
    });

    test('media.upload uses multipart File field', () async {
      String? contentType;
      final mock = MockClient((request) async {
        contentType = request.headers['content-type'];
        return utf8JsonResponse(
          objectEnvelope(
            '{"id":"1","name":"a.jpg","mime_type":"image/jpeg","extension":"jpg","size":1,"duration":0,"resolution":"","status":1,"status_desc":""}',
          ),
        );
      });
      final client = await clientWith(mock);
      addTearDown(client.close);
      await client.media.upload(
        bytes: [1, 2, 3],
        filename: 'a.jpg',
      );
      expect(contentType, contains('multipart/form-data'));
    });

    test('sms.countOutbox optional status maps enum', () async {
      late String body;
      final mock = MockClient((request) async {
        body = request.body;
        return utf8JsonResponse(listEnvelope('[]'));
      });
      final client = await clientWith(mock);
      addTearDown(client.close);
      await client.sms.countOutbox(
        startDate: DateTime.fromMillisecondsSinceEpoch(0),
        status: MessageDeliveryStatus.delivered,
      );
      expect(body, contains('status=10'));
    });
  });
}
