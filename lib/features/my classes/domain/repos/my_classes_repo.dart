import 'package:catalyst/core/errors/exceptions.dart';
import 'package:catalyst/features/my%20classes/data/models/create_class_model.dart';
import 'package:catalyst/features/my%20classes/data/models/get_my_classes.dart';
import 'package:dartz/dartz.dart';

abstract class MyClassesRepo {
  Future<Either<Failure, CreateClassResponse>> createClass(
    CreateClassRequest createClassData,
  );
  Future<Either<Failure, List<Lesson>>> getMyClasses();
}
