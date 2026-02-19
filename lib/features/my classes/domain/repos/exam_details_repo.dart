import 'package:catalyst/core/errors/exceptions.dart';
import 'package:catalyst/features/my%20classes/domain/entities/exam_details_entity.dart';
import 'package:dartz/dartz.dart';

abstract class ExamDetailsRepo {
  Future<Either<Failure, ExamDetailsEntity>> getExamDetails(int examId);
}
