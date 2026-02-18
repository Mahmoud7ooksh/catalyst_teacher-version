import 'package:catalyst/features/exam/data/models/exam_info_model.dart';
import 'package:catalyst/features/exam/data/models/question_model.dart';
import 'package:catalyst/features/exam/domain/repo/create_exam_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:catalyst/features/exam/data/models/create_exam_request_model.dart';
import 'create_exam_state.dart';

class CreateExamCubit extends Cubit<CreateExamState> {
  final CreateExamRepo _repo;

  CreateExamCubit(this._repo) : super(CreateExamInitial());

  void reset() {
    emit(CreateExamInitial());
  }

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
      (_) => emit(CreateExamInfoSaved("Exam info saved")),
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

  // ===================== Submit Exam (API) =====================
  Future<void> submitExam() async {
    emit(CreateExamLoading());

    // 1. Load Exam Info
    final infoResult = await _repo.loadExamInfo();
    ExamInfo? examInfo;
    infoResult.fold(
      (failure) => null, // Handle error later if needed
      (info) => examInfo = info,
    );

    if (examInfo == null) {
      emit(CreateExamError("Exam info is missing"));
      return;
    }

    // 2. Load Questions
    final questionsResult = await _repo.loadQuestions();
    List<Question> questions = [];
    questionsResult.fold((failure) => null, (q) => questions = q);

    if (questions.isEmpty) {
      emit(CreateExamError("Please add at least one question"));
      return;
    }

    // 3. Prepare Request Model
    final requestModel = CreateExamRequestModel(
      examName: examInfo!.title ?? 'Untitled Exam',
      maxGrade: examInfo!.totalMarks ?? 0,
      examDateTime:
          examInfo!.scheduledAt?.toIso8601String() ??
          DateTime.now().toIso8601String(),
      durationMinutes: examInfo!.durationMinutes ?? 60,
      defaultPoints: examInfo!.defaultPoints ?? 1,
      examType: examInfo!.examType ?? 'Midterm',
      closingDate: examInfo!.closingDate?.toIso8601String(),
      questions: questions.map((q) {
        final isMcq =
            q.type == QuestionType.mcq || q.type == QuestionType.trueFalse;
        return QuestionRequestModel(
          text: q.text,
          type: _mapQuestionType(q.type),
          options: isMcq ? (q.options ?? []) : null,
          correctOptionIndex: isMcq
              ? (q.options?.indexOf(q.answer) ?? 0)
              : null,
          maxPoints: q.points ?? 1,
          correctAnswer: isMcq ? null : q.answer,
        );
      }).toList(),
    );

    // 4. Call API
    // We need lessonId. It's stored in examInfo.classIds
    if (examInfo!.classIds.isEmpty) {
      emit(CreateExamError("No class selected"));
      return;
    }

    final lessonId = examInfo!.classIds.first;

    final result = await _repo.createExam(lessonId, requestModel.toJson());

    result.fold((failure) => emit(CreateExamError(failure.errMessage)), (
      message,
    ) async {
      // 5. Clear Local Data on Success
      await _repo.clearExamInfo();
      await _repo.clearQuestions();
      emit(CreateExamFinalSuccess(message));
    });
  }

  String _mapQuestionType(QuestionType type) {
    switch (type) {
      case QuestionType.mcq:
      case QuestionType.trueFalse:
        return 'MCQ';
      case QuestionType.shortAnswer:
        return 'WRITING';
    }
  }
}
