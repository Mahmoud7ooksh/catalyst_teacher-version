import 'package:catalyst/core/utils/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:catalyst/features/auth/data/repos/auth_repo_implementation.dart';
import 'package:catalyst/features/auth/presentation/cubit/forget%20password%20cubit/forget_password_cubit.dart';
import 'package:catalyst/features/auth/presentation/cubit/login%20cubit/login_cubit.dart';
import 'package:catalyst/features/auth/presentation/cubit/register%20cubit/register_cubit.dart';
import 'package:catalyst/features/auth/presentation/cubit/email%20verification%20cubit/email_verification_cubit.dart';
import 'package:catalyst/features/auth/presentation/views/email_verification_view.dart';
import 'package:catalyst/features/auth/presentation/views/forget_password_view.dart';
import 'package:catalyst/features/auth/presentation/views/send_email_view.dart';
import 'package:catalyst/features/auth/presentation/views/login_view.dart';
import 'package:catalyst/features/auth/presentation/views/register_view.dart';
import 'package:catalyst/features/auto%20grade/presentation/views/auto_grade_view.dart';
import 'package:catalyst/features/exam/presentation/cubits/create_exam_cubit/create_exam_cubit.dart';
import 'package:catalyst/features/exam/presentation/views/exam_question_view.dart';
import 'package:catalyst/features/home/presentation/views/home_view.dart';
import 'package:catalyst/features/my%20classes/presentation/cubits/create%20class%20cubit/create_class_cubit.dart';
import 'package:catalyst/features/my%20classes/data/repos/my_classes_repo_impl.dart';
import 'package:catalyst/features/my%20classes/presentation/cubits/get%20my%20classes%20cubit/get_my_classes_cubit_cubit.dart';
import 'package:catalyst/features/my%20classes/presentation/views/students_in_class.dart';
import 'package:catalyst/features/roots.dart';
import 'package:catalyst/features/splash/splash_view.dart';
import 'package:catalyst/features/student%20requests/data/repos/student_requests_repo_impl.dart';
import 'package:catalyst/features/student%20requests/presentation/cubits/approve%20reject%20request/approve_reject_request_cubit.dart';
import 'package:catalyst/features/student%20requests/presentation/cubits/get%20students%20requests%20cubit/get_students_requests_cubit.dart';
import 'package:catalyst/features/student%20requests/presentation/views/student_profile.dart';
import 'package:catalyst/features/student%20requests/presentation/views/student_requests.dart';
import 'package:catalyst/features/exam/presentation/views/create_exam_page.dart';
import 'package:catalyst/features/my classes/presentation/views/my_classes_view.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class Routs {
  static const String splash = '/';
  static const String login = '/login';
  static const String register = '/register';
  static const String forgetPassword = '/forgetPassword';
  static const String sendEmail = '/sendEmail';
  static const String root = '/root';
  static const String home = '/home';
  static const String schedule = '/schedule';
  static const String students = '/students';
  static const String autoGrade = '/autoGrade';
  static const String studentRequests = '/studentRequests';
  static const String studentProfile = '/studentProfile';
  static const String myClasses = '/myClasses';
  static const String studentsInClass = '/studentsInClass';
  static const String examQuestions = '/examQuestions';
  static const String emailVerification = '/emailVerification';
  static const String emailVerified = '/emailVerified';

  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  static final GoRouter router = GoRouter(
    navigatorKey: navigatorKey,
    routes: [
      GoRoute(path: splash, builder: (context, state) => const SplashView()),
      GoRoute(
        path: login,
        builder: (context, state) => BlocProvider(
          create: (context) => LoginCubit(getIt.get<AuthRepoImplementation>()),
          child: LoginView(),
        ),
      ),
      GoRoute(
        path: register,
        builder: (context, state) => BlocProvider(
          create: (context) =>
              RegisterCubit(getIt.get<AuthRepoImplementation>()),
          child: RegisterView(),
        ),
      ),
      ShellRoute(
        builder: (context, state, child) {
          return BlocProvider(
            create: (context) =>
                ForgetPasswordCubit(getIt.get<AuthRepoImplementation>()),
            child: child,
          );
        },
        routes: [
          GoRoute(
            path: forgetPassword,
            builder: (context, state) => ForgetPassword(),
          ),

          GoRoute(
            path: sendEmail,
            builder: (context, state) => SendEmailView(),
          ),
        ],
      ),
      GoRoute(
        path: emailVerification,
        builder: (context, state) => BlocProvider(
          create: (context) =>
              EmailVerificationCubit(getIt.get<AuthRepoImplementation>()),
          child: EmailVerificationView(email: state.extra as String),
        ),
      ),
      // GoRoute(
      //   path: emailVerified,
      //   builder: (context, state) => const EmailVerifiedView(),
      // ),
      GoRoute(path: root, builder: (context, state) => const Root()),
      GoRoute(path: home, builder: (context, state) => const HomeView()),

      GoRoute(
        path: students,
        builder: (context, state) => MultiBlocProvider(
          providers: [
            BlocProvider.value(value: getIt.get<CreateExamCubit>()),
            BlocProvider(
              create: (_) =>
                  GetMyClassesCubitCubit(getIt.get<MyClassesRepoImpl>()),
            ),
          ],
          child: const CreateExamPage(),
        ),
      ),
      GoRoute(
        path: examQuestions,
        builder: (context, state) => BlocProvider.value(
          value: getIt.get<CreateExamCubit>(),
          child: ExamQuestionsPage(defaultPoints: state.extra as int?),
        ),
      ),
      GoRoute(
        path: autoGrade,
        builder: (context, state) => const AutoGradeView(),
      ),
      GoRoute(
        path: studentRequests,
        builder: (context, state) => BlocProvider(
          create: (context) =>
              GetStudentsRequestsCubit(getIt.get<StudentRequestsRepoImpl>()),
          child: const StudentRequestsView(),
        ),
      ),
      GoRoute(
        path: studentProfile,
        builder: (context, state) => BlocProvider(
          create: (context) =>
              ApproveRejectRequestCubit(getIt.get<StudentRequestsRepoImpl>()),
          child: StudentProfile(from: state.extra as String),
        ),
      ),
      GoRoute(
        path: myClasses,
        builder: (context, state) => MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (context) =>
                  CreateClassCubit(getIt.get<MyClassesRepoImpl>()),
            ),
            BlocProvider(
              create: (context) =>
                  GetMyClassesCubitCubit(getIt.get<MyClassesRepoImpl>()),
            ),
          ],
          child: const MyClassesView(),
        ),
      ),
      GoRoute(
        path: studentsInClass,
        builder: (context, state) => const ClassStudentsView(),
      ),
    ],
  );
}
