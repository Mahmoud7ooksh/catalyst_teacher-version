import 'package:flutter/material.dart';
import 'package:catalyst/features/exam/data/models/question_model.dart';
import 'question_card.dart';

class QuestionsList extends StatelessWidget {
  const QuestionsList({
    super.key,
    required this.questions,
    required this.onEdit,
    required this.onDelete,
  });

  final List<Question> questions;
  final void Function(int index) onEdit;
  final void Function(int index) onDelete;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: questions.asMap().entries.map((entry) {
        final index = entry.key;
        final question = entry.value;

        return Padding(
          padding: const EdgeInsets.only(bottom: 10.0),
          child: QuestionCard(
            question: question,
            index: index,
            onEdit: () => onEdit(index),
            onDelete: () => onDelete(index),
          ),
        );
      }).toList(),
    );
  }
}
