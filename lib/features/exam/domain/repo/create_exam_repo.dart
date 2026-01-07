import 'package:catalyst/core/errors/exceptions.dart';
import 'package:catalyst/features/exam/data/models/question_model.dart';
import 'package:catalyst/features/exam/data/models/exam_info_model.dart';
import 'package:dartz/dartz.dart';

abstract class CreateExamRepo {
  // ===== exam questions =====
  Future<Either<Failure, List<Question>>> loadQuestions();
  Future<Either<Failure, List<Question>>> addQuestion(Question question);
  Future<Either<Failure, List<Question>>> updateQuestion(
    Question updatedQuestion,
  );
  Future<Either<Failure, List<Question>>> deleteQuestion(String questionId);
  Future<Either<Failure, void>> clearQuestions();

  // ===== exam info =====
  Future<Either<Failure, ExamInfo>> loadExamInfo();
  Future<Either<Failure, void>> saveExamInfo(ExamInfo examInfo);
  Future<Either<Failure, void>> clearExamInfo();
  Future<Either<Failure, String>> createExam(
    String lessonId,
    Map<String, dynamic> examData,
  );
}
