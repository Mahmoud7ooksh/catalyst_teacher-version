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
  final List<String> options;

  @HiveField(5)
  final int points;

  Question({
    required this.id,
    required this.text,
    required this.type,
    required this.answer,
    this.options = const [],
    this.points = 1,
  });
}
