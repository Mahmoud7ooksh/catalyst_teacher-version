import 'package:catalyst/core/databases/api/dio_service.dart';
import 'package:catalyst/features/auth/data/data_source/remote_data_source.dart';
import 'package:catalyst/features/my classes/data/repos/my_classes_repo_impl.dart';
import 'package:catalyst/features/student requests/data/repos/student_requests_repo_impl.dart';
import 'package:catalyst/features/student requests/presentation/cubits/approve reject request/approve_reject_request_cubit.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:catalyst/features/auth/data/repos/auth_repo_implementation.dart';

final getIt = GetIt.instance;

void setupServiceLocator() {
  // 1) سجّل Dio الأساسي
  getIt.registerLazySingleton<Dio>(() => Dio());

  // 2) سجّل DioService اللي بيستخدم Dio
  getIt.registerLazySingleton<DioService>(() => DioService(dio: getIt<Dio>()));

  // 3) RemoteDataSourceImplementation يعتمد على DioService (اللي وارث من ApiService)
  getIt.registerLazySingleton<RemoteDataSourceImplementation>(
    () => RemoteDataSourceImplementation(apiService: getIt<DioService>()),
  );

  // 4) AuthRepoImplementation يعتمد على RemoteDataSourceImplementation
  getIt.registerLazySingleton<AuthRepoImplementation>(
    () => AuthRepoImplementation(
      remoteDataSourceImplementation: getIt<RemoteDataSourceImplementation>(),
    ),
  );

  // 5) Repos تانية بتستخدم DioService
  getIt.registerLazySingleton<MyClassesRepoImpl>(
    () => MyClassesRepoImpl(dioService: getIt<DioService>()),
  );

  getIt.registerLazySingleton<StudentRequestsRepoImpl>(
    () => StudentRequestsRepoImpl(dioService: getIt<DioService>()),
  );

  // 6) Cubit بتستخدم StudentRequestsRepoImpl
  getIt.registerLazySingleton<ApproveRejectRequestCubit>(
    () => ApproveRejectRequestCubit(getIt<StudentRequestsRepoImpl>()),
  );
}
