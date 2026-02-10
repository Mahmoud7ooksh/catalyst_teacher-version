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
  final int? studentsCount;
  final Teacher? teacher;
  final List<dynamic> lessonSchedules;

  Lesson({
    required this.id,
    required this.subject,
    this.studentsCount,
    this.teacher,
    required this.lessonSchedules,
  });

  factory Lesson.fromJson(Map<String, dynamic> json) {
    return Lesson(
      id: json['id'],
      subject: json['subject'],
      studentsCount: json['studentsCount'],
      teacher: json['teacher'] != null
          ? Teacher.fromJson(json['teacher'])
          : null,
      lessonSchedules: json['lessonSchedules'] ?? json['schedules'] ?? [],
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'subject': subject,
    'studentsCount': studentsCount,
    'teacher': teacher?.toJson(),
    'lessonSchedules': lessonSchedules,
  };
}

class Teacher {
  final int id;
  final String? fullName;

  Teacher({required this.id, this.fullName});

  factory Teacher.fromJson(Map<String, dynamic> json) {
    return Teacher(id: json['id'], fullName: json['fullName'] ?? json['name']);
  }

  Map<String, dynamic> toJson() => {'id': id, 'fullName': fullName};
}
