import 'package:catalyst/core/errors/exceptions.dart';
import 'package:catalyst/features/my%20classes/data/data_sources/exam_details_remote_data_source.dart';
import 'package:catalyst/features/my%20classes/data/models/exam_details_model.dart';
import 'package:catalyst/features/my%20classes/domain/entities/exam_details_entity.dart';
import 'package:catalyst/features/my%20classes/domain/repos/exam_details_repo.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

class ExamDetailsRepoImpl implements ExamDetailsRepo {
  final ExamDetailsRemoteDataSource remoteDataSource;

  ExamDetailsRepoImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, ExamDetailsEntity>> getExamDetails(int examId) async {
    try {
      final model = await remoteDataSource.getExamDetails(examId);
      final entity = _mapModelToEntity(model);
      return right(entity);
    } catch (e) {
      if (e is DioException) {
        return left(ServerFailure.fromDioError(e));
      }
      return left(ServerFailure(e.toString()));
    }
  }

  ExamDetailsEntity _mapModelToEntity(ExamDetailsDataModel model) {
    return ExamDetailsEntity(
      id: model.id,
      examName: model.examName,
      maxGrade: model.maxGrade,
      students: model.studentGrads
          .map((s) => _mapStudentModelToEntity(s))
          .toList(),
    );
  }

  StudentGradeEntity _mapStudentModelToEntity(StudentGradeModel model) {
    return StudentGradeEntity(
      id: model.id,
      studentName: model.studentName,
      grade: model.grade,
      verified: model.verified,
    );
  }
}
