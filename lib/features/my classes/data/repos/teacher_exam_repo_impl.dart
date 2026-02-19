import 'package:catalyst/core/errors/exceptions.dart';
import 'package:catalyst/features/my%20classes/data/data_sources/teacher_exam_remote_data_source.dart';
import 'package:catalyst/features/my%20classes/data/models/teacher_exam_model.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

abstract class TeacherExamRepo {
  Future<Either<Failure, List<TeacherExamModel>>> getLessonExams(int lessonId);
}

class TeacherExamRepoImpl implements TeacherExamRepo {
  final TeacherExamRemoteDataSource remoteDataSource;

  TeacherExamRepoImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<TeacherExamModel>>> getLessonExams(
    int lessonId,
  ) async {
    try {
      final exams = await remoteDataSource.getLessonExams(lessonId);
      return right(exams);
    } catch (e) {
      if (e is DioException) {
        return left(ServerFailure.fromDioError(e));
      }
      return left(ServerFailure(e.toString()));
    }
  }
}
