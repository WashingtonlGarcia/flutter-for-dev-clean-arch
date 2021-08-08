import '../../domain/entities/account_entity.dart';

class RemoteAccountModel extends AccountEntity {
  final String name;

  RemoteAccountModel({required String accessToken, required this.name}) : super(token: accessToken);

  factory RemoteAccountModel.fromMap({required Map<String, dynamic> map}) {
    return RemoteAccountModel(accessToken: map['accessToken'] as String, name: map['name'] as String);
  }


  Map<String, dynamic> toMap() {
    return {'accessToken': token, 'name': name};
  }
}
