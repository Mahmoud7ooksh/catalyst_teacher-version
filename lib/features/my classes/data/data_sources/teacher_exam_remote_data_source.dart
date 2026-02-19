import 'package:catalyst/core/databases/api/constant.dart';
import 'package:catalyst/core/databases/api/dio_service.dart';
import 'package:catalyst/features/my%20classes/data/models/teacher_exam_model.dart';

abstract class TeacherExamRemoteDataSource {
  Future<List<TeacherExamModel>> getLessonExams(int lessonId);
}

class TeacherExamRemoteDataSourceImpl implements TeacherExamRemoteDataSource {
  final DioService dioService;

  TeacherExamRemoteDataSourceImpl({required this.dioService});

  @override
  Future<List<TeacherExamModel>> getLessonExams(int lessonId) async {
    final response = await dioService.get(
      path: EndPoint.lessonExams.replaceFirst(
        '{lessonId}',
        lessonId.toString(),
      ),
    );

    final List<dynamic> examsJson = response['data'];
    return examsJson.map((json) => TeacherExamModel.fromJson(json)).toList();
  }
}
