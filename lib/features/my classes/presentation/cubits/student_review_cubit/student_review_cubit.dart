import 'package:catalyst/features/my%20classes/domain/repos/student_review_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'student_review_state.dart';

class StudentReviewCubit extends Cubit<StudentReviewState> {
  final StudentReviewRepo repo;
  Map<int, double> _editedMarks = {};

  StudentReviewCubit(this.repo) : super(StudentReviewInitial());

  Future<void> getStudentExamAnswers(int studentExamId) async {
    emit(StudentReviewLoading());
    final result = await repo.getStudentExamAnswers(studentExamId);
    result.fold((failure) => emit(StudentReviewError(failure.errMessage)), (
      review,
    ) {
      _editedMarks = {}; // Reset edits on new load
      emit(StudentReviewSuccess(review, _editedMarks));
    });
  }

  void updateMark(int questionId, double mark) {
    if (state is StudentReviewSuccess) {
      final successState = state as StudentReviewSuccess;
      _editedMarks[questionId] = mark;
      emit(StudentReviewSuccess(successState.review, Map.from(_editedMarks)));
    }
  }
}
