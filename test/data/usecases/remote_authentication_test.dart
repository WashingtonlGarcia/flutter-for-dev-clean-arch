import 'package:faker/faker.dart';
import 'package:flutter_for_dev_clean_arch/domain/usecases/authentication.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

enum MethodType { put, get, post, delete }

class RemoteAuthentication {
  final HttpClient httpClient;
  final String url;

  RemoteAuthentication({required this.httpClient, required this.url});

  Future<void> call({required AuthenticationParams params}) async {
    await httpClient.request(url: url, method: MethodType.get, body: params.toMap());
  }
}

abstract class HttpClient {
  Future<void> request({required String url, required MethodType method, required Map<String, dynamic> body});
}

class HttpClientSpy extends Mock implements HttpClient {}

void main() {
  late HttpClient httpClient;
  late String url;
  late RemoteAuthentication sut;
  late AuthenticationParams params;
  setUp(() {
    httpClient = HttpClientSpy();
    url = faker.internet.httpUrl();
    params = AuthenticationParams(password: faker.randomGenerator.string(6), email: faker.internet.email());
    sut = RemoteAuthentication(httpClient: httpClient, url: url);
  });

  test('should call HttpClient with correct values', () async {
    when(() => httpClient.request(url: url, method: MethodType.get, body: params.toMap())).thenAnswer((invocation) async {});

    await sut(params: params);

    verify(() => httpClient.request(
          url: url,
          method: MethodType.get,
          body: params.toMap(),
        ));
  });
}
