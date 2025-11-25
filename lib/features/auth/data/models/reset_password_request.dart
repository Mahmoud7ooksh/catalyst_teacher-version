import 'package:catalyst/core/databases/api/constant.dart';

class ResetPasswordRequest {
  final String resetToken;
  final String newPassword;

  ResetPasswordRequest({required this.resetToken, required this.newPassword});

  Map<String, dynamic> toJson() => {
    BodyRequest.resetToken: resetToken,
    BodyRequest.newPassword: newPassword,
  };
}
