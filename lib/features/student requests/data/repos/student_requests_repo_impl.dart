import 'package:catalyst/core/databases/api/constant.dart';
import 'package:catalyst/core/databases/api/dio_service.dart';
import 'package:catalyst/core/errors/exceptions.dart';
import 'package:catalyst/features/student%20requests/data/models/student_requests_model.dart';
import 'package:catalyst/features/student%20requests/data/repos/student_requsets_repo.dart';
import 'package:catalyst/core/databases/cache/cache_helper.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

class StudentRequestsRepoImpl implements StudentRequestsRepo {
  final DioService dioService;
  StudentRequestsRepoImpl({required this.dioService});
  @override
  Future<Either<Failure, List<StudentRequest>>> getStudentRequests() async {
    try {
      final id = await CacheHelper.getData(key: 'userId');
      final response = await dioService.get(
        path: '/api/teachers/lessons/$id/join-requests',
      );
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
  Future<Either<Failure, String>> approveRequest(String requestId) async {
    try {
      await dioService.post(
        path: EndPoint.approveRequest + requestId.toString(),
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
  Future<Either<Failure, String>> rejectRequest(String requestId) async {
    try {
      await dioService.post(
        path: EndPoint.rejectRequest + requestId.toString(),
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
