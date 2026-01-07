part of 'email_verification_cubit.dart';

@immutable
sealed class EmailVerificationState {}

final class EmailVerificationInitial extends EmailVerificationState {}

final class EmailVerificationLoading extends EmailVerificationState {}

final class EmailVerificationSuccess extends EmailVerificationState {
  final String message;
  EmailVerificationSuccess(this.message);
}

final class EmailVerificationFailure extends EmailVerificationState {
  final String errMessage;
  EmailVerificationFailure(this.errMessage);
}
