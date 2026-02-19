import 'package:catalyst/core/utils/routs.dart';
import 'package:catalyst/core/widgets/app_bar.dart';
import 'package:catalyst/core/widgets/base_scaffold.dart';
import 'package:catalyst/features/my%20classes/presentation/cubits/teacher_exams_cubit/teacher_exams_cubit.dart';
import 'package:catalyst/features/my%20classes/presentation/cubits/teacher_exams_cubit/teacher_exams_state.dart';
import 'package:catalyst/features/my%20classes/presentation/widgets/exam_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class ClassExamsView extends StatefulWidget {
  final int lessonId;

  const ClassExamsView({super.key, required this.lessonId});

  @override
  State<ClassExamsView> createState() => _ClassExamsViewState();
}

class _ClassExamsViewState extends State<ClassExamsView> {
  @override
  void initState() {
    super.initState();
    context.read<TeacherExamsCubit>().getLessonExams(widget.lessonId);
  }

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      appBar: CustomAppBar(
        title: 'Class Exams',
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () => context.pop(),
        ),
      ),
      child: BlocBuilder<TeacherExamsCubit, TeacherExamsState>(
        builder: (context, state) {
          if (state is TeacherExamsLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is TeacherExamsError) {
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
          } else if (state is TeacherExamsSuccess) {
            final exams = state.exams;
            if (exams.isEmpty) {
              return const Center(child: Text('No exams found for this class'));
            }
            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: exams.length,
              itemBuilder: (context, index) {
                return ExamCard(
                  exam: exams[index],
                  onTap: () {
                    context.push(Routs.examStudents, extra: exams[index].id);
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
