// ===== api service you can use it to make requests with any package=====
abstract class ApiService {
  // ===== get request =====
  Future<dynamic> get({
    required String path,
    dynamic data,
    Map<String, dynamic>? queryParameters,
  });

  // ===== post request =====
  Future<dynamic> post({
    required String path,
    dynamic data,
    Map<String, dynamic>? queryParameters,
  });

  // ===== patch request =====
  Future<dynamic> patch({
    required String path,
    dynamic data,
    Map<String, dynamic>? queryParameters,
  });

  // ===== delete request =====
  Future<dynamic> delete({
    required String path,
    dynamic data,
    Map<String, dynamic>? queryParameters,
  });
}
