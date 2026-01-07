import 'dart:io';

import 'package:catalyst/core/services/notification_service.dart';
import 'package:catalyst/features/auth/data/models/auth_request_model.dart';
import 'package:catalyst/features/auth/data/repos/auth_repo_implementation.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:dartz/dartz.dart';
import 'package:catalyst/core/errors/exceptions.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginCubitState> {
  LoginCubit(this._authRepo) : super(LoginCubitInitial());
  final AuthRepoImplementation _authRepo;

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  Future<void> login() async {
    emit(LoginCubitLoading());

    // Get FCM Token
    String? fcmToken = await NotificationService.init();

    // Get Device Info
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    String? deviceId;
    String? deviceType;

    if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      deviceId = androidInfo.id;
      deviceType = androidInfo.model;
    } else if (Platform.isIOS) {
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      deviceId = iosInfo.identifierForVendor;
      deviceType = iosInfo.model;
    }

    Either<Failure, void> result = await _authRepo.login(
      LoginRequest(
        email: emailController.text,
        password: passwordController.text,
        deviceData: DeviceData(
          fcmToken: fcmToken ?? "",
          deviceId: deviceId ?? "",
          deviceType: deviceType ?? "",
        ),
      ).toJson(),
    );

    result.fold(
      (failure) {
        if (!isClosed) emit(LoginCubitError(failure.errMessage));
      },
      (_) {
        if (!isClosed) emit(LoginCubitSuccess("Login successfully"));
      },
    );
  }
}
