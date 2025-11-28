import 'package:flutter/material.dart';
import 'package:catalyst/core/widgets/app_bar.dart';
import 'package:catalyst/core/widgets/base_scaffold.dart';
import 'package:catalyst/features/exam/data/models/question_model.dart';
import 'package:catalyst/features/exam/presentation/widgets/add_question_section.dart';
import 'package:catalyst/features/exam/presentation/widgets/questions_section.dart';
import 'package:catalyst/features/exam/presentation/widgets/create_exam_section.dart';

class ExamQuestionsView extends StatelessWidget {
  const ExamQuestionsView({
    super.key,
    required this.questions,
    required this.onQuestionAdded,
    required this.onQuestionDeleted,
    required this.onQuestionEditRequested,
    required this.onCreateExam,
  });

  /// الأسئلة اللي جايه من الـ Cubit / ViewModel
  final List<Question> questions;

  /// لما المستخدم يضيف سؤال جديد
  final ValueChanged<Question> onQuestionAdded;

  /// لما يطلب تعديل سؤال (بنمرر الـ index)
  final ValueChanged<int> onQuestionEditRequested;

  /// لما يحذف سؤال
  final ValueChanged<int> onQuestionDeleted;

  /// لما يضغط "Create Exam"
  final VoidCallback onCreateExam;

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
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            children: [
              // 1) ويدجت إضافة سؤال
              AddQuestionSection(onQuestionAdded: onQuestionAdded),

              const SizedBox(height: 16),

              // 2) ويدجت ليستة الأسئلة
              QuestionsSection(
                questions: questions,
                onEdit: onQuestionEditRequested,
                onDelete: onQuestionDeleted,
              ),

              const SizedBox(height: 24),

              // 3) ويدجت زر إنشاء الامتحان
              CreateExamSection(onCreateExam: onCreateExam),

              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
