import '../../domain/entities/entities.dart' show AccountEntity;
import '../../domain/usecases/usecases.dart' show Authentication, AuthenticationParams;

import '../http/http_client.dart';

class RemoteAuthentication implements Authentication<RemoteAuthenticationParams> {
  final HttpClient httpClient;
  final String url;

  RemoteAuthentication({required this.httpClient, required this.url});

  @override
  Future<AccountEntity> call({required RemoteAuthenticationParams params}) async {
    await httpClient(url: url, method: MethodType.get, body: params.toMap());
    return AccountEntity(token: '');
  }
}

class RemoteAuthenticationParams extends AuthenticationParams {
  RemoteAuthenticationParams({required String email, required String password}) : super(email: email, password: password);

  @override
  Map<String, dynamic> toMap() {
    return {'email': email, 'password': password};
  }
}
