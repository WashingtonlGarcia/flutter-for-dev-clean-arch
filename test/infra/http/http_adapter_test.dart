import 'package:dio/dio.dart';
import 'package:faker/faker.dart';
import 'package:flutter_for_dev_clean_arch/data/http/http.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class HttpAdapter implements HttpClient {
  final Dio client;

  HttpAdapter({required this.client});

  @override
  Future<Map<String, dynamic>> call(
      {required String url, required MethodType method, Map<String, dynamic>? body, Map<String, dynamic>? headers}) async {
    return (await client.post(url,
            data: body,
            options: Options(headers: headers ?? {Headers.contentTypeHeader: 'application/json', Headers.acceptHeader: 'application/json'})))
        .data as Map<String, dynamic>;
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
      when(() => client.post(url, options: any(named: 'options'), data: any(named: 'data')))
          .thenAnswer((invocation) async => Response(data: {'any_key': 'any_value'}, requestOptions: RequestOptions(path: '')));

      await sut(
          url: url,
          method: MethodType.post,
          body: {'any_key': 'any_value'},
          headers: {Headers.contentTypeHeader: 'application/json', Headers.acceptHeader: 'application/json'});

      verify(() => client.post(url, data: {'any_key': 'any_value'}, options: any(named: 'options')));
    });

    test('should call post with without body', () async {
      when(() => client.post(any(), options: any(named: 'options'), data: any(named: 'data')))
          .thenAnswer((invocation) async => Response(data: {'any_key': 'any_value'}, requestOptions: RequestOptions(path: '')));

      await sut(
          url: url, method: MethodType.post, headers: {Headers.contentTypeHeader: 'application/json', Headers.acceptHeader: 'application/json'});

      verify(() => client.post(url, options: any(named: 'options')));
    });

    test('should return data if post returns 200', () async {
      when(() => client.post(any(), options: any(named: 'options'), data: any(named: 'data'))).thenAnswer((invocation) async => Response(
          data: {'any_key': 'any_value'},
          statusCode: 200,
          requestOptions: RequestOptions(
            path: '',
          )));

      final result = await sut(
          url: url, method: MethodType.post, headers: {Headers.contentTypeHeader: 'application/json', Headers.acceptHeader: 'application/json'});

      expect(result, {'any_key': 'any_value'});
      verify(() => client.post(url, options: any(named: 'options')));
    });
  });
}
