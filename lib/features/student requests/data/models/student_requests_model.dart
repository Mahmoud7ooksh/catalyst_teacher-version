// student_request_model.dart

class StudentRequestsResponse {
  final bool success;
  final String message;
  final List<StudentRequest> data;

  StudentRequestsResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory StudentRequestsResponse.fromJson(Map<String, dynamic> json) {
    return StudentRequestsResponse(
      success: json['success'] as bool,
      message: json['message'] as String,
      data: (json['data'] as List)
          .map((e) => StudentRequest.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
    'success': success,
    'message': message,
    'data': data.map((e) => e.toJson()).toList(),
  };
}

class StudentRequest {
  final int id;
  final int lessonId;
  final Student student;
  final String status;

  StudentRequest({
    required this.id,
    required this.lessonId,
    required this.student,
    required this.status,
  });

  factory StudentRequest.fromJson(Map<String, dynamic> json) {
    return StudentRequest(
      id: json['id'] as int,
      lessonId: json['lessonId'] as int,
      student: Student.fromJson(json['student'] as Map<String, dynamic>),
      status: json['status'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'lessonId': lessonId,
    'student': student.toJson(),
    'status': status,
  };
}

class Student {
  final int id;
  final String? fullName;
  final String email;

  Student({required this.id, this.fullName, required this.email});

  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      id: json['id'] as int,
      fullName: json['fullName'] as String?,
      email: json['email'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'fullName': fullName,
    'email': email,
  };
}
