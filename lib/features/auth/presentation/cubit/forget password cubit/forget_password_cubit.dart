import 'package:catalyst/features/auth/data/models/forget_password_request.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';

import 'forget_password_state.dart';
import 'package:catalyst/features/auth/domain/repos/auth_repo.dart';

class ForgetPasswordCubit extends Cubit<ForgetPasswordState> {
  final AuthRepo authRepo;
  ForgetPasswordCubit(this.authRepo) : super(ForgetPasswordInitial());

  TextEditingController emailController = TextEditingController();

  // =================== forgotPasswordPage (enter email) ===================
  Future<void> forgotPassword() async {
    emit(ForgetPasswordLoading());
    final result = await authRepo.forgotPassword(
      ForgotPasswordRequest(email: emailController.text).toJson(),
    );
    result.fold(
      (failure) => emit(ForgetPasswordFailure(failure.errMessage)),
      (data) => emit(ForgetPasswordSuccess(data.message)),
    );
  }

  @override
  Future<void> close() {
    emailController.dispose();
    return super.close();
  }
}
