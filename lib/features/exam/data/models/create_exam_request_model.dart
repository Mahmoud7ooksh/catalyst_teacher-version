class CreateExamRequestModel {
  final String examName;
  final int maxGrade;
  final String examDateTime;
  final int durationMinutes;
  final int defaultPoints;
  final String examType;
  final List<QuestionRequestModel> questions;

  CreateExamRequestModel({
    required this.examName,
    required this.maxGrade,
    required this.examDateTime,
    required this.durationMinutes,
    required this.defaultPoints,
    required this.examType,
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
      'questions': questions.map((q) => q.toJson()).toList(),
    };
  }
}

class QuestionRequestModel {
  final String text;
  final String type;
  final List<String> options;
  final int correctOptionIndex;
  final int maxPoints;

  QuestionRequestModel({
    required this.text,
    required this.type,
    required this.options,
    required this.correctOptionIndex,
    required this.maxPoints,
  });

  Map<String, dynamic> toJson() {
    return {
      'text': text,
      'type': type,
      'options': options,
      'correctOptionIndex': correctOptionIndex,
      'maxPoints': maxPoints,
    };
  }
}
