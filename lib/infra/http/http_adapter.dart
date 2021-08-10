import 'package:dio/dio.dart';
import '../../data/http/http.dart';

class HttpAdapter implements HttpClient {
  final Dio client;

  HttpAdapter({required this.client});

  @override
  Future<Map<String, dynamic>?> call(
      {required String url, required MethodType method, Map<String, dynamic>? body, Map<String, dynamic>? headers}) async {
    final response = await client.post(url,
        data: body, options: Options(headers: headers ?? {Headers.contentTypeHeader: 'application/json', Headers.acceptHeader: 'application/json'}));
    return _handleResponse(response: response);
  }

  Map<String, dynamic>? _handleResponse({required Response response}) {
    if (response.statusCode == 200) {
      return response.data != null && response.data is Map<String, dynamic> ? response.data as Map<String, dynamic> : null;
    } else if (response.statusCode == 204) {
      return null;
    }
    throw HttpError.badRequest;
  }
}
