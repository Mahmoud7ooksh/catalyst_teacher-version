// lib/core/utils/service_locator.dart

import 'package:catalyst/core/databases/api/dio_service.dart';
import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';

// ===== auth =====
import 'package:catalyst/features/auth/data/data_source/remote_data_source.dart';
import 'package:catalyst/features/auth/data/repos/auth_repo_implementation.dart';

// ===== my classes =====
import 'package:catalyst/features/my classes/data/repos/my_classes_repo_impl.dart';

// ===== student requests =====
import 'package:catalyst/features/student requests/data/repos/student_requests_repo_impl.dart';
import 'package:catalyst/features/student requests/presentation/cubits/approve reject request/approve_reject_request_cubit.dart';

// ===== create exam =====
import 'package:catalyst/features/exam/data/data_source/local_data_source/create_exam_local_data_source.dart';
import 'package:catalyst/features/exam/data/repos/create_exam_repo_impl.dart';

final getIt = GetIt.instance;

void setupServiceLocator() {
  // ========== CORE ==========
  getIt.registerLazySingleton<Dio>(() => Dio());

  getIt.registerLazySingleton<DioService>(() => DioService(dio: getIt<Dio>()));

  // ========== AUTH ==========
  getIt.registerLazySingleton<RemoteDataSourceImplementation>(
    () => RemoteDataSourceImplementation(apiService: getIt<DioService>()),
  );

  getIt.registerLazySingleton<AuthRepoImplementation>(
    () => AuthRepoImplementation(
      remoteDataSourceImplementation: getIt<RemoteDataSourceImplementation>(),
    ),
  );

  // ========== MY CLASSES ==========
  getIt.registerLazySingleton<MyClassesRepoImpl>(
    () => MyClassesRepoImpl(dioService: getIt<DioService>()),
  );

  // ========== STUDENT REQUESTS ==========
  getIt.registerLazySingleton<StudentRequestsRepoImpl>(
    () => StudentRequestsRepoImpl(dioService: getIt<DioService>()),
  );

  getIt.registerLazySingleton<ApproveRejectRequestCubit>(
    () => ApproveRejectRequestCubit(getIt<StudentRequestsRepoImpl>()),
  );

  // ========== CREATE EXAM (HIVE) ==========
  // Local Data Source
  getIt.registerLazySingleton<CreateExamLocalDataSource>(
    () => CreateExamLocalDataSourceImpl(),
  );

  // Repo (اللي الكيوبيد بيستخدمه)
  getIt.registerLazySingleton<CreateExamRepoImpl>(
    () => CreateExamRepoImpl(getIt<CreateExamLocalDataSource>()),
  );
}
