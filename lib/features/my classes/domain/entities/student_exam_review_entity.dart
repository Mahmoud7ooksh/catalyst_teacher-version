class StudentExamReviewEntity {
  final String? studentName;
  final double? totalGrade;
  final List<StudentAnswerReviewEntity> answers;
  final bool completed;

  StudentExamReviewEntity({
    this.studentName,
    this.totalGrade,
    required this.answers,
    required this.completed,
  });
}

class StudentAnswerReviewEntity {
  final int answerId;
  final int questionId;
  final String questionText;
  final String questionType;
  final List<String>? options;
  final int maxPoints;
  final List<int>? selectedOptions;
  final List<int>? correctOptions;
  final String? textAnswer;
  final String? correctAnswer;
  final double? aiMark;

  StudentAnswerReviewEntity({
    required this.answerId,
    required this.questionId,
    required this.questionText,
    required this.questionType,
    this.options,
    required this.maxPoints,
    this.selectedOptions,
    this.correctOptions,
    this.textAnswer,
    this.correctAnswer,
    this.aiMark,
  });
}
