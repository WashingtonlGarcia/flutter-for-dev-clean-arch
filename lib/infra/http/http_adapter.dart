import 'package:dio/dio.dart';
import 'package:flutter_for_dev_clean_arch/data/http/http_error.dart';
import '../../data/http/http.dart';

class HttpAdapter implements HttpClient {
  final Dio client;

  HttpAdapter({required this.client});

  @override
  Future<Map<String, dynamic>?> call(
      {required String url, required MethodType method, Map<String, dynamic>? body, Map<String, dynamic>? headers}) async {
    Response response = Response(statusCode: 500, data: '', requestOptions: RequestOptions(path: ''));
    try {
      if (method == MethodType.post) {
        response = await client.post(url,
            data: body,
            options: Options(headers: headers ?? {Headers.contentTypeHeader: 'application/json', Headers.acceptHeader: 'application/json'}));
      }
    } catch (_) {
      throw HttpError.serverError;
    }
    return _handleResponse(response: response);
  }

  Map<String, dynamic>? _handleResponse({required Response response}) {
    if (response.statusCode == 200) {
      return response.data != null && response.data is Map<String, dynamic> ? response.data as Map<String, dynamic> : null;
    } else if (response.statusCode == 204) {
      return null;
    } else if (response.statusCode == 400) {
      throw HttpError.badRequest;
    } else if (response.statusCode == 401) {
      throw HttpError.unathorized;
    } else if (response.statusCode == 403) {
      throw HttpError.forbidden;
    } else if (response.statusCode == 404) {
      throw HttpError.notFound;
    }
    throw HttpError.serverError;
  }
}
