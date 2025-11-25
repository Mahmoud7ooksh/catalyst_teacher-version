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
  final int studentId;
  final String studentName;
  final String studentEmail;
  final int lessonId;
  final String lessonSubject;
  final String status;
  final String message;
  final DateTime createdAt;
  final DateTime? respondedAt;

  StudentRequest({
    required this.id,
    required this.studentId,
    required this.studentName,
    required this.studentEmail,
    required this.lessonId,
    required this.lessonSubject,
    required this.status,
    required this.message,
    required this.createdAt,
    this.respondedAt,
  });

  factory StudentRequest.fromJson(Map<String, dynamic> json) {
    return StudentRequest(
      id: json['id'] as int,
      studentId: json['studentId'] as int,
      studentName: json['studentName'] as String,
      studentEmail: json['studentEmail'] as String,
      lessonId: json['lessonId'] as int,
      lessonSubject: json['lessonSubject'] as String,
      status: json['status'] as String,
      message: json['message'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      respondedAt: json['respondedAt'] != null
          ? DateTime.parse(json['respondedAt'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'studentId': studentId,
    'studentName': studentName,
    'studentEmail': studentEmail,
    'lessonId': lessonId,
    'lessonSubject': lessonSubject,
    'status': status,
    'message': message,
    'createdAt': createdAt.toIso8601String(),
    'respondedAt': respondedAt?.toIso8601String(),
  };
}
