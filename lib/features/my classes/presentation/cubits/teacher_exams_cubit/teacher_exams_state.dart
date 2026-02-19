import 'package:catalyst/features/my%20classes/data/models/teacher_exam_model.dart';

abstract class TeacherExamsState {}

class TeacherExamsInitial extends TeacherExamsState {}

class TeacherExamsLoading extends TeacherExamsState {}

class TeacherExamsSuccess extends TeacherExamsState {
  final List<TeacherExamModel> exams;
  TeacherExamsSuccess(this.exams);
}

class TeacherExamsError extends TeacherExamsState {
  final String message;
  TeacherExamsError(this.message);
}
