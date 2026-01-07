import 'package:catalyst/core/errors/cache_failure.dart';
import 'package:catalyst/core/errors/exceptions.dart';
import 'package:catalyst/features/exam/data/data_source/local_data_source/create_exam_local_data_source.dart';
import 'package:catalyst/features/exam/data/models/exam_info_model.dart';
import 'package:catalyst/features/exam/data/models/question_model.dart';
import 'package:catalyst/features/exam/domain/repo/create_exam_repo.dart';
import 'package:dartz/dartz.dart';

import 'package:catalyst/core/databases/api/constant.dart';
import 'package:catalyst/core/databases/api/dio_service.dart';
import 'package:dio/dio.dart';

class CreateExamRepoImpl implements CreateExamRepo {
  final CreateExamLocalDataSource _createExamLocalDataSource;
  final DioService dioService;

  CreateExamRepoImpl(this._createExamLocalDataSource, this.dioService);

  // ===================== Add Question =====================
  @override
  Future<Either<Failure, List<Question>>> addQuestion(Question question) async {
    try {
      await _createExamLocalDataSource.addQuestion(question);
      final questions = await _createExamLocalDataSource.loadQuestions();
      return Right(questions);
    } catch (e) {
      return Left(CacheFailure.fromException(e));
    }
  }

  // ===================== Update Question =====================
  @override
  Future<Either<Failure, List<Question>>> updateQuestion(
    Question updatedQuestion,
  ) async {
    try {
      await _createExamLocalDataSource.updateQuestion(updatedQuestion);
      final questions = await _createExamLocalDataSource.loadQuestions();
      return Right(questions);
    } catch (e) {
      return Left(CacheFailure.fromException(e));
    }
  }

  // ===================== Delete Question =====================
  @override
  Future<Either<Failure, List<Question>>> deleteQuestion(
    String questionId,
  ) async {
    try {
      await _createExamLocalDataSource.deleteQuestion(questionId);
      final questions = await _createExamLocalDataSource.loadQuestions();
      return Right(questions);
    } catch (e) {
      return Left(CacheFailure.fromException(e));
    }
  }

  // ===================== Load Questions =====================
  @override
  Future<Either<Failure, List<Question>>> loadQuestions() async {
    try {
      final questions = await _createExamLocalDataSource.loadQuestions();
      return Right(questions);
    } catch (e) {
      return Left(CacheFailure.fromException(e));
    }
  }

  // ===================== Clear Questions =====================
  @override
  Future<Either<Failure, void>> clearQuestions() async {
    try {
      await _createExamLocalDataSource.clearQuestions();
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure.fromException(e));
    }
  }

  // ===================== Save Exam Info =====================
  @override
  Future<Either<Failure, void>> saveExamInfo(ExamInfo examInfo) async {
    try {
      await _createExamLocalDataSource.saveExamInfo(examInfo);
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure.fromException(e));
    }
  }

  // ===================== Load Exam Info =====================
  @override
  Future<Either<Failure, ExamInfo>> loadExamInfo() async {
    try {
      final examInfo = await _createExamLocalDataSource.loadExamInfo();
      if (examInfo != null) {
        return Right(examInfo);
      }
      return Left(CacheFailure('No exam info found'));
    } catch (e) {
      return Left(CacheFailure.fromException(e));
    }
  }

  // ===================== Clear Exam Info =====================
  @override
  Future<Either<Failure, void>> clearExamInfo() async {
    try {
      await _createExamLocalDataSource.clearExamInfo();
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure.fromException(e));
    }
  }

  // ===================== Create Exam (API) =====================
  @override
  Future<Either<Failure, String>> createExam(
    String lessonId,
    Map<String, dynamic> examData,
  ) async {
    try {
      final response = await dioService.post(
        path: EndPoint.createExam.replaceAll('{id}', lessonId),
        data: examData,
      );
      return Right(response['message'] ?? 'Exam created successfully');
    } catch (e) {
      if (e is DioException) {
        return Left(ServerFailure.fromDioError(e));
      }
      return Left(ServerFailure(e.toString()));
    }
  }
}
