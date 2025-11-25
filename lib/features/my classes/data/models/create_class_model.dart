class CreateClassResponse {
  final int id;
  final String subject;
  final Teacher teacher;

  CreateClassResponse({
    required this.id,
    required this.subject,
    required this.teacher,
  });

  factory CreateClassResponse.fromJson(Map<String, dynamic> json) {
    return CreateClassResponse(
      id: json['id'] ?? 0,
      subject: json['subject'] ?? '',
      teacher: Teacher.fromJson(json['teacher'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'subject': subject, 'teacher': teacher.toJson()};
  }
}

class Teacher {
  final int id;
  final String fullName;
  final String email;
  final String? password;
  final String? resetPasswordToken;
  final String? resetPasswordTokenExpiry;
  final String? createdAt;
  final String? updatedAt;
  final String? role;

  Teacher({
    required this.id,
    required this.fullName,
    required this.email,
    this.password,
    this.resetPasswordToken,
    this.resetPasswordTokenExpiry,
    this.createdAt,
    this.updatedAt,
    this.role,
  });

  factory Teacher.fromJson(Map<String, dynamic> json) {
    return Teacher(
      id: json['id'] ?? 0,
      fullName: json['fullName'] ?? '',
      email: json['email'] ?? '',
      password: json['password'],
      resetPasswordToken: json['resetPasswordToken'],
      resetPasswordTokenExpiry: json['resetPasswordTokenExpiry'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      role: json['role'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fullName': fullName,
      'email': email,
      'password': password,
      'resetPasswordToken': resetPasswordToken,
      'resetPasswordTokenExpiry': resetPasswordTokenExpiry,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'role': role,
    };
  }
}

class CreateClassRequest {
  final String subject;

  CreateClassRequest({required this.subject});

  Map<String, dynamic> toJson() => {'subject': subject};
}
