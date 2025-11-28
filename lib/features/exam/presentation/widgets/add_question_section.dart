import 'package:flutter/material.dart';
import 'package:catalyst/core/utils/app_colors.dart';
import 'package:catalyst/core/widgets/custom_text.dart';
import 'package:catalyst/features/exam/data/models/question_model.dart';
import 'package:catalyst/features/exam/presentation/widgets/add_question_sheet.dart';
import 'package:catalyst/features/exam/presentation/widgets/add_question_dialog.dart';

class AddQuestionSection extends StatelessWidget {
  const AddQuestionSection({super.key, required this.onQuestionAdded});

  final ValueChanged<Question> onQuestionAdded;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final String? action = await showModalBottomSheet<String>(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.white,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
          ),
          builder: (ctx) => const AddQuestionSheet(),
        );

        if (action == null) return;

        // 2) لو اختار Add Manually، نفتح الـ Dialog
        if (action == 'manual') {
          final Question? newQuestion = await showDialog<Question>(
            context: context,
            builder: (dialogContext) => AddQuestionDialog(
              onSubmit: (q) {
                Navigator.pop(dialogContext, q);
              },
            ),
          );

          if (newQuestion != null) {
            onQuestionAdded(newQuestion);
          }
        }

        // TODO: file / myBank / globalBank هتتعامل معاهم بعدين
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 18),
        decoration: BoxDecoration(
          color: AppColors.color3,
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.add_circle_outline, size: 26, color: AppColors.color1),
              SizedBox(height: 6),
              CustomText(text: 'Add Question', color: AppColors.color1),
            ],
          ),
        ),
      ),
    );
  }
}
