import 'package:catalyst/core/utils/app_colors.dart';
import 'package:catalyst/core/widgets/app_bar.dart';
import 'package:catalyst/core/widgets/base_scaffold.dart';
import 'package:catalyst/core/widgets/custom_button.dart';
import 'package:catalyst/core/widgets/custom_text.dart';
import 'package:catalyst/features/my%20classes/presentation/cubits/exam_details_cubit/exam_details_cubit.dart';
import 'package:catalyst/features/my%20classes/presentation/cubits/exam_details_cubit/exam_details_state.dart';
import 'package:catalyst/features/my%20classes/presentation/widgets/student_exam_card.dart';
import 'package:catalyst/features/my%20classes/domain/entities/exam_details_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:catalyst/core/utils/routs.dart';
import 'package:go_router/go_router.dart';

class ExamStudentsView extends StatefulWidget {
  final int examId;

  const ExamStudentsView({super.key, required this.examId});

  @override
  State<ExamStudentsView> createState() => _ExamStudentsViewState();
}

class _ExamStudentsViewState extends State<ExamStudentsView> {
  @override
  void initState() {
    super.initState();
    context.read<ExamDetailsCubit>().getExamDetails(widget.examId);
  }

  void _handleCompleteExam(BuildContext context, ExamDetailsEntity entity) {
    // 1. Check closingDate
    if (entity.closingDate != null) {
      final closingDate = DateTime.tryParse(entity.closingDate!);
      if (closingDate != null && DateTime.now().isBefore(closingDate)) {
        showDialog(
          context: context,
          builder: (dialogContext) => AlertDialog(
            title: const CustomText(
              text: 'Cannot Complete',
              fontWeight: FontWeight.bold,
            ),
            content: const CustomText(
              text: 'You cannot complete the exam before it ends.',
            ),
            actions: [
              TextButton(
                onPressed: () => dialogContext.pop(),
                child: const Text('OK'),
              ),
            ],
          ),
        );
        return;
      }
    }

    // 2. Check unverified students
    final unverifiedCount = entity.students.where((s) => !s.verified).length;
    final cubit = context.read<ExamDetailsCubit>();
    if (unverifiedCount > 0) {
      showDialog(
        context: context,
        builder: (dialogContext) => AlertDialog(
          title: const CustomText(
            text: 'Unverified Students',
            fontWeight: FontWeight.bold,
          ),
          content: CustomText(
            text:
                'There are $unverifiedCount students whose grades are not verified. Do you want to continue?',
          ),
          actions: [
            TextButton(
              onPressed: () => dialogContext.pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                dialogContext.pop();
                cubit.completeExam(widget.examId);
              },
              child: const Text('Continue'),
            ),
          ],
        ),
      );
    } else {
      // All good, proceed
      cubit.completeExam(widget.examId);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ExamDetailsCubit, ExamDetailsState>(
      listener: (context, state) {
        if (state is CompleteExamSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: CustomText(text: state.message, color: Colors.white),
              backgroundColor: Colors.green,
            ),
          );
          context.pop(true);
        } else if (state is CompleteExamError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: CustomText(text: state.message, color: Colors.white),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      builder: (context, state) {
        ExamDetailsEntity? entity;
        bool isLoading = false;
        bool isCompleting = false;
        String? errorMessage;

        if (state is ExamDetailsLoading) {
          isLoading = true;
        } else if (state is ExamDetailsError) {
          errorMessage = state.message;
        } else if (state is ExamDetailsSuccess) {
          entity = state.entity;
        } else if (state is CompleteExamLoading) {
          entity = state.entity;
          isCompleting = true;
        } else if (state is CompleteExamSuccess) {
          entity = state.entity;
        } else if (state is CompleteExamError) {
          entity = state.entity;
        }

        return BaseScaffold(
          appBar: CustomAppBar(
            title: entity != null ? entity.examName : 'Student Submissions',
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
              onPressed: () => context.pop(),
            ),
          ),
          child: isLoading
              ? const Center(child: CircularProgressIndicator())
              : errorMessage != null
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Text(
                      errorMessage,
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.red),
                    ),
                  ),
                )
              : entity != null
              ? Column(
                  children: [
                    Expanded(
                      child: entity.students.isEmpty
                          ? const Center(
                              child: Text(
                                'No students have taken this exam yet.',
                              ),
                            )
                          : ListView.builder(
                              padding: const EdgeInsets.all(16),
                              itemCount: entity.students.length,
                              itemBuilder: (context, index) {
                                return StudentExamCard(
                                  studentGrade: entity!.students[index],
                                  onTap: () async {
                                    final result = await context.push(
                                      Routs.studentReview,
                                      extra: entity!.students[index].id,
                                    );
                                    if (result == true) {
                                      context
                                          .read<ExamDetailsCubit>()
                                          .getExamDetails(widget.examId);
                                    }
                                  },
                                );
                              },
                            ),
                    ),
                    if (!entity.completed)
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: CustomButton(
                          text: 'COMPLETE EXAM',
                          onPressed: isCompleting
                              ? null
                              : () => _handleCompleteExam(context, entity!),
                          child: isCompleting
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : null,
                        ),
                      )
                    else
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.grey.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.grey.shade400),
                          ),
                          child: const Center(
                            child: CustomText(
                              text: 'EXAM COMPLETED',
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ),
                  ],
                )
              : const SizedBox.shrink(),
        );
      },
    );
  }
}
