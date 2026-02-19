import 'package:catalyst/core/utils/app_colors.dart';
import 'package:catalyst/core/widgets/custom_text.dart';
import 'package:catalyst/features/my%20classes/data/models/exam_review_models.dart';
import 'package:flutter/material.dart';

class QuestionReviewItem extends StatelessWidget {
  final QuestionReview question;

  const QuestionReviewItem({super.key, required this.question});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.color1.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: CustomText(
                  text: question.type,
                  fontSize: 10,
                  color: AppColors.color1,
                  fontWeight: FontWeight.bold,
                ),
              ),
              CustomText(
                text: '${question.aiScore}/${question.maxScore}',
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: AppColors.color1,
              ),
            ],
          ),
          const SizedBox(height: 12),
          CustomText(
            text: question.questionText,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
          const SizedBox(height: 12),
          const CustomText(
            text: 'Student Answer:',
            fontSize: 12,
            color: Colors.grey,
          ),
          const SizedBox(height: 4),
          Container(
            padding: const EdgeInsets.all(12),
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(8),
            ),
            child: CustomText(text: question.studentAnswer, fontSize: 14),
          ),
          if (question.type == 'WRITING' && question.similarity != null) ...[
            const SizedBox(height: 12),
            Row(
              children: [
                const CustomText(
                  text: 'AI Similarity Confidence: ',
                  fontSize: 12,
                  color: Colors.grey,
                ),
                CustomText(
                  text: '${(question.similarity! * 100).toStringAsFixed(0)}%',
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: _getSimilarityColor(question.similarity!),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Color _getSimilarityColor(double similarity) {
    if (similarity > 0.8) return Colors.green;
    if (similarity > 0.5) return Colors.orange;
    return Colors.red;
  }
}
