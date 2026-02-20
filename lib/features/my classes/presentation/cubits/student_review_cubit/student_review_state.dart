import 'package:catalyst/features/my%20classes/domain/entities/student_exam_review_entity.dart';
import 'package:catalyst/features/my%20classes/domain/entities/verified_student_exam_entity.dart';

abstract class StudentReviewState {}

class StudentReviewInitial extends StudentReviewState {}

class StudentReviewLoading extends StudentReviewState {}

class StudentReviewSuccess extends StudentReviewState {
  final StudentExamReviewEntity review;
  final Map<int, double> editedMarks;

  StudentReviewSuccess(this.review, this.editedMarks);
}

class StudentReviewError extends StudentReviewState {
  final String message;

  StudentReviewError(this.message);
}

class StudentReviewVerifying extends StudentReviewState {}

class StudentReviewVerified extends StudentReviewState {
  final VerifiedStudentExamEntity verifiedExam;

  StudentReviewVerified(this.verifiedExam);
}

class StudentReviewVerifyError extends StudentReviewState {
  final String message;

  StudentReviewVerifyError(this.message);
}
