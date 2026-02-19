import 'package:catalyst/core/utils/app_colors.dart';
import 'package:catalyst/core/widgets/custom_text.dart';
import 'package:catalyst/features/my%20classes/domain/entities/exam_details_entity.dart';
import 'package:flutter/material.dart';

class StudentExamCard extends StatelessWidget {
  final StudentGradeEntity studentGrade;
  final VoidCallback onTap;

  const StudentExamCard({
    super.key,
    required this.studentGrade,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        onTap: onTap,
        title: CustomText(
          text: studentGrade.studentName ?? 'Anonymous Student',
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            CustomText(
              text: studentGrade.grade != null
                  ? 'Grade: ${studentGrade.grade}'
                  : 'Grade: Pending',
              fontSize: 14,
              color: studentGrade.grade != null
                  ? AppColors.color1
                  : Colors.orange,
              fontWeight: FontWeight.w600,
            ),
          ],
        ),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: studentGrade.verified
                ? Colors.green.withOpacity(0.1)
                : Colors.grey.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: studentGrade.verified ? Colors.green : Colors.grey,
            ),
          ),
          child: CustomText(
            text: studentGrade.verified ? 'Verified' : 'Unverified',
            fontSize: 12,
            color: studentGrade.verified ? Colors.green : Colors.grey,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
