import 'package:catalyst/core/databases/api/constant.dart';

//login request
class LoginRequest {
  final String email;
  final String password;

  // to json
  LoginRequest({required this.email, required this.password});

  Map<String, dynamic> toJson() => {
    BodyRequest.email: email,
    BodyRequest.password: password,
  };
}

//register request
class SignUpRequest {
  final String fullName;
  final String email;
  final String password;

  // to json
  SignUpRequest({
    required this.fullName,
    required this.email,
    required this.password,
  });

  Map<String, dynamic> toJson() => {
    BodyRequest.fullName: fullName,
    BodyRequest.email: email,
    BodyRequest.password: password,
  };
}
