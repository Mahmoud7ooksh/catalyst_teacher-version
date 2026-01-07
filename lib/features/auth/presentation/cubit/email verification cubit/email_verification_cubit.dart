import 'package:catalyst/features/auth/domain/repos/auth_repo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'email_verification_state.dart';

class EmailVerificationCubit extends Cubit<EmailVerificationState> {
  final AuthRepo authRepo;
  EmailVerificationCubit(this.authRepo) : super(EmailVerificationInitial());

  Future<void> resendVerificationEmail(String email) async {
    emit(EmailVerificationLoading());
    final result = await authRepo.resendVerificationEmail({'email': email});
    result.fold(
      (failure) => emit(EmailVerificationFailure(failure.errMessage)),
      (data) => emit(EmailVerificationSuccess(data.message)),
    );
  }
}
