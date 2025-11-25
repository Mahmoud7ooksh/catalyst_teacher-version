import 'package:catalyst/features/student%20requests/data/repos/student_requsets_repo.dart';
import 'package:catalyst/features/student%20requests/presentation/cubits/get%20students%20requests%20cubit/get_students_requests_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GetStudentsRequestsCubit extends Cubit<GetStudentsRequestsState> {
  GetStudentsRequestsCubit(this.studentRequestsRepo)
    : super(GetStudentsRequestsInitial());

  final StudentRequestsRepo studentRequestsRepo;

  Future<void> getStudentsRequests() async {
    emit(GetStudentsRequestsLoading());
    final result = await studentRequestsRepo.getStudentRequests();
    result.fold(
      (failure) => emit(GetStudentsRequestsError(message: failure.errMessage)),
      (data) {
        emit(GetStudentsRequestsSuccess(studentRequests: data));
      },
    );
  }
}
