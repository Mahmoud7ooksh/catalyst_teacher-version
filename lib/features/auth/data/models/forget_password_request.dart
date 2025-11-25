import 'package:catalyst/core/databases/api/constant.dart';

class ForgotPasswordRequest {
  final String email;

  ForgotPasswordRequest({required this.email});

  Map<String, dynamic> toJson() => {BodyRequest.email: email};
}
