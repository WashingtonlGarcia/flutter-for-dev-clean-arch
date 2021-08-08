enum MethodType { put, get, post, delete }

abstract class HttpClient {
  Future<void> call({required String url, required MethodType method, required Map<String, dynamic> body});
}
