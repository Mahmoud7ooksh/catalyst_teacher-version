import 'package:catalyst/features/exam/data/models/exam_info_model.dart';
import 'package:catalyst/features/exam/data/models/question_model.dart';
import 'package:catalyst/features/exam/domain/repo/create_exam_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'create_exam_state.dart';

class CreateExamCubit extends Cubit<CreateExamState> {
  final CreateExamRepo _repo;

  CreateExamCubit(this._repo) : super(CreateExamInitial());

  // ===================== Load Questions =====================
  Future<void> loadQuestions() async {
    emit(CreateExamLoading());
    final result = await _repo.loadQuestions();

    result.fold(
      (failure) => emit(CreateExamError(failure.errMessage)),
      (questions) => emit(CreateExamQuestionsLoaded(questions)),
    );
  }

  // ===================== Load Exam Info =====================
  Future<void> loadExamInfo() async {
    emit(CreateExamLoading());
    final result = await _repo.loadExamInfo();

    result.fold(
      (failure) => emit(CreateExamError(failure.errMessage)),
      (info) => emit(CreateExamInfoLoaded(info)),
    );
  }

  // ===================== Save Exam Info =====================
  Future<void> saveExamInfo(ExamInfo examInfo) async {
    emit(CreateExamLoading());
    final result = await _repo.saveExamInfo(examInfo);

    result.fold(
      (failure) => emit(CreateExamError(failure.errMessage)),
      (_) => emit(CreateExamSuccess("Exam info saved")),
    );
  }

  // ===================== Add Question =====================
  Future<void> addQuestion(Question question) async {
    emit(CreateExamLoading());
    final result = await _repo.addQuestion(question);

    result.fold(
      (failure) => emit(CreateExamError(failure.errMessage)),
      (questions) => emit(CreateExamQuestionsLoaded(questions)),
    );
  }

  // ===================== Update Question =====================
  Future<void> updateQuestion(Question question) async {
    emit(CreateExamLoading());
    final result = await _repo.updateQuestion(question);

    result.fold(
      (failure) => emit(CreateExamError(failure.errMessage)),
      (questions) => emit(CreateExamQuestionsLoaded(questions)),
    );
  }

  // ===================== Delete Question =====================
  Future<void> deleteQuestion(String id) async {
    emit(CreateExamLoading());
    final result = await _repo.deleteQuestion(id);

    result.fold(
      (failure) => emit(CreateExamError(failure.errMessage)),
      (questions) => emit(CreateExamQuestionsLoaded(questions)),
    );
  }

  // ===================== Clear Questions =====================
  Future<void> clearQuestions() async {
    emit(CreateExamLoading());
    final result = await _repo.clearQuestions();

    result.fold(
      (failure) => emit(CreateExamError(failure.errMessage)),
      (_) => emit(CreateExamSuccess("Questions cleared")),
    );
  }

  // ===================== Clear Exam Info =====================
  Future<void> clearExamInfo() async {
    emit(CreateExamLoading());
    final result = await _repo.clearExamInfo();

    result.fold(
      (failure) => emit(CreateExamError(failure.errMessage)),
      (_) => emit(CreateExamSuccess("Exam info cleared")),
    );
  }
}
