import 'package:catalyst/core/databases/api/constant.dart';
import 'package:catalyst/core/databases/cache/cache_helper.dart';
import 'package:dio/dio.dart';
import 'dart:async';

class ApiInterceptors extends Interceptor {
  bool _isRefreshing = false;
  final _failedRequestsQueue = <Map<String, dynamic>>[];

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await CacheHelper.getData(key: 'token');
    print('DEBUG: Request path: ${options.path}');
    print('DEBUG: Token in interceptor: $token');

    if (token != null && token is String && token.isNotEmpty) {
      // Don't send token for login, signup, and refresh token
      if (!options.path.contains(EndPoint.login) &&
          !options.path.contains(EndPoint.signUp) &&
          !options.path.contains(EndPoint.refreshToken)) {
        options.headers['Authorization'] = 'Bearer $token';
        print('DEBUG: Authorization header added');
      }
    } else {
      print('DEBUG: Token is null or empty');
    }

    return handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    print('DEBUG: ====================== ERROR ======================');
    print('DEBUG: Error path: ${err.requestOptions.path}');
    print('DEBUG: Status code: ${err.response?.statusCode}');
    if (err.response?.statusCode == 401 || err.response?.statusCode == 403) {
      final options = err.requestOptions;

      // If already refreshing, queue the request
      if (_isRefreshing) {
        final completer = Completer<Response>();
        _failedRequestsQueue.add({'completer': completer, 'options': options});
        try {
          final response = await completer.future;
          handler.resolve(response);
        } catch (e) {
          handler.reject(err); // If refresh fails, reject exactly as before
        }
        return;
      }

      _isRefreshing = true;

      try {
        final result = await _refreshToken();
        if (result) {
          // Retry the original request
          final response = await _retryRequest(options);

          // Process queue
          for (var request in _failedRequestsQueue) {
            final RequestOptions reqOptions = request['options'];
            final Completer completer = request['completer'];
            try {
              final response = await _retryRequest(reqOptions);
              completer.complete(response);
            } catch (e) {
              completer.completeError(e);
            }
          }
          _failedRequestsQueue.clear();
          _isRefreshing = false;

          handler.resolve(response);
        } else {
          _handleRefreshFailure(err, handler);
        }
      } catch (e) {
        _handleRefreshFailure(err, handler);
      }
    } else {
      handler.next(err);
    }
  }

  Future<bool> _refreshToken() async {
    final refreshToken = await CacheHelper.getData(key: 'refreshToken');
    print('DEBUG: _refreshToken process started');
    print('DEBUG: [RefreshToken] found in cache: $refreshToken');
    if (refreshToken == null) {
      print('DEBUG: No [RefreshToken] found. Cannot refresh.');
      return false;
    }

    try {
      final dio = Dio(BaseOptions(baseUrl: EndPoint.baseUrl));
      print('DEBUG: Sending refresh request to: ${EndPoint.refreshToken}');
      final response = await dio.post(
        EndPoint.refreshToken,
        data: {'refreshToken': refreshToken},
      );

      print('DEBUG: Refresh response status: ${response.statusCode}');
      print('DEBUG: Refresh response data: ${response.data}');

      if (response.statusCode == 200) {
        final data = response.data['data'];
        final newAccessToken = data['accessToken'];
        final newRefreshToken = data['refreshToken'];

        if (newAccessToken != null && newRefreshToken != null) {
          print('DEBUG: Refresh SUCCESS! Saving new tokens.');
          print('DEBUG: New [AccessToken]: $newAccessToken');
          print('DEBUG: New [RefreshToken]: $newRefreshToken');
          await CacheHelper.saveData(key: 'token', value: newAccessToken);
          await CacheHelper.saveData(
            key: 'refreshToken',
            value: newRefreshToken,
          );
          return true;
        } else {
          print('DEBUG: FAILED to refresh - Tokens are null in response data.');
        }
      }
      return false;
    } on DioException catch (e) {
      print('DEBUG: DioException during refresh: ${e.message}');
      print('DEBUG: Refresh error response: ${e.response?.data}');
      return false;
    } catch (e) {
      print('DEBUG: Unexpected error during refresh: $e');
      return false;
    }
  }

  Future<Response> _retryRequest(RequestOptions requestOptions) async {
    final dio = Dio(BaseOptions(baseUrl: EndPoint.baseUrl));
    final token = await CacheHelper.getData(key: 'token');
    print('DEBUG: RETRYING request: ${requestOptions.path}');
    print('DEBUG: Using NEW [AccessToken]: $token');

    final options = Options(
      method: requestOptions.method,
      headers: {...requestOptions.headers, 'Authorization': 'Bearer $token'},
      contentType: requestOptions.contentType,
      responseType: requestOptions.responseType,
      followRedirects: requestOptions.followRedirects,
      validateStatus: requestOptions.validateStatus,
      receiveTimeout: requestOptions.receiveTimeout,
      sendTimeout: requestOptions.sendTimeout,
      extra: requestOptions.extra,
    );

    try {
      final response = await dio.request(
        requestOptions.path,
        data: requestOptions.data,
        queryParameters: requestOptions.queryParameters,
        options: options,
        cancelToken: requestOptions.cancelToken,
        onReceiveProgress: requestOptions.onReceiveProgress,
        onSendProgress: requestOptions.onSendProgress,
      );
      print('DEBUG: Retry successful for: ${requestOptions.path}');
      return response;
    } catch (e) {
      print('DEBUG: Retry failed for: ${requestOptions.path}. Error: $e');
      rethrow;
    }
  }

  void _handleRefreshFailure(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    _isRefreshing = false;
    _failedRequestsQueue.clear();
    await CacheHelper.clearAllData();
    // Ideally trigger navigation to login here or rely on the UI watching the token state
    handler.next(err);
  }
}
