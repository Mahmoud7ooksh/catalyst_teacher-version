enum ExamStatus { pending, reviewed }

class ExamPreview {
  final String id;
  final String title;
  final DateTime date;
  final int studentCount;
  final ExamStatus status;

  ExamPreview({
    required this.id,
    required this.title,
    required this.date,
    required this.studentCount,
    required this.status,
  });
}

enum SubmissionStatus { confirmed, notReviewed }

class StudentSubmissionPreview {
  final String id;
  final String studentName;
  final double aiGrade;
  final double maxGrade;
  final SubmissionStatus status;
  final DateTime submissionDate;

  StudentSubmissionPreview({
    required this.id,
    required this.studentName,
    required this.aiGrade,
    required this.maxGrade,
    required this.status,
    required this.submissionDate,
  });
}

class QuestionReview {
  final String id;
  final String questionText;
  final String studentAnswer;
  final double aiScore;
  final double maxScore;
  final double? similarity; // for essay
  final String type; // MCQ, WRITING

  QuestionReview({
    required this.id,
    required this.questionText,
    required this.studentAnswer,
    required this.aiScore,
    required this.maxScore,
    this.similarity,
    required this.type,
  });
}
