import 'package:catalyst/core/databases/api/constant.dart';

class DeviceData {
  final String fcmToken;
  final String deviceId;
  final String deviceType;

  DeviceData({
    required this.fcmToken,
    required this.deviceId,
    required this.deviceType,
  });

  Map<String, dynamic> toJson() => {
    "fcmToken": fcmToken,
    "deviceId": deviceId,
    "deviceType": deviceType,
  };
}

//login request
class LoginRequest {
  final String email;
  final String password;
  final DeviceData deviceData;

  // to json
  LoginRequest({
    required this.email,
    required this.password,
    required this.deviceData,
  });

  Map<String, dynamic> toJson() => {
    BodyRequest.email: email,
    BodyRequest.password: password,
    "deviceData": deviceData.toJson(),
  };
}

//register request
class SignUpRequest {
  final String fullName;
  final String email;
  final String password;
  final DeviceData deviceData;

  // to json
  SignUpRequest({
    required this.fullName,
    required this.email,
    required this.password,
    required this.deviceData,
  });

  Map<String, dynamic> toJson() => {
    BodyRequest.fullName: fullName,
    BodyRequest.email: email,
    BodyRequest.password: password,
    "deviceData": deviceData.toJson(),
  };
}
