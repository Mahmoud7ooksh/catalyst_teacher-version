import 'package:catalyst/features/student%20requests/data/models/student_requests_model.dart';

abstract class GetStudentsRequestsState {}

final class GetStudentsRequestsInitial extends GetStudentsRequestsState {}

final class GetStudentsRequestsLoading extends GetStudentsRequestsState {}

final class GetStudentsRequestsSuccess extends GetStudentsRequestsState {
  final List<StudentRequest> studentRequests;

  GetStudentsRequestsSuccess({required this.studentRequests});
}

final class GetStudentsRequestsError extends GetStudentsRequestsState {
  final String message;

  GetStudentsRequestsError({required this.message});
}
