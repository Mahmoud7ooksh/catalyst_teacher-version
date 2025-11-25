import 'package:catalyst/core/databases/api/constant.dart';
import 'package:catalyst/core/databases/api/dio_service.dart';
import 'package:catalyst/core/errors/exceptions.dart';
import 'package:catalyst/features/my%20classes/data/models/create_class_model.dart';
import 'package:catalyst/features/my%20classes/data/models/get_my_classes.dart';
import 'package:catalyst/features/my%20classes/data/repos/my_classes_repo.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

class MyClassesRepoImpl implements MyClassesRepo {
  final DioService dioService;
  MyClassesRepoImpl({required this.dioService});
  @override
  Future<Either<Failure, CreateClassResponse>> createClass(
    Map<String, dynamic> createClassData,
  ) async {
    try {
      final response = await dioService.post(
        path: EndPoint.createClass,
        data: createClassData,
      );
      return right(CreateClassResponse.fromJson(response));
    } catch (e) {
      if (e is DioException) {
        return left(ServerFailure.fromDioError(e));
      }
      return left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Lesson>>> getMyClasses() async {
    try {
      final response = await dioService.get(path: EndPoint.myLessons);
      List<Lesson> lessons = [];
      for (var element in response.data['data']) {
        lessons.add(Lesson.fromJson(element));
      }

      return right(lessons);
    } catch (e) {
      if (e is DioException) {
        return left(ServerFailure.fromDioError(e));
      }
      return left(ServerFailure(e.toString()));
    }
  }
}
