class CreateExamRequestModel {
  final String examName;
  final int maxGrade;
  final String examDateTime;
  final int durationMinutes;
  final int defaultPoints;
  final String examType;
  final String? closingDate;
  final List<QuestionRequestModel> questions;

  CreateExamRequestModel({
    required this.examName,
    required this.maxGrade,
    required this.examDateTime,
    required this.durationMinutes,
    required this.defaultPoints,
    required this.examType,
    this.closingDate,
    required this.questions,
  });

  Map<String, dynamic> toJson() {
    return {
      'examName': examName,
      'maxGrade': maxGrade,
      'examDateTime': examDateTime,
      'durationMinutes': durationMinutes,
      'defaultPoints': defaultPoints,
      'examType': examType,
      'closingDate': closingDate,
      'questions': questions.map((q) => q.toJson()).toList(),
    };
  }
}

class QuestionRequestModel {
  final String text;
  final String type;
  final List<String>? options;
  final int? correctOptionIndex;
  final int maxPoints;
  final String? correctAnswer;

  QuestionRequestModel({
    required this.text,
    required this.type,
    this.options,
    this.correctOptionIndex,
    required this.maxPoints,
    this.correctAnswer,
  });

  Map<String, dynamic> toJson() {
    return {
      'text': text,
      'type': type,
      'options': options,
      'correctOptionIndex': correctOptionIndex,
      'maxPoints': maxPoints,
      'correctAnswer': correctAnswer,
    };
  }
}
