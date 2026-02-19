import 'package:catalyst/features/my%20classes/data/repos/teacher_exam_repo_impl.dart';
import 'package:catalyst/features/my%20classes/presentation/cubits/teacher_exams_cubit/teacher_exams_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TeacherExamsCubit extends Cubit<TeacherExamsState> {
  final TeacherExamRepoImpl repo;

  TeacherExamsCubit(this.repo) : super(TeacherExamsInitial());

  Future<void> getLessonExams(int lessonId) async {
    emit(TeacherExamsLoading());
    final result = await repo.getLessonExams(lessonId);
    result.fold(
      (failure) => emit(TeacherExamsError(failure.errMessage)),
      (exams) => emit(TeacherExamsSuccess(exams)),
    );
  }
}
