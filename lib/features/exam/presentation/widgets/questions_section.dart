import 'package:flutter/material.dart';
import 'package:catalyst/features/exam/data/models/question_model.dart';
import 'package:catalyst/features/exam/presentation/widgets/questions_list.dart';

class QuestionsSection extends StatelessWidget {
  const QuestionsSection({
    super.key,
    required this.questions,
    required this.onEdit,
    required this.onDelete,
  });

  final List<Question> questions;
  final ValueChanged<int> onEdit;
  final ValueChanged<int> onDelete;

  @override
  Widget build(BuildContext context) {
    if (questions.isEmpty) {
      return const Padding(
        padding: EdgeInsets.only(top: 12),
        child: Text(
          'No questions added yet.',
          style: TextStyle(fontSize: 14),
        ),
      );
    }

    return QuestionsList(
      questions: questions,
      onEdit: onEdit,
      onDelete: onDelete,
    );
  }
}
