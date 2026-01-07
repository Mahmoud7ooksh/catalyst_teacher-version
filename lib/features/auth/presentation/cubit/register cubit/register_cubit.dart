import 'dart:io';

import 'package:catalyst/core/errors/exceptions.dart';
import 'package:catalyst/core/services/notification_service.dart';
import 'package:catalyst/features/auth/data/models/auth_request_model.dart';
import 'package:catalyst/features/auth/data/repos/auth_repo_implementation.dart';
import 'package:dartz/dartz.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'register_state.dart';

class RegisterCubit extends Cubit<RegisterCubitState> {
  RegisterCubit(this._authRepo) : super(RegisterCubitInitial());

  final AuthRepoImplementation _authRepo;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController userNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  Future<void> signUp() async {
    emit(RegisterCubitLoading());

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

    Either<Failure, void> result = await _authRepo.signUp(
      SignUpRequest(
        fullName: nameController.text,
        userName: userNameController.text,
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
      (failure) => emit(RegisterCubitError(failure.errMessage)),
      (_) => emit(RegisterCubitSuccess("Register successfully")),
    );
  }
}
