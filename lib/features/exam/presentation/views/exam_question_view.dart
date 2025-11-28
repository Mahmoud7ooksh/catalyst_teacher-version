import 'package:catalyst/features/exam/presentation/views/exam_questions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:catalyst/features/exam/data/models/question_model.dart';
import 'package:catalyst/features/exam/presentation/cubits/create_exam_cubit/create_exam_cubit.dart';
import 'package:catalyst/features/exam/presentation/cubits/create_exam_cubit/create_exam_state.dart';
import 'package:catalyst/features/exam/presentation/widgets/add_question_dialog.dart';

class ExamQuestionsPage extends StatefulWidget {
  const ExamQuestionsPage({super.key});

  @override
  State<ExamQuestionsPage> createState() => _ExamQuestionsPageState();
}

class _ExamQuestionsPageState extends State<ExamQuestionsPage> {
  @override
  void initState() {
    super.initState();
    // أول ما الصفحة تفتح → هات الأسئلة من Hive
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CreateExamCubit>().loadQuestions();
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateExamCubit, CreateExamState>(
      builder: (context, state) {
        final List<Question> questions;

        if (state is CreateExamQuestionsLoaded) {
          questions = state.questions;
        } else {
          questions = const [];
        }

        // لو أول مرة ولسه بيحمّل
        if (state is CreateExamLoading && questions.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        return ExamQuestionsView(
          questions: questions,

          // ==== Add Question ====
          onQuestionAdded: (q) {
            context.read<CreateExamCubit>().addQuestion(q);
          },

          // ==== Delete Question ====
          onQuestionDeleted: (index) {
            final question = questions[index];
            context.read<CreateExamCubit>().deleteQuestion(question.id);
          },

          // ==== Edit Question ====
          onQuestionEditRequested: (index) async {
            final question = questions[index];

            final updated = await showDialog<Question>(
              context: context,
              builder: (ctx) => AddQuestionDialog(
                onSubmit: (q) => Navigator.pop(ctx, q),
                initialQuestion: question, // هنظبطها تحت
              ),
            );

            if (updated != null) {
              context.read<CreateExamCubit>().updateQuestion(updated);
            }
          },

          // ==== Create Exam ====
          onCreateExam: () async {
            // هنا بعدين هتجيب examInfo + questions من الكيوبيد
            // وتبعتهم للـ API أو تروح لصفحة Review
          },
        );
      },
    );
  }
}
