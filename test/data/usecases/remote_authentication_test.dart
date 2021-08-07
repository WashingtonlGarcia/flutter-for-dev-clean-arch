import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class RemoteAuthentication {
  final HttpClient httpClient;
  final String url;

  RemoteAuthentication({required this.httpClient, required this.url});

  Future<void> call() async {
    await httpClient.request(url: url);
  }
}

abstract class HttpClient {
  Future<void> request({required String url});
}

class HttpClientSpy extends Mock implements HttpClient {}

void main() {
  test('should call HttpClient with correct url', () async {
    final httpClient = HttpClientSpy();
    final url = faker.internet.httpUrl();
    when(() => httpClient.request(url: url)).thenAnswer((invocation) async {});

    final sut = RemoteAuthentication(httpClient: httpClient, url: url);
    await sut();
    verify(() => httpClient.request(url: url));
  });
}
