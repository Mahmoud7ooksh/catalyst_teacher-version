import 'package:catalyst/core/errors/exceptions.dart';
import 'package:catalyst/features/student requests/data/models/student_requests_model.dart';
import 'package:dartz/dartz.dart';

abstract class StudentRequestsRepo {
  Future<Either<Failure, List<StudentRequest>>> getStudentRequests();
  Future<Either<Failure, String>> approveRequest({
    required String requestId,
    required int lessonId,
  });
  Future<Either<Failure, String>> rejectRequest({
    required String requestId,
    required int lessonId,
  });
}
