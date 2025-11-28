import 'package:catalyst/core/databases/cache/constant.dart';
import 'package:catalyst/core/utils/routs.dart';
import 'package:catalyst/features/auth/data/repos/auth_repo_implementation.dart';
import 'package:catalyst/features/auth/presentation/cubit/forget%20password%20cubit/forget_password_cubit.dart';
import 'package:catalyst/features/exam/data/models/exam_info_model.dart';
import 'package:catalyst/features/exam/data/models/question_model.dart';
import 'package:catalyst/features/exam/data/repos/create_exam_repo_impl.dart';
import 'package:catalyst/features/exam/presentation/cubits/create_exam_cubit/create_exam_cubit.dart';
import 'package:catalyst/features/my%20classes/presentation/cubits/get%20my%20classes%20cubit/get_my_classes_cubit_cubit.dart';
import 'package:catalyst/features/student%20requests/data/repos/student_requests_repo_impl.dart';
import 'package:catalyst/features/student%20requests/presentation/cubits/approve%20reject%20request/approve_reject_request_cubit.dart';
import 'package:catalyst/features/student%20requests/presentation/cubits/get%20students%20requests%20cubit/get_students_requests_cubit.dart';
import 'package:flutter/material.dart';
import 'package:catalyst/core/utils/service_locator.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:catalyst/core/databases/cache/cache_helper.dart';
import 'package:catalyst/features/my%20classes/presentation/cubits/create%20class%20cubit/create_class_cubit.dart';
import 'package:catalyst/features/my%20classes/data/repos/my_classes_repo_impl.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  // ensure flutter binding
  WidgetsFlutterBinding.ensureInitialized();

  // init hive
  await Hive.initFlutter();

  // register adapters
  Hive.registerAdapter(ExamInfoAdapter());
  Hive.registerAdapter(QuestionTypeAdapter());
  Hive.registerAdapter(QuestionAdapter());

  // open boxes
  await Hive.openBox<ExamInfo>(Constant.examInfoKey);
  await Hive.openBox<Question>(Constant.questionsKey);

  // load env
  await dotenv.load(fileName: ".env");

  // init cache
  CacheHelper.init();

  // init service locator
  setupServiceLocator();

  // run app
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
            return CreateExamCubit(getIt.get<CreateExamRepoImpl>());
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
