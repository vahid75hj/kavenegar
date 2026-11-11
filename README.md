# kavenegar

Pure Dart client for the [Kavenegar SMS REST API](https://kavenegar.com/rest.html).  
Works on VM, web, and WASM backends with a single `package:http` dependency.

## Installation

```yaml
dependencies:
  kavenegar: ^0.1.0
```

```bash
dart pub add kavenegar
```

## Quick start

```dart
import 'package:kavenegar/kavenegar.dart';

final client = KavenegarClient(apiKey: 'YOUR_API_KEY');

try {
  final result = await client.sms.send(
    sender: '10004346',
    receptors: ['09120000000'],
    message: 'Hello',
  );
  print(result.first.messageId);
} on KavenegarApiException catch (e) {
  print('API ${e.status}: ${e.message}');
} on KavenegarHttpException catch (e) {
  print('HTTP: ${e.message}');
} finally {
  client.close();
}
```

OTP / template lookup:

```dart
await client.verify.lookup(
  receptor: '09120000000',
  token: '123456',
  template: 'login',
);
```

See [`example/example.dart`](example/example.dart) for a runnable sample.

## API surface

`KavenegarClient` exposes namespaced resources:

| Resource | Scope | Methods |
| --- | --- | --- |
| `sms` | `sms` | `send`, `sendArray`, `status`, `statusByLocalMessageId`, `statusByReceptor`, `select`, `selectOutbox`, `latestOutbox`, `countOutbox`, `cancel`, `receive`, `inboxPaged`, `countInbox` |
| `verify` | `verify` | `lookup`, `templateList`, `cloneTemplate`, `addTemplate`, `updateTemplate`, `getTemplate`, `deleteTemplate` |
| `call` | `call` | `makeTts` |
| `account` | `account` | `info`, `config` |
| `line` | `line/blocked` | `blockedList`, `blockedAdd`, `blockedExists`, `blockedRemove` |
| `media` | `media` | `upload`, `list`, `get`, `delete` |
| `utils` | `utils` | `getDate` |

Constructor options:

- `httpClient` — inject `http.Client` for testing or connection pooling
- `baseUrl` — defaults to `https://api.kavenegar.com`
- `timeout` — per-request timeout (`Duration`)

The API key is part of the URL path. The client **never** prints the raw key in exceptions or `toString` (it is replaced with `***`).

## Error handling

Two sealed exception types:

- **`KavenegarApiException`** — HTTP call succeeded but `return.status != 200`. Check `status` and `message`.
- **`KavenegarHttpException`** — network/timeout/invalid JSON (`httpStatus` when available).

`KavenegarApiErrorCodes.description(code)` returns the documented meaning from the official error table.  
Code **412** (and some others) are **context-dependent** — always read the API `message` for endpoint-specific detail.

| Code | Meaning (default) |
| --- | --- |
| 400 | Parameters incomplete |
| 401 | Account inactive |
| 403 | Invalid API key |
| 411 | Invalid receptor |
| 412 | Invalid sender (varies by endpoint) |
| 414 | Request size limit exceeded |
| 417 | Invalid date |
| 418 | Insufficient credit |
| 424 | Template not found |
| 501 | Test messages only to account owner |
| 604 | Too many numbers (max 200) |
| 607 | Invalid tag |
| 800–813 | Media errors (see `KavenegarApiErrorCodes`) |

Full list: `KavenegarApiErrorCodes.descriptions` in DartDoc.

## Serverpod integration

**Never expose your Kavenegar API key in a Flutter client app.** Keep sending on the server.

`config/passwords.yaml`:

```yaml
kavenegarApiKey: 'YOUR_KAVENEGAR_API_KEY'
```

`server.dart` (create the client once):

```dart
import 'package:kavenegar/kavenegar.dart';
import 'package:serverpod/serverpod.dart';

late final KavenegarClient kavenegar;

void run(List<String> args) async {
  final pod = Serverpod(args, Protocol(), Endpoints());
  kavenegar = KavenegarClient(
    apiKey: pod.getPassword('kavenegarApiKey')!,
  );
  await pod.start();
}
```

Endpoint example:

```dart
import 'package:kavenegar/kavenegar.dart';

class SmsEndpoint extends Endpoint {
  Future<bool> sendOtp(Session session, String mobile, String code) async {
    try {
      await kavenegar.verify.lookup(
        receptor: mobile,
        token: code,
        template: 'login',
      );
      return true;
    } on KavenegarApiException catch (e) {
      session.log('Kavenegar ${e.status}: ${e.message}');
      return false;
    }
  }
}
```

Dispose on shutdown if you create a dedicated `http.Client`; the default `KavenegarClient.close()` is enough when you use the built-in client.

## Security warning

Do **not** ship `KavenegarClient` with a production API key inside Flutter/mobile apps. Anyone can extract it. Use Serverpod (or another backend) to call Kavenegar.

## فارسی (خلاصه)

این پکیج کلاینت Dart برای وب‌سرویس REST کاوه‌نگار است. کلید API را فقط روی سرور (مثلاً Serverpod) نگه دارید، نه در اپ Flutter. نصب با `dart pub add kavenegar` و استفاده از `KavenegarClient(apiKey: ...)`. خطاها با `KavenegarApiException` و `KavenegarHttpException` مدیریت می‌شوند.

## Development

```bash
dart format .
dart analyze
dart test
dart pub publish --dry-run
```

## License

MIT — see [LICENSE](LICENSE).
