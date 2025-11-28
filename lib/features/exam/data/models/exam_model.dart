import 'package:catalyst/features/exam/data/models/question_model.dart';

class CreateExamRequest {
  final String title;
  final String description;
  final int totalMarks;
  final int durationMinutes;
  final DateTime scheduledAt;
  final List<String> classIds;
  final List<Question> questions;

  CreateExamRequest({
    required this.title,
    required this.description,
    required this.totalMarks,
    required this.durationMinutes,
    required this.scheduledAt,
    required this.classIds,
    required this.questions,
  });

  Map<String, dynamic> toJson() {
    return {
      "title": title,
      "description": description,
      "totalMarks": totalMarks,
      "durationMinutes": durationMinutes,
      "scheduledAt": scheduledAt.toIso8601String(),
      "classIds": classIds,
      "questions": questions,
    };
  }
}
