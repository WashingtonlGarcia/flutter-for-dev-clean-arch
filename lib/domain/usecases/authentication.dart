import '../entities/account_entity.dart';

abstract class Authentication {
  Future<AccountEntity> call({required String email, required String password});
}
