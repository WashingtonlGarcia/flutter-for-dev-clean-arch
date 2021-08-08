import 'package:faker/faker.dart';
import 'package:flutter_for_dev_clean_arch/data/http/http.dart';
import 'package:flutter_for_dev_clean_arch/data/usecases/remote_authentication.dart';
import 'package:flutter_for_dev_clean_arch/domain/helpers/domain_error.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class HttpClientSpy extends Mock implements HttpClient {}

void main() {
  late HttpClient httpClient;
  late RemoteAuthentication sut;
  late RemoteAuthenticationParams params;

  setUp(() {
    httpClient = HttpClientSpy();
    final url = faker.internet.httpUrl();
    params = RemoteAuthenticationParams(password: faker.randomGenerator.string(6), email: faker.internet.email());
    sut = RemoteAuthentication(httpClient: httpClient, url: url);
  });

  test('should call HttpClient with correct values', () async {
    when(() => httpClient(url: any(named: 'url'), method: MethodType.get, body: params.toMap())).thenAnswer((invocation) async {});

    await sut(params: params);

    verify(() => httpClient(url: any(named: 'url'), method: MethodType.get, body: params.toMap()));
  });

  test('should throw UnexpectedError if HttpClient returns 400', () {
    when(() => httpClient(url: any(named: 'url'), method: MethodType.get, body: params.toMap())).thenThrow(HttpError.badRequest);

    final result = sut(params: params);

    expect(result, throwsA(DomainError.unexpectedError));

    verify(() => httpClient(url: any(named: 'url'), method: MethodType.get, body: params.toMap()));
  });

  test('should throw UnexpectedError if HttpClient returns 404', () {
    when(() => httpClient(url: any(named: 'url'), method: MethodType.get, body: params.toMap())).thenThrow(HttpError.notFound);

    final result = sut(params: params);

    expect(result, throwsA(DomainError.unexpectedError));

    verify(() => httpClient(url: any(named: 'url'), method: MethodType.get, body: params.toMap()));
  });
}
