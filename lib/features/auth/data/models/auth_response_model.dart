//response login and register are the same

//auth response model

class AuthResponseModel {
  final bool success;
  final String message;
  final Data data;

  AuthResponseModel({
    required this.success,
    required this.message,
    required this.data,
  });

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
  final String accessToken;
  final String refreshToken;
  final int id;
  final String email;
  final bool isConfirmed;

  Data({
    required this.accessToken,
    required this.refreshToken,
    required this.id,
    required this.email,
    required this.isConfirmed,
  });

  //data model to json
  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      accessToken: json['accessToken'],
      refreshToken: json['refreshToken'],
      id: json['id'],
      email: json['email'],
      isConfirmed: json['isConfirmed'],
    );
  }
}
