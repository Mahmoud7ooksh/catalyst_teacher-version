import 'package:catalyst/core/databases/api/constant.dart';
import 'package:catalyst/core/databases/api/dio_service.dart';
import 'package:catalyst/features/my%20classes/data/models/exam_details_model.dart';

abstract class ExamDetailsRemoteDataSource {
  Future<ExamDetailsDataModel> getExamDetails(int examId);
  Future<Map<String, dynamic>> completeExam(int examId);
}

class ExamDetailsRemoteDataSourceImpl implements ExamDetailsRemoteDataSource {
  final DioService dioService;

  ExamDetailsRemoteDataSourceImpl({required this.dioService});

  @override
  Future<ExamDetailsDataModel> getExamDetails(int examId) async {
    final response = await dioService.get(
      path: EndPoint.examDetails.replaceFirst('{examId}', examId.toString()),
    );

    final ExamDetailsResponseModel responseModel =
        ExamDetailsResponseModel.fromJson(response);
    return responseModel.data;
  }

  @override
  Future<Map<String, dynamic>> completeExam(int examId) async {
    final response = await dioService.post(
      path: EndPoint.completeExam.replaceFirst('{examId}', examId.toString()),
    );
    return response;
  }
}
