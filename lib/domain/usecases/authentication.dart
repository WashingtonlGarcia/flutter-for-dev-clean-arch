import '../entities/account_entity.dart';

abstract class Authentication {
  Future<AccountEntity> call({required AuthenticationParams params});
}

class AuthenticationParams {
  final String email;
  final String password;

  const AuthenticationParams({required this.email, required this.password});

  Map<String, dynamic> toMap() {
    return {'email': email, 'password': password};
  }
}
