import 'package:catalyst/core/databases/api/constant.dart';
import 'package:catalyst/core/databases/api/dio_service.dart';
import 'package:catalyst/features/my%20classes/data/models/student_exam_answers_model.dart';
import 'package:catalyst/features/my%20classes/data/models/verify_student_exam_model.dart';

abstract class StudentReviewRemoteDataSource {
  Future<StudentExamAnswersResponseModel> getStudentExamAnswers(
    int studentExamId,
  );

  Future<VerifyStudentExamResponseModel> verifyStudentExam(
    int studentExamId,
    List<Map<String, dynamic>> body,
  );
}

class StudentReviewRemoteDataSourceImpl
    implements StudentReviewRemoteDataSource {
  final DioService dioService;

  StudentReviewRemoteDataSourceImpl({required this.dioService});

  @override
  Future<StudentExamAnswersResponseModel> getStudentExamAnswers(
    int studentExamId,
  ) async {
    final response = await dioService.get(
      path: EndPoint.studentExamAnswers.replaceFirst(
        '{studentExamId}',
        studentExamId.toString(),
      ),
    );
    return StudentExamAnswersResponseModel.fromJson(response);
  }

  @override
  Future<VerifyStudentExamResponseModel> verifyStudentExam(
    int studentExamId,
    List<Map<String, dynamic>> body,
  ) async {
    final response = await dioService.post(
      path: EndPoint.verifyStudentExam.replaceFirst(
        '{studentExamId}',
        studentExamId.toString(),
      ),
      data: body,
    );
    return VerifyStudentExamResponseModel.fromJson(response);
  }
}
