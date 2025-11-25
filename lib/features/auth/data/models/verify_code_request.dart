import 'package:catalyst/core/databases/api/constant.dart';

class VerifyCodeRequest {
  final String email;
  final String code;

  VerifyCodeRequest({required this.email, required this.code});

  Map<String, dynamic> toJson() => {
    BodyRequest.email: email,
    BodyRequest.code: code,
  };
}
