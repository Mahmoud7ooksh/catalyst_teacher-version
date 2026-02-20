import 'package:catalyst/core/errors/exceptions.dart';
import 'package:catalyst/features/my%20classes/data/data_sources/student_review_remote_data_source.dart';
import 'package:catalyst/features/my%20classes/data/models/student_exam_answers_model.dart';
import 'package:catalyst/features/my%20classes/domain/entities/student_exam_review_entity.dart';
import 'package:catalyst/features/my%20classes/domain/entities/verified_student_exam_entity.dart';
import 'package:catalyst/features/my%20classes/domain/repos/student_review_repo.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

class StudentReviewRepoImpl implements StudentReviewRepo {
  final StudentReviewRemoteDataSource remoteDataSource;

  StudentReviewRepoImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, StudentExamReviewEntity>> getStudentExamAnswers(
    int studentExamId,
  ) async {
    try {
      final response = await remoteDataSource.getStudentExamAnswers(
        studentExamId,
      );
      return right(_mapModelToEntity(response.data));
    } catch (e) {
      if (e is DioException) {
        return left(ServerFailure.fromDioError(e));
      }
      return left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, VerifiedStudentExamEntity>> verifyStudentExam(
    int studentExamId,
    Map<int, double> editedMarks,
  ) async {
    try {
      final List<Map<String, dynamic>> body = editedMarks.entries
          .map((e) => {'answerId': e.key, 'mark': e.value})
          .toList();

      final response = await remoteDataSource.verifyStudentExam(
        studentExamId,
        body,
      );
      return right(
        VerifiedStudentExamEntity(
          success: response.success,
          message: response.message,
        ),
      );
    } catch (e) {
      if (e is DioException) {
        return left(ServerFailure.fromDioError(e));
      }
      return left(ServerFailure(e.toString()));
    }
  }

  StudentExamReviewEntity _mapModelToEntity(StudentExamAnswersDataModel model) {
    return StudentExamReviewEntity(
      studentName: model.studentName,
      totalGrade: model.totalGrade,
      completed: model.completed ?? false,
      answers: model.answers.map((a) {
        // If correctOptionIndex is missing but we have correctAnswer text, try to find the indices
        List<int>? correctIndices = a.question.correctOptionIndex;
        if (correctIndices == null &&
            a.question.correctAnswer != null &&
            a.question.options != null) {
          final String correctText = a.question.correctAnswer!;
          // Support multiple if split by comma or something, but usually it's one
          final int index = a.question.options!.indexOf(correctText);
          if (index != -1) {
            correctIndices = [index];
          }
        }

        return StudentAnswerReviewEntity(
          answerId: a.id,
          questionId: a.question.id,
          questionText: a.question.text,
          questionType: a.question.type,
          options: a.question.options,
          maxPoints: a.question.maxPoints,
          selectedOptions: a.selectedOptions,
          correctOptions: correctIndices,
          textAnswer: a.textAnswer,
          correctAnswer: a.question.correctAnswer,
          aiMark: a.mark,
        );
      }).toList(),
    );
  }
}
