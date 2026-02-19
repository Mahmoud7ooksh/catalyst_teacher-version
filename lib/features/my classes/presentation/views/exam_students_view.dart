import 'package:catalyst/core/widgets/app_bar.dart';
import 'package:catalyst/core/widgets/base_scaffold.dart';
import 'package:catalyst/features/my%20classes/presentation/cubits/exam_details_cubit/exam_details_cubit.dart';
import 'package:catalyst/features/my%20classes/presentation/cubits/exam_details_cubit/exam_details_state.dart';
import 'package:catalyst/features/my%20classes/presentation/widgets/student_exam_card.dart';
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

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      appBar: CustomAppBar(
        title: 'Student Submissions',
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () => context.pop(),
        ),
      ),
      child: BlocBuilder<ExamDetailsCubit, ExamDetailsState>(
        builder: (context, state) {
          if (state is ExamDetailsLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ExamDetailsError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text(
                  state.message,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.red),
                ),
              ),
            );
          } else if (state is ExamDetailsSuccess) {
            final students = state.entity.students;
            if (students.isEmpty) {
              return const Center(
                child: Text('No students have taken this exam yet.'),
              );
            }
            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: students.length,
              itemBuilder: (context, index) {
                return StudentExamCard(
                  studentGrade: students[index],
                  onTap: () {
                    context.push(
                      Routs.studentReview,
                      extra: students[index].id,
                    );
                  },
                );
              },
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
