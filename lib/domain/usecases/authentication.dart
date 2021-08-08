import '../entities/account_entity.dart';

abstract class Authentication<Params extends AuthenticationParams> {
  Future<AccountEntity> call({required Params params});
}

abstract class AuthenticationParams {
  final String email;
  final String password;

  const AuthenticationParams({required this.email, required this.password});

  Map<String, dynamic> toMap();
}
