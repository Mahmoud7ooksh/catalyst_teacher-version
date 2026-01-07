import 'package:catalyst/core/databases/api/api_service.dart';
import 'package:catalyst/core/databases/api/constant.dart';
import 'package:catalyst/core/databases/cache/cache_helper.dart';
import 'package:catalyst/core/databases/cache/constant.dart';
import 'package:catalyst/features/auth/data/models/auth_response_model.dart';
import 'package:catalyst/features/auth/data/models/update_password_model.dart';

abstract class RemoteDataSource {
  Future<void> login(Map<String, dynamic> loginData);
  Future<void> signUp(Map<String, dynamic> signUpData);
  Future<UpdatePasswordResponseModel> forgotPassword(
    Map<String, dynamic> forgotPasswordData,
  );
  Future<UpdatePasswordResponseModel> verifyCode(
    Map<String, dynamic> verifyData,
  );
  Future<UpdatePasswordResponseModel> resetPassword(
    Map<String, dynamic> resetPasswordData,
  );
}

class RemoteDataSourceImplementation implements RemoteDataSource {
  final ApiService apiService;
  RemoteDataSourceImplementation({required this.apiService});

  //==================== login ====================
  @override
  Future<void> login(Map<String, dynamic> loginData) async {
    final response = await apiService.post(
      path: EndPoint.login,
      data: loginData,
    );
    final userData = AuthResponseModel.fromJson(response);
    CacheHelper.saveData(
      key: Constant.tokenKey,
      value: userData.data.accessToken,
    );
    CacheHelper.saveData(
      key: Constant.refreshTokenKey,
      value: userData.data.refreshToken,
    );
    CacheHelper.saveData(key: Constant.userKey, value: userData.data.id);
  }

  //==================== signUp ====================
  @override
  Future<void> signUp(Map<String, dynamic> signUpData) async {
    final response = await apiService.post(
      path: EndPoint.signUp,
      data: signUpData,
    );
    final userData = AuthResponseModel.fromJson(response);
    CacheHelper.saveData(
      key: Constant.tokenKey,
      value: userData.data.accessToken,
    );
    CacheHelper.saveData(
      key: Constant.refreshTokenKey,
      value: userData.data.refreshToken,
    );
    CacheHelper.saveData(key: Constant.userKey, value: userData.data.id);
  }

  //==================== signOut ====================

  //==================== forgotPassword ====================
  @override
  Future<UpdatePasswordResponseModel> forgotPassword(
    Map<String, dynamic> forgotPasswordData,
  ) async {
    final response = await apiService.post(
      path: EndPoint.forgotPassword,
      data: forgotPasswordData,
    );
    return UpdatePasswordResponseModel.fromJson(response);
  }

  //==================== resetPassword ====================
  @override
  Future<UpdatePasswordResponseModel> resetPassword(
    Map<String, dynamic> resetPasswordData,
  ) async {
    final response = await apiService.post(
      path: EndPoint.resetPassword,
      data: resetPasswordData,
    );
    return UpdatePasswordResponseModel.fromJson(response);
  }

  //==================== verifyCode ====================
  @override
  Future<UpdatePasswordResponseModel> verifyCode(
    Map<String, dynamic> forgotPasswordData,
  ) async {
    final response = await apiService.post(
      path: EndPoint.verifyCode,
      data: forgotPasswordData,
    );
    return UpdatePasswordResponseModel.fromJson(response);
  }
}
