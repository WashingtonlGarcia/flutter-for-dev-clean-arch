import '../../domain/helpers/helpers.dart';
import '../../domain/usecases/usecases.dart' show Authentication, AuthenticationParams;
import '../http/http.dart';
import '../models/models.dart' show RemoteAccountModel;

class RemoteAuthentication implements Authentication<RemoteAuthenticationParams> {
  final HttpClient httpClient;
  final String url;

  RemoteAuthentication({required this.httpClient, required this.url});

  @override
  Future<RemoteAccountModel> call({required RemoteAuthenticationParams params}) async {
    try {
      final response = await httpClient(url: url, method: MethodType.get, body: params.toMap());
      return RemoteAccountModel.fromMap(map: response);
    } on HttpError catch (error) {
      throw error == HttpError.unathorized ? DomainError.invalidCredentials : DomainError.unexpectedError;
    }
  }
}

class RemoteAuthenticationParams extends AuthenticationParams {
  RemoteAuthenticationParams({required String email, required String password}) : super(email: email, password: password);

  @override
  Map<String, dynamic> toMap() {
    return {'email': email, 'password': password};
  }
}
