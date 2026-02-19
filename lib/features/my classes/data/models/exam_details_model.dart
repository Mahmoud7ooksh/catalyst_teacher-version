class ExamDetailsResponseModel {
  final bool success;
  final String message;
  final ExamDetailsDataModel data;

  ExamDetailsResponseModel({
    required this.success,
    required this.message,
    required this.data,
  });

  factory ExamDetailsResponseModel.fromJson(Map<String, dynamic> json) {
    return ExamDetailsResponseModel(
      success: json['success'],
      message: json['message'],
      data: ExamDetailsDataModel.fromJson(json['data']),
    );
  }
}

class ExamDetailsDataModel {
  final int id;
  final int lessonId;
  final String examName;
  final int maxGrade;
  final String? examDateTime;
  final String? closingDate;
  final int durationMinutes;
  final String examType;
  final List<QuestionModel> questions;
  final List<StudentGradeModel> studentGrads;

  ExamDetailsDataModel({
    required this.id,
    required this.lessonId,
    required this.examName,
    required this.maxGrade,
    this.examDateTime,
    this.closingDate,
    required this.durationMinutes,
    required this.examType,
    required this.questions,
    required this.studentGrads,
  });

  factory ExamDetailsDataModel.fromJson(Map<String, dynamic> json) {
    return ExamDetailsDataModel(
      id: json['id'],
      lessonId: json['lessonId'],
      examName: json['examName'],
      maxGrade: json['maxGrade'],
      examDateTime: json['examDateTime'],
      closingDate: json['closingDate'],
      durationMinutes: json['durationMinutes'],
      examType: json['examType'],
      questions: (json['questions'] as List)
          .map((i) => QuestionModel.fromJson(i))
          .toList(),
      studentGrads: (json['studentGrads'] as List)
          .map((i) => StudentGradeModel.fromJson(i))
          .toList(),
    );
  }
}

class QuestionModel {
  final int id;
  // Other fields not specified but present in JSON list
  QuestionModel({required this.id});
  factory QuestionModel.fromJson(Map<String, dynamic> json) =>
      QuestionModel(id: json['id']);
}

class StudentGradeModel {
  final int id;
  final String? studentName;
  final double? grade;
  final bool verified;

  StudentGradeModel({
    required this.id,
    this.studentName,
    this.grade,
    required this.verified,
  });

  factory StudentGradeModel.fromJson(Map<String, dynamic> json) {
    return StudentGradeModel(
      id: json['id'],
      studentName: json['studentName'],
      grade: json['grade'] != null ? (json['grade'] as num).toDouble() : null,
      verified: json['verified'] ?? false,
    );
  }
}
