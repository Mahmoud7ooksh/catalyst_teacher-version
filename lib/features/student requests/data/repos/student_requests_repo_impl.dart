import 'package:catalyst/core/databases/api/constant.dart';
import 'package:catalyst/core/databases/api/dio_service.dart';
import 'package:catalyst/core/errors/exceptions.dart';
import 'package:catalyst/features/student%20requests/data/models/student_requests_model.dart';
import 'package:catalyst/features/student%20requests/data/repos/student_requsets_repo.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

class StudentRequestsRepoImpl implements StudentRequestsRepo {
  final DioService dioService;
  StudentRequestsRepoImpl({required this.dioService});
  @override
  Future<Either<Failure, List<StudentRequest>>> getStudentRequests() async {
    try {
      final response = await dioService.get(path: EndPoint.pendingRequests);
      List<StudentRequest> studentRequests = [];
      for (var element in response['data']) {
        studentRequests.add(StudentRequest.fromJson(element));
      }
      return right(studentRequests);
    } catch (e) {
      if (e is DioException) {
        return left(ServerFailure.fromDioError(e));
      }
      return left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> approveRequest({
    required String requestId,
    required int lessonId,
  }) async {
    try {
      await dioService.post(
        path: EndPoint.approveRequest.replaceAll(
          '{lessonId}',
          lessonId.toString(),
        ),
        data: {
          "studentLessonIds": [int.parse(requestId)],
        },
      );
      return right('Request approved');
    } catch (e) {
      if (e is DioException) {
        return left(ServerFailure.fromDioError(e));
      }
      return left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> rejectRequest({
    required String requestId,
    required int lessonId,
  }) async {
    try {
      await dioService.post(
        path: EndPoint.rejectRequest.replaceAll(
          '{lessonId}',
          lessonId.toString(),
        ),
        data: {
          "studentLessonIds": [int.parse(requestId)],
        },
      );
      return right('Request rejected');
    } catch (e) {
      if (e is DioException) {
        return left(ServerFailure.fromDioError(e));
      }
      return left(ServerFailure(e.toString()));
    }
  }
}
