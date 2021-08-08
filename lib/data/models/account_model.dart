import '../../domain/entities/account_entity.dart';

class AccountModel extends AccountEntity {
  final String name;

  AccountModel({required String accessToken, required this.name}) : super(token: accessToken);

  factory AccountModel.fromMap({required Map<String, dynamic> map}) {
    return AccountModel(accessToken: map['accessToken'] as String, name: map['name'] as String);
  }


  Map<String, dynamic> toMap() {
    return {'accessToken': token, 'name': name};
  }
}
