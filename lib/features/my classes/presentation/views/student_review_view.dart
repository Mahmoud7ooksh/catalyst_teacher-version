import 'package:catalyst/core/utils/app_colors.dart';
import 'package:catalyst/core/widgets/app_bar.dart';
import 'package:catalyst/core/widgets/base_scaffold.dart';
import 'package:catalyst/core/widgets/custom_button.dart';
import 'package:catalyst/core/widgets/custom_text.dart';
import 'package:catalyst/features/my%20classes/presentation/cubits/student_review_cubit/student_review_cubit.dart';
import 'package:catalyst/features/my%20classes/presentation/cubits/student_review_cubit/student_review_state.dart';
import 'package:catalyst/features/my%20classes/presentation/widgets/question_review_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class StudentReviewView extends StatefulWidget {
  final int studentExamId;

  const StudentReviewView({super.key, required this.studentExamId});

  @override
  State<StudentReviewView> createState() => _StudentReviewViewState();
}

class _StudentReviewViewState extends State<StudentReviewView> {
  @override
  void initState() {
    super.initState();
    context.read<StudentReviewCubit>().getStudentExamAnswers(
      widget.studentExamId,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StudentReviewCubit, StudentReviewState>(
      builder: (context, state) {
        if (state is StudentReviewLoading) {
          return const BaseScaffold(
            appBar: CustomAppBar(title: 'Reviewing...'),
            child: Center(child: CircularProgressIndicator()),
          );
        }

        if (state is StudentReviewError) {
          return BaseScaffold(
            appBar: const CustomAppBar(title: 'Error'),
            child: Center(
              child: CustomText(text: state.message, color: Colors.red),
            ),
          );
        }

        if (state is StudentReviewSuccess) {
          final review = state.review;
          return BaseScaffold(
            appBar: CustomAppBar(
              title: 'Review: ${review.studentName ?? 'Student'}',
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
                            text: review.studentName ?? 'Anonymous Student',
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                          const SizedBox(height: 4),
                          CustomText(
                            text: review.totalGrade != null
                                ? 'Total Grade: ${review.totalGrade}'
                                : 'Total Grade: Not graded yet',
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
                    itemCount: review.answers.length,
                    itemBuilder: (context, index) {
                      final answer = review.answers[index];
                      return QuestionReviewItem(
                        answer: answer,
                        editedMark: state.editedMarks[answer.questionId],
                        onMarkChanged: (val) {
                          context.read<StudentReviewCubit>().updateMark(
                            answer.questionId,
                            val,
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        }

        return const SizedBox.shrink();
      },
    );
  }
}
