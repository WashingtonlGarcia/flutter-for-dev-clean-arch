import 'package:dio/dio.dart';
import 'package:faker/faker.dart';
import 'package:flutter_for_dev_clean_arch/data/http/http.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class HttpAdapter {
  final Dio client;

  HttpAdapter({required this.client});

  Future<void> call({required String url, required MethodType method, Map<String, dynamic>? body, Map<String, dynamic>? headers}) async {
    await client.post(url,
        options: Options(headers: headers ?? {Headers.contentTypeHeader: 'application/json', Headers.acceptHeader: 'application/json'}));
  }
}

class HttpClientSpy extends Mock implements Dio {}

void main() {
  late String url;
  late HttpClientSpy client;
  late HttpAdapter sut;

  setUp(() {
    url = faker.internet.httpUrl();
    client = HttpClientSpy();
    sut = HttpAdapter(client: client);
  });

  group('post', () {
    test('should call post with correct values', () async {
      when(() => client.post(url, options: any(named: 'options')))
          .thenAnswer((invocation) async => Response(data: {}, statusCode: 200, requestOptions: RequestOptions(path: url)));

      await sut(
          url: url, method: MethodType.post, headers: {Headers.contentTypeHeader: 'application/json', Headers.acceptHeader: 'application/json'});

      verify(() => client.post(url, options: any(named: 'options')));
    });
  });
}
