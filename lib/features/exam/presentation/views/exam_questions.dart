import 'package:flutter/material.dart';

import 'package:catalyst/core/utils/app_colors.dart';
import 'package:catalyst/core/widgets/app_bar.dart';
import 'package:catalyst/core/widgets/base_scaffold.dart';
import 'package:catalyst/core/widgets/custom_text.dart';
import 'package:catalyst/features/auth/presentation/widgets/custom_button.dart';
import 'package:catalyst/features/exam/data/models/question_model.dart';
import 'package:catalyst/features/exam/presentation/widgets/add_question_sheet.dart';
import 'package:catalyst/features/exam/presentation/widgets/add_question_dialog.dart';
import 'package:catalyst/features/exam/presentation/widgets/questions_list.dart';

class ExamQuestions extends StatefulWidget {
  const ExamQuestions({super.key});

  @override
  State<ExamQuestions> createState() => _ExamQuestionsState();
}

class _ExamQuestionsState extends State<ExamQuestions> {
  /// الأسئلة اللي موجودة في الامتحان
  final List<Question> _questions = [];

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      appBar: CustomAppBar(
        title: 'Questions',
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: const Icon(Icons.arrow_back, color: Colors.white, size: 24),
        ),
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              const SizedBox(height: 12),

              // ================== 1) زرار Add Question ==================
              GestureDetector(
                onTap: () async {
                  // 1) افتح الشيت وخليه يرجّع نوع الاختيار كـ String
                  final String? action = await showModalBottomSheet<String>(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: Colors.white,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(18),
                      ),
                    ),
                    builder: (ctx) => const AddQuestionSheet(),
                  );

                  if (!mounted || action == null) return;

                  // 2) لو المستخدم اختار Add Manually افتح الدايالوج
                  if (action == 'manual') {
                    final Question? newQuestion = await showDialog<Question>(
                      context: context,
                      builder: (dialogContext) => AddQuestionDialog(
                        onSubmit: (q) {
                          Navigator.pop(
                            dialogContext,
                            q,
                          ); // 👈 هنا بس بنقفل الـ dialog
                        },
                      ),
                    );

                    if (newQuestion != null && mounted) {
                      setState(() {
                        _questions.add(newQuestion);
                      });
                    }
                  }

                  // باقي الاختيارات (file / myBank / global) هنعملها بعدين
                },

                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 18,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.color3,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.add_circle_outline,
                          size: 26,
                          color: AppColors.color1,
                        ),
                        SizedBox(height: 6),
                        CustomText(
                          text: 'Add Question',
                          color: AppColors.color1,
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 12),

              // ================== 2) Questions List ==================
              QuestionsList(
                questions: _questions,
                onEdit: (index) async {},
                onDelete: (index) {
                  setState(() {
                    _questions.removeAt(index);
                  });
                },
              ),

              const SizedBox(height: 20),

              // ================== 3) Create Exam Button ==================
              CustomButton(
                text: 'Create Exam',
                onPressed: () {
                  // هنا بعدين هتبعت _questions للباك إند
                },
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
