enum QuestionType { mcq, shortAnswer, trueFalse }

class Question {
  final String id;
  final String text;
  final QuestionType type;
  final String answer;
  final List<String> options; // فاضية إلا لو MCQ

  Question({
    required this.id,
    required this.text,
    required this.type,
    required this.answer,
    this.options = const [],
  });
}
