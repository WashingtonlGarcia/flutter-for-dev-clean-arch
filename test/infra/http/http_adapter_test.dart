import 'package:dio/dio.dart';
import 'package:faker/faker.dart';
import 'package:flutter_for_dev_clean_arch/data/http/http.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class HttpAdapter {
  final Dio client;

  HttpAdapter({required this.client});

  Future<void> call({required String url, required MethodType method, Map<String, dynamic>? body}) async {
    await client.post(url);
  }
}

class HttpClientSpy extends Mock implements Dio {}

void main() {
  setUp(() {});

  group('post', () {
    test('should call post with correct values', () async {
      final url = faker.internet.httpUrl();
      final client = HttpClientSpy();
      when(() => client.post(url))
          .thenAnswer((invocation) async => Response(data: {}, statusCode: 200, requestOptions: RequestOptions(path: '')));
      final sut = HttpAdapter(client: client);
      await sut(url: url, method: MethodType.post);
      verify(() => client.post(url));
    });
  });
}
