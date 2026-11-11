import 'package:kavenegar/kavenegar.dart';

Future<void> main() async {
  final client = KavenegarClient(
    apiKey: const String.fromEnvironment(
      'KAVENEGAR_API_KEY',
      defaultValue: 'YOUR_API_KEY',
    ),
  );

  try {
    final sent = await client.sms.send(
      sender: '10004346',
      receptors: ['09120000000'],
      message: 'Hello from kavenegar Dart SDK',
    );
    print('Sent message id: ${sent.first.messageId}');

    final otp = await client.verify.lookup(
      receptor: '09120000000',
      token: '123456',
      template: 'login',
    );
    print('Lookup status: ${otp.first.statusText}');
  } on KavenegarApiException catch (error) {
    final hint = KavenegarApiErrorCodes.description(error.status);
    print('API error ${error.status}: ${error.message}');
    if (hint != null) {
      print('Docs: $hint');
    }
  } on KavenegarHttpException catch (error) {
    print('HTTP error: ${error.message}');
  } finally {
    client.close();
  }
}
