import 'package:catalyst/core/databases/api/dio_service.dart';
import 'package:catalyst/core/errors/exceptions.dart';
import 'package:catalyst/features/my%20classes/data/data_source/remote_data_source.dart';
import 'package:catalyst/features/my%20classes/data/models/create_class_model.dart';
import 'package:catalyst/features/my%20classes/data/models/get_my_classes.dart';
import 'package:catalyst/features/my%20classes/domain/repos/my_classes_repo.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

class MyClassesRepoImpl implements MyClassesRepo {
  final MyClassesRemoteDataSource remoteDataSource;

  MyClassesRepoImpl({
    required this.remoteDataSource,
    required DioService dioService,
  });

  @override
  Future<Either<Failure, CreateClassResponse>> createClass(
    CreateClassRequest createClassData,
  ) async {
    try {
      final response = await remoteDataSource.createClass(createClassData);
      return right(response);
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
      final lessons = await remoteDataSource.getMyClasses();
      return right(lessons);
    } catch (e) {
      if (e is DioException) {
        return left(ServerFailure.fromDioError(e));
      }
      return left(ServerFailure(e.toString()));
    }
  }
}
