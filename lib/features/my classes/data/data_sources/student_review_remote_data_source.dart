import 'package:catalyst/core/databases/api/constant.dart';
import 'package:catalyst/core/databases/api/dio_service.dart';
import 'package:catalyst/features/my%20classes/data/models/student_exam_answers_model.dart';

abstract class StudentReviewRemoteDataSource {
  Future<StudentExamAnswersResponseModel> getStudentExamAnswers(
    int studentExamId,
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
}
