//response login and register are the same

//auth response model
import 'package:catalyst/features/auth/domain/entities/user_entity.dart';

class AuthResponseModel extends UserEntity {
  final bool success;
  final String message;
  final Data data;

  AuthResponseModel({
    required this.success,
    required this.message,
    required this.data,
  }) : super(name: data.fullName, email: data.email, role: data.type);

  //auth response model to json
  factory AuthResponseModel.fromJson(Map<String, dynamic> json) {
    return AuthResponseModel(
      success: json['success'],
      message: json['message'],
      data: Data.fromJson(json['data']),
    );
  }
}

//data model
class Data {
  final String token;
  final int id;
  final String fullName;
  final String email;
  final String type;

  Data({
    required this.token,
    required this.id,
    required this.fullName,
    required this.email,
    required this.type,
  });

  //data model to json
  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      token: json['token'],
      id: json['id'],
      fullName: json['fullName'],
      email: json['email'],
      type: json['type'],
    );
  }
}
