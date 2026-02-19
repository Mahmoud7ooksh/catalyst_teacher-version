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
