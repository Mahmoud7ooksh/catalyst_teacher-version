import 'package:catalyst/features/my%20classes/domain/repos/exam_details_repo.dart';
import 'package:catalyst/features/my%20classes/presentation/cubits/exam_details_cubit/exam_details_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ExamDetailsCubit extends Cubit<ExamDetailsState> {
  final ExamDetailsRepo repo;

  ExamDetailsCubit(this.repo) : super(ExamDetailsInitial());

  Future<void> getExamDetails(int examId) async {
    emit(ExamDetailsLoading());
    final result = await repo.getExamDetails(examId);
    result.fold(
      (failure) => emit(ExamDetailsError(failure.errMessage)),
      (entity) => emit(ExamDetailsSuccess(entity)),
    );
  }
}
