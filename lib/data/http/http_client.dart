enum MethodType { put, get, post, delete }

abstract class HttpClient {
  Future<Map<String, dynamic>> call({required String url, required MethodType method, Map<String, dynamic>? body});
}
