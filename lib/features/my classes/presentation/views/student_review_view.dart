import 'package:catalyst/core/utils/app_colors.dart';
import 'package:catalyst/core/widgets/app_bar.dart';
import 'package:catalyst/core/widgets/base_scaffold.dart';
import 'package:catalyst/core/widgets/custom_button.dart';
import 'package:catalyst/core/widgets/custom_text.dart';
import 'package:catalyst/features/my%20classes/data/models/exam_review_models.dart';
import 'package:catalyst/features/my%20classes/presentation/widgets/question_review_item.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class StudentReviewView extends StatelessWidget {
  final StudentSubmissionPreview submission;

  const StudentReviewView({super.key, required this.submission});

  @override
  Widget build(BuildContext context) {
    // Dummy Data
    final questions = [
      QuestionReview(
        id: 'q1',
        questionText: 'What is the powerhouse of the cell?',
        studentAnswer: 'Mitochondria',
        aiScore: 2,
        maxScore: 2,
        type: 'MCQ',
      ),
      QuestionReview(
        id: 'q2',
        questionText: 'Explain the process of photosynthesis in detail.',
        studentAnswer:
            'Plants use sunlight to make food. This happens in the leaves where chlorophyll is present. They take CO2 and water and release oxygen.',
        aiScore: 4.5,
        maxScore: 6,
        similarity: 0.85,
        type: 'WRITING',
      ),
      QuestionReview(
        id: 'q3',
        questionText: 'What is DNA?',
        studentAnswer: 'It is a molecule that carries genetic information.',
        aiScore: 2.5,
        maxScore: 3,
        similarity: 0.9,
        type: 'WRITING',
      ),
    ];

    return BaseScaffold(
      appBar: CustomAppBar(
        title: 'Review: ${submission.studentName}',
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () => context.pop(),
        ),
      ),
      child: Column(
        children: [
          // Header Summary
          Container(
            padding: const EdgeInsets.all(20),
            color: AppColors.color1.withOpacity(0.05),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      text: submission.studentName,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    const SizedBox(height: 4),
                    CustomText(
                      text:
                          'Total Grade: ${submission.aiGrade}/${submission.maxGrade}',
                      fontSize: 14,
                      color: AppColors.color1,
                      fontWeight: FontWeight.w600,
                    ),
                  ],
                ),
                SizedBox(
                  width: 138,
                  child: CustomButton(
                    text: 'CONFIRM',
                    onPressed: () {
                      // Logic later
                      context.pop();
                    },
                  ),
                ),
              ],
            ),
          ),
          // Questions List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: questions.length,
              itemBuilder: (context, index) {
                return QuestionReviewItem(question: questions[index]);
              },
            ),
          ),
        ],
      ),
    );
  }
}
