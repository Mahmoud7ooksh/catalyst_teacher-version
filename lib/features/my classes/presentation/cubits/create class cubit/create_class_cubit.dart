import 'package:catalyst/features/my%20classes/data/models/create_class_model.dart';
import 'package:catalyst/features/my%20classes/data/repos/my_classes_repo_impl.dart';
import 'package:catalyst/features/my%20classes/presentation/cubits/create%20class%20cubit/create_class_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';

class CreateClassCubit extends Cubit<CreateClassState> {
  CreateClassCubit(this._createClassRepo) : super(CreateClassInitial());
  final MyClassesRepoImpl _createClassRepo;

  final TextEditingController subjectController = TextEditingController();

  // List of lesson schedules (each with day, time, duration)
  List<LessonSchedule> lessonSchedules = [];

  // Add a new schedule
  void addSchedule(LessonSchedule schedule) {
    lessonSchedules.add(schedule);
  }

  // Remove a schedule at index
  void removeSchedule(int index) {
    if (index >= 0 && index < lessonSchedules.length) {
      lessonSchedules.removeAt(index);
    }
  }

  // Update a schedule at index
  void updateSchedule(int index, LessonSchedule schedule) {
    if (index >= 0 && index < lessonSchedules.length) {
      lessonSchedules[index] = schedule;
    }
  }

  Future<void> createClass() async {
    // validation
    final subject = subjectController.text.trim();
    if (subject.isEmpty) {
      emit(CreateClassError(message: 'اسم المادة مطلوب'));
      return;
    }
    if (lessonSchedules.isEmpty) {
      emit(CreateClassError(message: 'أضف جدول واحد على الأقل'));
      return;
    }

    emit(CreateClassLoading());

    final request = CreateClassRequest(
      subject: subject,
      lessonSchedules: lessonSchedules,
    );

    final result = await _createClassRepo.createClass(request);

    result.fold(
      (failure) => emit(CreateClassError(message: failure.errMessage)),
      (data) => emit(CreateClassSuccess(response: data)),
    );
  }

  @override
  Future<void> close() {
    subjectController.dispose();
    return super.close();
  }
}
