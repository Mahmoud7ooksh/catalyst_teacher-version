import 'dart:io';
import 'package:hive/hive.dart';
import 'package:catalyst/core/errors/exceptions.dart'; // فيها Failure

class CacheFailure extends Failure {
  CacheFailure(super.errMessage);

  factory CacheFailure.fromException(Object error) {
    if (error is HiveError) {
      // Errors خاصة بـ Hive نفسه
      return CacheFailure(error.message);
    }

    if (error is FileSystemException) {
      // مشاكل في الملفات (مثلاً permission, path, storage)
      return CacheFailure('Local storage error, please try again.');
    }

    // أي حاجة تانية مش متوقعة
    return CacheFailure('Unexpected local cache error, please try again.');
  }
}
