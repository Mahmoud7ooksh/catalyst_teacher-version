import 'package:catalyst/core/utils/app_colors.dart';
import 'package:catalyst/core/widgets/custom_text.dart';
import 'package:catalyst/features/my%20classes/domain/entities/student_exam_review_entity.dart';
import 'package:flutter/material.dart';

class QuestionReviewItem extends StatelessWidget {
  final StudentAnswerReviewEntity answer;
  final double? editedMark;
  final Function(double) onMarkChanged;

  const QuestionReviewItem({
    super.key,
    required this.answer,
    this.editedMark,
    required this.onMarkChanged,
  });

  @override
  Widget build(BuildContext context) {
    final bool isMcq = answer.questionType == 'MCQ';

    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: Type and AI Score
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.color1.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: CustomText(
                    text: answer.questionType,
                    fontSize: 11,
                    color: AppColors.color1,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.psychology,
                        size: 16,
                        color: Colors.blue,
                      ),
                      const SizedBox(width: 4),
                      CustomText(
                        text: '${answer.aiMark ?? '?'}/${answer.maxPoints}',
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: AppColors.color1,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Question Text
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: CustomText(
              text: answer.questionText,
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 16),

          // Content Box (MCQ Options or Writing Answer)
          if (isMcq) _buildMcqContent() else _buildWritingContent(),

          const SizedBox(height: 16),
          const Divider(height: 1),

          // Footer: Manual Grade Input
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                const Icon(Icons.edit_note, size: 20, color: Colors.grey),
                const SizedBox(width: 8),
                const CustomText(
                  text: 'Final Grade:',
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
                const Spacer(),
                SizedBox(
                  width: 70,
                  child: TextField(
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                    decoration: InputDecoration(
                      hintText: '${answer.aiMark ?? 0}',
                      isDense: true,
                      contentPadding: const EdgeInsets.symmetric(vertical: 10),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Colors.grey.shade200),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(
                          color: AppColors.color1,
                          width: 2,
                        ),
                      ),
                    ),
                    onChanged: (val) {
                      final double? grade = double.tryParse(val);
                      if (grade != null) onMarkChanged(grade);
                    },
                  ),
                ),
                const SizedBox(width: 8),
                CustomText(
                  text: '/ ${answer.maxPoints}',
                  fontSize: 14,
                  color: Colors.grey.shade600,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMcqContent() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: List.generate(answer.options?.length ?? 0, (index) {
          final String option = answer.options![index];
          final bool isSelected =
              answer.selectedOptions?.contains(index) ?? false;
          // Fallback: if correctOptions is missing but mark is full, treat selection as correct
          final bool isCorrect =
              (answer.correctOptions?.contains(index) ?? false) ||
              (isSelected && (answer.aiMark ?? 0) >= answer.maxPoints);

          Color bgColor = Colors.grey.shade50;
          Color borderColor = Colors.grey.shade200;
          Widget? icon;

          if (isSelected && isCorrect) {
            bgColor = Colors.green.withOpacity(0.08);
            borderColor = Colors.green.withOpacity(0.5);
            icon = const Icon(
              Icons.check_circle,
              color: Colors.green,
              size: 20,
            );
          } else if (isSelected && !isCorrect) {
            bgColor = Colors.red.withOpacity(0.08);
            borderColor = Colors.red.withOpacity(0.5);
            icon = const Icon(Icons.cancel, color: Colors.red, size: 20);
          } else if (!isSelected && isCorrect) {
            bgColor = Colors.green.withOpacity(0.03);
            borderColor = Colors.green.withOpacity(0.2);
            icon = Icon(
              Icons.check_circle_outline,
              color: Colors.green.withOpacity(0.5),
              size: 20,
            );
          }

          return Container(
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: borderColor, width: 1.5),
            ),
            child: Row(
              children: [
                if (icon != null) ...[
                  icon,
                  const SizedBox(width: 12),
                ] else ...[
                  Icon(
                    Icons.circle_outlined,
                    color: Colors.grey.shade400,
                    size: 20,
                  ),
                  const SizedBox(width: 12),
                ],
                Expanded(
                  child: CustomText(
                    text: option,
                    fontSize: 14,
                    color: (isSelected || isCorrect)
                        ? Colors.black87
                        : Colors.grey.shade700,
                    fontWeight: (isSelected || isCorrect)
                        ? FontWeight.w600
                        : FontWeight.normal,
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget _buildWritingContent() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInfoSection(
            title: 'Student Answer',
            icon: Icons.person_outline,
            content: answer.textAnswer ?? 'No answer provided',
            color: Colors.blue.shade700,
          ),
          const SizedBox(height: 12),
          if (answer.correctAnswer != null)
            _buildInfoSection(
              title: 'Model Answer',
              icon: Icons.verified_user_outlined,
              content: answer.correctAnswer!,
              color: Colors.green.shade700,
            ),
        ],
      ),
    );
  }

  Widget _buildInfoSection({
    required String title,
    required IconData icon,
    required String content,
    required Color color,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: color),
              const SizedBox(width: 6),
              CustomText(
                text: title,
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ],
          ),
          const SizedBox(height: 8),
          CustomText(text: content, fontSize: 14, color: Colors.black87),
        ],
      ),
    );
  }
}
