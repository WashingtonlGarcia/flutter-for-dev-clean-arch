import 'package:faker/faker.dart';
import 'package:flutter_for_dev_clean_arch/data/http/http.dart';
import 'package:flutter_for_dev_clean_arch/data/models/remote_account_model.dart';
import 'package:flutter_for_dev_clean_arch/data/usecases/remote_authentication.dart';
import 'package:flutter_for_dev_clean_arch/domain/helpers/domain_error.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class HttpClientSpy extends Mock implements HttpClient {}

void main() {
  late HttpClient httpClient;
  late RemoteAuthentication sut;
  late RemoteAuthenticationParams params;
  late Map<String, dynamic> validData;
  late Map<String, dynamic> invalidData;

  When mockRequest() => when(() => httpClient(url: any(named: 'url'), method: MethodType.get, body: any(named: 'body')));
  void mockHttpSuccess({required Map<String, dynamic> data}) => mockRequest().thenAnswer((invocation) async => data);
  void mockHttpFailure({required HttpError error}) => mockRequest().thenThrow(error);
  void verifyHttpClientMethodGet() => verify(() => httpClient(url: any(named: 'url'), method: MethodType.get, body: params.toMap()));

  setUp(() {
    httpClient = HttpClientSpy();
    final url = faker.internet.httpUrl();
    params = RemoteAuthenticationParams(password: faker.randomGenerator.string(6), email: faker.internet.email());
    sut = RemoteAuthentication(httpClient: httpClient, url: url);
    validData = {'accessToken': faker.guid.guid(), 'name': faker.person.name()};
    invalidData = {'invalid': 'invalid_value'};
    mockHttpSuccess(data: validData);
  });

  test('should call HttpClient with correct values', () async {
    await sut(params: params);

    verifyHttpClientMethodGet();
  });

  test('should throw UnexpectedError if HttpClient returns 400', () {
    mockHttpFailure(error: HttpError.badRequest);

    final result = sut(params: params);

    expect(result, throwsA(DomainError.unexpectedError));

    verifyHttpClientMethodGet();
  });

  test('should throw UnexpectedError if HttpClient returns 404', () {
    mockHttpFailure(error: HttpError.notFound);

    final result = sut(params: params);

    expect(result, throwsA(DomainError.unexpectedError));

    verifyHttpClientMethodGet();
  });

  test('should throw InvalidCredentialError if HttpClient returns 401', () {
    mockHttpFailure(error: HttpError.unathorized);

    final result = sut(params: params);

    expect(result, throwsA(DomainError.invalidCredentials));

    verifyHttpClientMethodGet();
  });

  test('should return an Account if HttpClient returns 200', () async {
    final result = await sut(params: params);

    expect(result.token, RemoteAccountModel.fromMap(map: validData).token);

    verifyHttpClientMethodGet();
  });

  test('should return an Account if HttpClient returns 200 with invalid data', () async {
    mockHttpSuccess(data: invalidData);

    final result = sut(params: params);

    expect(result, throwsA(DomainError.unexpectedError));

    verifyHttpClientMethodGet();
  });
}
