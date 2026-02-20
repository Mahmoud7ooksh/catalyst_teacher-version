import 'package:catalyst/core/errors/exceptions.dart';
import 'package:catalyst/features/my%20classes/domain/entities/student_exam_review_entity.dart';
import 'package:catalyst/features/my%20classes/domain/entities/verified_student_exam_entity.dart';
import 'package:dartz/dartz.dart';

abstract class StudentReviewRepo {
  Future<Either<Failure, StudentExamReviewEntity>> getStudentExamAnswers(
    int studentExamId,
  );

  Future<Either<Failure, VerifiedStudentExamEntity>> verifyStudentExam(
    int studentExamId,
    Map<int, double> editedMarks,
  );
}
