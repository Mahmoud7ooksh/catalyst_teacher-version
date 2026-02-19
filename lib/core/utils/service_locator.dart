// lib/core/utils/service_locator.dart

import 'package:catalyst/core/databases/api/dio_service.dart';
import 'package:catalyst/features/my%20classes/data/data_source/remote_data_source.dart';
import 'package:catalyst/features/my%20classes/data/data_sources/exam_details_remote_data_source.dart';
import 'package:catalyst/features/my%20classes/data/data_sources/student_review_remote_data_source.dart';
import 'package:catalyst/features/my%20classes/data/repos/exam_details_repo_impl.dart';
import 'package:catalyst/features/my%20classes/data/repos/student_review_repo_impl.dart';
import 'package:catalyst/features/my%20classes/presentation/cubits/exam_details_cubit/exam_details_cubit.dart';
import 'package:catalyst/features/my%20classes/presentation/cubits/student_review_cubit/student_review_cubit.dart';
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
import 'package:catalyst/features/exam/presentation/cubits/create_exam_cubit/create_exam_cubit.dart';

// ===== teacher exam review =====
import 'package:catalyst/features/my classes/data/data_sources/teacher_exam_remote_data_source.dart';
import 'package:catalyst/features/my classes/data/repos/teacher_exam_repo_impl.dart';
import 'package:catalyst/features/my classes/presentation/cubits/teacher_exams_cubit/teacher_exams_cubit.dart';

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
  // Register the remote data source first
  getIt.registerLazySingleton<MyClassesRemoteDataSource>(
    () => MyClassesRemoteDataSourceImpl(dioService: getIt<DioService>()),
  );

  // Then register the repo that depends on it
  getIt.registerLazySingleton<MyClassesRepoImpl>(
    () => MyClassesRepoImpl(
      dioService: getIt<DioService>(),
      remoteDataSource: getIt<MyClassesRemoteDataSource>(),
    ),
  );

  // ========== STUDENT REQUESTS ==========
  getIt.registerLazySingleton<StudentRequestsRepoImpl>(
    () => StudentRequestsRepoImpl(dioService: getIt<DioService>()),
  );

  getIt.registerLazySingleton<ApproveRejectRequestCubit>(
    () => ApproveRejectRequestCubit(getIt<StudentRequestsRepoImpl>()),
  );

  // ========== CREATE EXAM (HIVE) ==========
  getIt.registerLazySingleton<CreateExamLocalDataSource>(
    () => CreateExamLocalDataSourceImpl(),
  );

  // Repo (اللي الكيوبيد بيستخدمه)
  getIt.registerLazySingleton<CreateExamRepoImpl>(
    () => CreateExamRepoImpl(
      getIt.get<CreateExamLocalDataSource>(),
      getIt.get<DioService>(),
    ),
  );

  // Cubit
  getIt.registerLazySingleton<CreateExamCubit>(
    () => CreateExamCubit(getIt.get<CreateExamRepoImpl>()),
  );

  // ========== TEACHER EXAM REVIEW ==========
  getIt.registerLazySingleton<TeacherExamRemoteDataSource>(
    () => TeacherExamRemoteDataSourceImpl(dioService: getIt<DioService>()),
  );

  getIt.registerLazySingleton<TeacherExamRepoImpl>(
    () => TeacherExamRepoImpl(
      remoteDataSource: getIt<TeacherExamRemoteDataSource>(),
    ),
  );

  getIt.registerFactory<TeacherExamsCubit>(
    () => TeacherExamsCubit(getIt<TeacherExamRepoImpl>()),
  );

  // ========== EXAM DETAILS ==========
  getIt.registerLazySingleton<ExamDetailsRemoteDataSource>(
    () => ExamDetailsRemoteDataSourceImpl(dioService: getIt<DioService>()),
  );

  getIt.registerLazySingleton<ExamDetailsRepoImpl>(
    () => ExamDetailsRepoImpl(
      remoteDataSource: getIt<ExamDetailsRemoteDataSource>(),
    ),
  );

  getIt.registerFactory<ExamDetailsCubit>(
    () => ExamDetailsCubit(getIt<ExamDetailsRepoImpl>()),
  );

  // ========== STUDENT REVIEW ==========
  getIt.registerLazySingleton<StudentReviewRemoteDataSource>(
    () => StudentReviewRemoteDataSourceImpl(dioService: getIt<DioService>()),
  );

  getIt.registerLazySingleton<StudentReviewRepoImpl>(
    () => StudentReviewRepoImpl(
      remoteDataSource: getIt<StudentReviewRemoteDataSource>(),
    ),
  );

  getIt.registerFactory<StudentReviewCubit>(
    () => StudentReviewCubit(getIt<StudentReviewRepoImpl>()),
  );
}
