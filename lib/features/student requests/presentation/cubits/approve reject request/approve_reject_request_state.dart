class ApproveRejectRequestState {}

final class ApproveRejectRequestInitial extends ApproveRejectRequestState {}

final class ApproveRejectRequestLoading extends ApproveRejectRequestState {}

final class ApproveRejectRequestSuccess extends ApproveRejectRequestState {
  final String message;
  ApproveRejectRequestSuccess({required this.message});
}

final class ApproveRejectRequestError extends ApproveRejectRequestState {
  final String message;
  ApproveRejectRequestError({required this.message});
}
