import 'package:catalyst/core/utils/routs.dart';
import 'package:catalyst/features/auth/data/repos/auth_repo_implementation.dart';
import 'package:catalyst/features/auth/presentation/cubit/forget%20password%20cubit/forget_password_cubit.dart';
import 'package:catalyst/features/my%20classes/presentation/cubits/get%20my%20classes%20cubit/get_my_classes_cubit_cubit.dart';
import 'package:catalyst/features/student%20requests/data/repos/student_requests_repo_impl.dart';
import 'package:catalyst/features/student%20requests/presentation/cubits/approve%20reject%20request/approve_reject_request_cubit.dart';
import 'package:catalyst/features/student%20requests/presentation/cubits/get%20students%20requests%20cubit/get_students_requests_cubit.dart';
import 'package:flutter/material.dart';
import 'package:catalyst/core/utils/service_locator.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:catalyst/core/databases/cache_helper.dart';
import 'package:catalyst/features/my%20classes/presentation/cubits/create%20class%20cubit/create_class_cubit.dart';
import 'package:catalyst/features/my%20classes/data/repos/my_classes_repo_impl.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  CacheHelper.init();
  setupServiceLocator();
  runApp(const CatalystTeacher());
}

class CatalystTeacher extends StatelessWidget {
  const CatalystTeacher({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) {
            return ApproveRejectRequestCubit(
              getIt.get<StudentRequestsRepoImpl>(),
            );
          },
        ),
        BlocProvider(
          create: (context) {
            return GetStudentsRequestsCubit(
              getIt.get<StudentRequestsRepoImpl>(),
            );
          },
        ),
        BlocProvider(
          create: (context) {
            return GetMyClassesCubitCubit(getIt.get<MyClassesRepoImpl>());
          },
        ),
        BlocProvider(
          create: (context) {
            return ForgetPasswordCubit(getIt.get<AuthRepoImplementation>());
          },
        ),
        BlocProvider(
          create: (context) {
            return CreateClassCubit(getIt.get<MyClassesRepoImpl>());
          },
        ),
      ],
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        routerConfig: Routs.router,
        theme: ThemeData(
          appBarTheme: AppBarTheme(
            iconTheme: IconThemeData(color: Colors.white),
          ),
        ),
      ),
    );
  }
}
