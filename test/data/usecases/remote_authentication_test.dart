import 'package:faker/faker.dart';
import 'package:flutter_for_dev_clean_arch/data/http/http.dart';
import 'package:flutter_for_dev_clean_arch/data/usecases/remote_authentication.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';


class HttpClientSpy extends Mock implements HttpClient {}

void main() {
  late HttpClient httpClient;
  late String url;
  late RemoteAuthentication sut;
  late RemoteAuthenticationParams params;
  setUp(() {
    httpClient = HttpClientSpy();
    url = faker.internet.httpUrl();
    params = RemoteAuthenticationParams(password: faker.randomGenerator.string(6), email: faker.internet.email());
    sut = RemoteAuthentication(httpClient: httpClient, url: url);
  });

  test('should call HttpClient with correct values', () async {
    when(() => httpClient(url: url, method: MethodType.get, body: params.toMap())).thenAnswer((invocation) async {});

    await sut(params: params);

    verify(() => httpClient(url: url, method: MethodType.get, body: params.toMap()));
  });
}
