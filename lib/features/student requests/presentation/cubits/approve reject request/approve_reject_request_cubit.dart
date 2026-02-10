import 'package:catalyst/features/student%20requests/data/repos/student_requsets_repo.dart';
import 'package:catalyst/features/student%20requests/presentation/cubits/approve%20reject%20request/approve_reject_request_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ApproveRejectRequestCubit extends Cubit<ApproveRejectRequestState> {
  ApproveRejectRequestCubit(this.studentRequestsRepo)
    : super(ApproveRejectRequestInitial());
  final StudentRequestsRepo studentRequestsRepo;

  Future<void> approveRequest({
    required String requestId,
    required int lessonId,
  }) async {
    emit(ApproveRejectRequestLoading());
    final result = await studentRequestsRepo.approveRequest(
      requestId: requestId,
      lessonId: lessonId,
    );
    result.fold(
      (failure) => emit(ApproveRejectRequestError(message: failure.errMessage)),
      (message) => emit(ApproveRejectRequestSuccess(message: message)),
    );
  }

  Future<void> rejectRequest({
    required String requestId,
    required int lessonId,
  }) async {
    emit(ApproveRejectRequestLoading());
    final result = await studentRequestsRepo.rejectRequest(
      requestId: requestId,
      lessonId: lessonId,
    );
    result.fold(
      (failure) => emit(ApproveRejectRequestError(message: failure.errMessage)),
      (message) => emit(ApproveRejectRequestSuccess(message: message)),
    );
  }
}
