import 'package:catalyst/features/exam/presentation/views/exam_questions.dart';
import 'package:catalyst/core/utils/routs.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:catalyst/features/exam/data/models/question_model.dart';
import 'package:catalyst/features/exam/presentation/cubits/create_exam_cubit/create_exam_cubit.dart';
import 'package:catalyst/features/exam/presentation/cubits/create_exam_cubit/create_exam_state.dart';
import 'package:catalyst/features/exam/presentation/widgets/add_question_dialog.dart';

class ExamQuestionsPage extends StatefulWidget {
  final int? defaultPoints;
  const ExamQuestionsPage({super.key, this.defaultPoints});

  @override
  State<ExamQuestionsPage> createState() => _ExamQuestionsPageState();
}

class _ExamQuestionsPageState extends State<ExamQuestionsPage> {
  List<Question> _questions = [];

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
    return BlocConsumer<CreateExamCubit, CreateExamState>(
      listener: (context, state) {
        if (state is CreateExamFinalSuccess) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
          GoRouter.of(context).go(Routs.root);
        } else if (state is CreateExamError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message), backgroundColor: Colors.red),
          );
        }

        if (state is CreateExamQuestionsLoaded) {
          _questions = state.questions;
        }
      },
      builder: (context, state) {
        // Update local questions if loaded (redundant with listener but safe)
        if (state is CreateExamQuestionsLoaded) {
          _questions = state.questions;
        }

        return Stack(
          children: [
            ExamQuestionsView(
              questions: _questions,

              onQuestionAdded: (q) {
                context.read<CreateExamCubit>().addQuestion(q);
              },
              onQuestionDeleted: (index) {
                if (index >= 0 && index < _questions.length) {
                  final question = _questions[index];
                  context.read<CreateExamCubit>().deleteQuestion(question.id);
                }
              },
              onQuestionEditRequested: (index) async {
                if (index >= 0 && index < _questions.length) {
                  final question = _questions[index];
                  final updated = await showDialog<Question>(
                    context: context,
                    builder: (ctx) => AddQuestionDialog(
                      onSubmit: (q) => Navigator.pop(ctx, q),
                      initialQuestion: question,
                    ),
                  );
                  if (updated != null) {
                    context.read<CreateExamCubit>().updateQuestion(updated);
                  }
                }
              },
              onCreateExam: () {
                context.read<CreateExamCubit>().submitExam();
              },
            ),
            if (state is CreateExamLoading)
              Container(
                color: Colors.black54,
                child: const Center(child: CircularProgressIndicator()),
              ),
          ],
        );
      },
    );
  }
}
