import 'package:hive/hive.dart';

part 'question_model.g.dart';

@HiveType(typeId: 1)
enum QuestionType {
  @HiveField(0)
  mcq,

  @HiveField(1)
  shortAnswer,

  @HiveField(2)
  trueFalse,
}

@HiveType(typeId: 2)
class Question {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String text;

  @HiveField(2)
  final QuestionType type;

  @HiveField(3)
  final String answer;

  @HiveField(4)
  final List<String>? options;

  @HiveField(5)
  final int? points;

  Question({
    required this.id,
    required this.text,
    required this.type,
    required this.answer,
    this.options = const [],
    this.points = 1,
  });

  factory Question.fromAIJson(Map<String, dynamic> json, {int index = 0}) {
    final options = (json['options'] as List<dynamic>?)
        ?.map((o) => o.toString())
        .toList();

    // correctOptions is List<int> from the API — join as "0,1" style
    final correctOptions = (json['correctOptions'] as List<dynamic>?)
        ?.map((e) => e as int)
        .toList();

    final String answerValue;
    if (correctOptions != null && correctOptions.isNotEmpty) {
      answerValue = correctOptions.join(',');
    } else {
      answerValue = json['textAnswer']?.toString() ?? '';
    }

    final typeStr = json['questionType']?.toString().toUpperCase() ?? '';
    final QuestionType questionType;
    if (typeStr == 'MCQ') {
      questionType = QuestionType.mcq;
    } else if (typeStr == 'TRUE_FALSE' || typeStr == 'TRUE_FALSE') {
      questionType = QuestionType.trueFalse;
    } else {
      questionType = QuestionType.shortAnswer;
    }

    return Question(
      id: '${DateTime.now().microsecondsSinceEpoch}_$index',
      text: json['question']?.toString() ?? '',
      type: questionType,
      answer: answerValue,
      options: options ?? [],
      points: json['maxPoints'] as int? ?? 1,
    );
  }
}
