class GetMyClassesResponse {
  final bool success;
  final String message;
  final List<Lesson> data;

  GetMyClassesResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory GetMyClassesResponse.fromJson(Map<String, dynamic> json) {
    return GetMyClassesResponse(
      success: json['success'],
      message: json['message'],
      data: (json['data'] as List)
          .map((lesson) => Lesson.fromJson(lesson))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
    'success': success,
    'message': message,
    'data': data.map((lesson) => lesson.toJson()).toList(),
  };
}

class Lesson {
  final int id;
  final String subject;
  final int studentsCount;
  final Teacher teacher;
  final List<dynamic> schedules;

  Lesson({
    required this.id,
    required this.subject,
    required this.studentsCount,
    required this.teacher,
    required this.schedules,
  });

  factory Lesson.fromJson(Map<String, dynamic> json) {
    return Lesson(
      id: json['id'],
      subject: json['subject'],
      studentsCount: json['studentsCount'],
      teacher: Teacher.fromJson(json['teacher']),
      schedules: json['schedules'] ?? [],
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'subject': subject,
    'studentsCount': studentsCount,
    'teacher': teacher.toJson(),
    'schedules': schedules,
  };
}

class Teacher {
  final int id;
  final String fullName;

  Teacher({required this.id, required this.fullName});

  factory Teacher.fromJson(Map<String, dynamic> json) {
    return Teacher(id: json['id'], fullName: json['fullName']);
  }

  Map<String, dynamic> toJson() => {'id': id, 'fullName': fullName};
}
