import 'package:catalyst/features/exam/data/models/exam_info_model.dart';
import 'package:catalyst/features/exam/data/models/question_model.dart';

abstract class CreateExamState {}

class CreateExamInitial extends CreateExamState {}

class CreateExamLoading extends CreateExamState {}

class CreateExamError extends CreateExamState {
  final String message;
  CreateExamError(this.message);
}

class CreateExamQuestionsLoaded extends CreateExamState {
  final List<Question> questions;
  CreateExamQuestionsLoaded(this.questions);
}

class CreateExamInfoLoaded extends CreateExamState {
  final ExamInfo examInfo;
  CreateExamInfoLoaded(this.examInfo);
}

class CreateExamSuccess extends CreateExamState {
  final String message;
  CreateExamSuccess(this.message);
}

class CreateExamInfoSaved extends CreateExamState {
  final String message;
  CreateExamInfoSaved(this.message);
}

class CreateExamFinalSuccess extends CreateExamState {
  final String message;
  CreateExamFinalSuccess(this.message);
}
