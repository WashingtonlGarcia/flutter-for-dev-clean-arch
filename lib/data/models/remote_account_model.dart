import '../../domain/entities/account_entity.dart';
import '../http/http.dart' show HttpError;

class RemoteAccountModel extends AccountEntity {
  RemoteAccountModel({required String accessToken}) : super(token: accessToken);

  factory RemoteAccountModel.fromMap({required Map<String, dynamic> map}) {
    if (!map.containsKey('accessToken')) throw HttpError.invalidData;
    return RemoteAccountModel(accessToken: map['accessToken'] as String);
  }

  Map<String, dynamic> toMap() {
    return {'accessToken': token};
  }
}
