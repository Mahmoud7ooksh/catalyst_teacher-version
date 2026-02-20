import 'package:catalyst/features/my%20classes/domain/entities/exam_details_entity.dart';

abstract class ExamDetailsState {}

class ExamDetailsInitial extends ExamDetailsState {}

class ExamDetailsLoading extends ExamDetailsState {}

class ExamDetailsSuccess extends ExamDetailsState {
  final ExamDetailsEntity entity;
  ExamDetailsSuccess(this.entity);
}

class ExamDetailsError extends ExamDetailsState {
  final String message;
  ExamDetailsError(this.message);
}

// Complete Exam States (Preserve entity to keep UI stable)
class CompleteExamLoading extends ExamDetailsState {
  final ExamDetailsEntity entity;
  CompleteExamLoading(this.entity);
}

class CompleteExamSuccess extends ExamDetailsState {
  final ExamDetailsEntity entity;
  final String message;
  CompleteExamSuccess(this.entity, this.message);
}

class CompleteExamError extends ExamDetailsState {
  final ExamDetailsEntity entity;
  final String message;
  CompleteExamError(this.entity, this.message);
}
