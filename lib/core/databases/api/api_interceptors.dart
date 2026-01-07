import 'package:catalyst/core/databases/api/constant.dart';
import 'package:catalyst/core/databases/cache/cache_helper.dart';
import 'package:catalyst/core/databases/cache/constant.dart';
import 'package:catalyst/core/utils/routs.dart';
import 'package:dio/dio.dart';

class ApiInterceptors extends Interceptor {
  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await CacheHelper.getData(key: Constant.tokenKey);
    if (token != null &&
        options.path != EndPoint.login &&
        options.path != EndPoint.signUp) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    super.onRequest(options, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) {
      final refreshToken = await CacheHelper.getData(
        key: Constant.refreshTokenKey,
      );
      if (refreshToken != null) {
        try {
          final dio = Dio();
          final response = await dio.post(
            EndPoint.baseUrl + EndPoint.refreshToken,
            data: {'refreshToken': refreshToken},
          );

          if (response.statusCode == 200) {
            final newAccessToken = response.data['accessToken'];
            final newRefreshToken = response.data['refreshToken'];

            await CacheHelper.saveData(
              key: Constant.tokenKey,
              value: newAccessToken,
            );
            if (newRefreshToken != null) {
              await CacheHelper.saveData(
                key: Constant.refreshTokenKey,
                value: newRefreshToken,
              );
            }

            final options = err.requestOptions;
            options.headers['Authorization'] = 'Bearer $newAccessToken';

            final cloneReq = await dio.request(
              options.path,
              options: Options(
                method: options.method,
                headers: options.headers,
              ),
              data: options.data,
              queryParameters: options.queryParameters,
            );
            return handler.resolve(cloneReq);
          }
        } catch (e) {
          await CacheHelper.removeData(key: Constant.tokenKey);
          await CacheHelper.removeData(key: Constant.refreshTokenKey);
          await CacheHelper.removeData(key: Constant.userKey);
          Routs.router.go(Routs.login);
        }
      } else {
        await CacheHelper.removeData(key: Constant.tokenKey);
        await CacheHelper.removeData(key: Constant.refreshTokenKey);
        await CacheHelper.removeData(key: Constant.userKey);
        Routs.router.go(Routs.login);
      }
    }
    super.onError(err, handler);
  }
}

/*
1) Multiple 401 triggers
401 may happen many times

2) Interceptor handles navigation
Interceptor should NOT navigate

3) Cache used as state
Cache is NOT state

4) No central auth state
Missing Auth Cubit
*/
// TODO: Backend should send proper error codes
// Temporary frontend handling until backend fix
