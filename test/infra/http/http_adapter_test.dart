import 'package:dio/dio.dart';
import 'package:faker/faker.dart';
import 'package:flutter_for_dev_clean_arch/data/http/http.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class HttpAdapter implements HttpClient {
  final Dio client;

  HttpAdapter({required this.client});

  @override
  Future<Map<String, dynamic>?> call(
      {required String url, required MethodType method, Map<String, dynamic>? body, Map<String, dynamic>? headers}) async {
    final response = await client.post(url,
        data: body, options: Options(headers: headers ?? {Headers.contentTypeHeader: 'application/json', Headers.acceptHeader: 'application/json'}));
    if (response.statusCode == 200) {
      return response.data != null && response.data is Map<String, dynamic> ? response.data as Map<String, dynamic> : null;
    }
    return null;
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
    When mockRequest() => when(() => client.post(any(), options: any(named: 'options'), data: any(named: 'data')));

    void requestSuccess({dynamic data, required int statusCode}) =>
        mockRequest().thenAnswer((invocation) async => Response(data: data, requestOptions: RequestOptions(path: ''), statusCode: statusCode));

    void verifyPostMethod({Map<String, dynamic>? body}) => verify(() => client.post(url, data: body, options: any(named: 'options')));

    late Map<String, dynamic> map;

    setUp(() {
      map = {'any_key': 'any_value'};
      requestSuccess(data: map, statusCode: 200);
    });

    test('should call post with correct values', () async {
      await sut(
          url: url,
          method: MethodType.post,
          body: map,
          headers: {Headers.contentTypeHeader: 'application/json', Headers.acceptHeader: 'application/json'});

      verifyPostMethod(body: map);
    });

    test('should call post with without body', () async {
      await sut(
          url: url, method: MethodType.post, headers: {Headers.contentTypeHeader: 'application/json', Headers.acceptHeader: 'application/json'});

      verifyPostMethod();
    });

    test('should return data if post returns 200', () async {
      final result = await sut(
          url: url, method: MethodType.post, headers: {Headers.contentTypeHeader: 'application/json', Headers.acceptHeader: 'application/json'});

      expect(result, {'any_key': 'any_value'});
      verifyPostMethod();
    });

    test('should return null if post returns 200 with no data', () async {
      requestSuccess(data: '', statusCode: 200);

      final result = await sut(
          url: url, method: MethodType.post, headers: {Headers.contentTypeHeader: 'application/json', Headers.acceptHeader: 'application/json'});

      expect(result, null);

      verifyPostMethod();
    });
    test('should return null if post returns 204', () async {
      requestSuccess(statusCode: 204, data: '');

      final result = await sut(
          url: url, method: MethodType.post, headers: {Headers.contentTypeHeader: 'application/json', Headers.acceptHeader: 'application/json'});

      expect(result, null);

      verifyPostMethod();
    });

    test('should return null if post returns 204 with no data', () async {
      requestSuccess(statusCode: 204);

      final result = await sut(
          url: url, method: MethodType.post, headers: {Headers.contentTypeHeader: 'application/json', Headers.acceptHeader: 'application/json'});

      expect(result, null);

      verifyPostMethod();
    });
  });
}
