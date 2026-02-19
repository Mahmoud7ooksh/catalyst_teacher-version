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
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
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
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: AppColors.color1.withOpacity(0.1),
                child: CustomText(
                  text:
                      studentGrade.studentName?.substring(0, 1).toUpperCase() ??
                      'S',
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.color1,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      text: studentGrade.studentName ?? 'Anonymous Student',
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        _buildStatusBadge(),
                        const SizedBox(width: 8),
                        if (studentGrade.grade != null)
                          CustomText(
                            text: 'Grade: ${studentGrade.grade}',
                            fontSize: 13,
                            color: AppColors.color1,
                            fontWeight: FontWeight.w600,
                          ),
                      ],
                    ),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusBadge() {
    final bool isVerified = studentGrade.verified;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: (isVerified ? Colors.green : Colors.orange).withOpacity(0.1),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: (isVerified ? Colors.green : Colors.orange).withOpacity(0.5),
        ),
      ),
      child: CustomText(
        text: isVerified ? 'Verified' : 'Pending',
        fontSize: 10,
        color: isVerified ? Colors.green.shade700 : Colors.orange.shade800,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
