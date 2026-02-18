import 'package:catalyst/features/my%20classes/data/repos/my_classes_repo_impl.dart';
import 'package:catalyst/features/my%20classes/presentation/cubits/get%20my%20classes%20cubit/get_my_classes_cubit_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GetMyClassesCubitCubit extends Cubit<GetMyClassesCubitState> {
  GetMyClassesCubitCubit(this.myClassesRepoImpl)
    : super(GetMyClassesCubitInitial());
  final MyClassesRepoImpl myClassesRepoImpl;

  Future<void> getMyClasses({bool forceRefresh = false}) async {
    if (!forceRefresh && state is GetMyClassesCubitSuccess) {
      return;
    }
    emit(GetMyClassesCubitLoading());
    final result = await myClassesRepoImpl.getMyClasses();
    result.fold(
      (failure) {
        if (!isClosed) {
          emit(GetMyClassesCubitError(message: failure.errMessage));
        }
      },
      (response) {
        if (!isClosed) emit(GetMyClassesCubitSuccess(response: response));
      },
    );
  }
}
