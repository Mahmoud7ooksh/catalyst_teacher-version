import 'package:flutter/material.dart';
import 'package:catalyst/core/utils/app_colors.dart';
import 'package:catalyst/core/widgets/custom_text.dart';
import 'package:catalyst/features/exam/data/models/question_model.dart';

class QuestionCard extends StatelessWidget {
  const QuestionCard({
    super.key,
    required this.question,
    required this.index,
    required this.onEdit,
    required this.onDelete,
  });

  final Question question;
  final int index;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  String get typeLabel {
    switch (question.type) {
      case QuestionType.mcq:
        return 'MCQ';
      case QuestionType.shortAnswer:
        return 'Short Answer';
      case QuestionType.trueFalse:
        return 'True/False';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.color3,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // type + actions
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: AppColors.color1,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: CustomText(
                  text: typeLabel,
                  color: Colors.white,
                  fontSize: 12,
                ),
              ),
              Row(
                children: [
                  IconButton(
                    onPressed: onEdit,
                    icon: const Icon(
                      Icons.edit,
                      size: 20,
                      color: AppColors.color1,
                    ),
                  ),
                  IconButton(
                    onPressed: onDelete,
                    icon: const Icon(
                      Icons.delete_outline,
                      size: 22,
                      color: Colors.red,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 8),
          CustomText(
            text: "Q${index + 1}: ${question.text}",
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
          const SizedBox(height: 6),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const CustomText(
                text: 'Answer: ',
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
              Expanded(child: CustomText(text: question.answer, fontSize: 13)),
            ],
          ),
        ],
      ),
    );
  }
}
