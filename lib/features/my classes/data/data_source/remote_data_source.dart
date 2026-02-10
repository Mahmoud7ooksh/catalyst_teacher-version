import 'package:catalyst/core/databases/api/constant.dart';
import 'package:catalyst/core/databases/api/dio_service.dart';
import 'package:catalyst/features/my%20classes/data/models/create_class_model.dart';
import 'package:catalyst/features/my%20classes/data/models/get_my_classes.dart';

abstract class MyClassesRemoteDataSource {
  Future<CreateClassResponse> createClass(CreateClassRequest createClassData);
  Future<List<Lesson>> getMyClasses();
}

class MyClassesRemoteDataSourceImpl implements MyClassesRemoteDataSource {
  final DioService dioService;

  MyClassesRemoteDataSourceImpl({required this.dioService});

  @override
  Future<CreateClassResponse> createClass(
    CreateClassRequest createClassData,
  ) async {
    final response = await dioService.post(
      path: EndPoint.createClass,
      data: createClassData.toJson(),
    );
    return CreateClassResponse.fromJson(response);
  }

  @override
  Future<List<Lesson>> getMyClasses() async {
    final response = await dioService.get(path: EndPoint.myLessons);

    // The API returns: {"data": {"number": 1, "lessons": [...]}}
    final data = response['data'];
    final lessonsJson = data['lessons'] as List<dynamic>;

    final lessons = lessonsJson
        .map((lessonJson) => Lesson.fromJson(lessonJson))
        .toList();

    return lessons;
  }
}
