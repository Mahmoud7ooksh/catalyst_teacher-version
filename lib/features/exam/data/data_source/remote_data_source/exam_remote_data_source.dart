import 'package:catalyst/core/databases/api/constant.dart';
import 'package:catalyst/core/databases/api/dio_service.dart';
import 'package:catalyst/features/exam/data/models/question_model.dart';

abstract class ExamRemoteDataSource {
  Future<List<Question>> generateQuestionsWithAI({
    required String examId,
    required String userMessage,
  });
}

class ExamRemoteDataSourceImpl implements ExamRemoteDataSource {
  final DioService dioService;

  ExamRemoteDataSourceImpl(this.dioService);

  @override
  Future<List<Question>> generateQuestionsWithAI({
    required String examId,
    required String userMessage,
  }) async {
    final path = EndPoint.generateAIQuestions;

    final response = await dioService.post(
      path: path,
      data: {'examId': int.tryParse(examId) ?? 0, 'userMessage': userMessage},
    );

    final List<dynamic> rawList = (response is Map && response['data'] is List)
        ? response['data']
        : [];

    return List.generate(
      rawList.length,
      (i) => Question.fromAIJson(rawList[i] as Map<String, dynamic>, index: i),
    );
  }
}
