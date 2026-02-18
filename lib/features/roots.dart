import 'package:catalyst/core/utils/app_colors.dart';
import 'package:catalyst/core/utils/service_locator.dart';
import 'package:catalyst/core/widgets/app_bar.dart';
import 'package:catalyst/core/widgets/base_scaffold.dart';

import 'package:catalyst/features/bubble_liquid_glass_navbar.dart';
import 'package:catalyst/features/drawer/drawer.dart';
import 'package:catalyst/features/exam/presentation/cubits/create_exam_cubit/create_exam_cubit.dart';
import 'package:catalyst/features/home/presentation/views/home_view.dart';
import 'package:catalyst/features/my%20classes/presentation/cubits/create%20class%20cubit/create_class_cubit.dart';
import 'package:catalyst/features/my%20classes/data/repos/my_classes_repo_impl.dart';
import 'package:catalyst/features/my%20classes/presentation/cubits/get%20my%20classes%20cubit/get_my_classes_cubit_cubit.dart';
import 'package:catalyst/features/my%20classes/presentation/views/my_classes_view.dart';
import 'package:catalyst/features/my%20classes/presentation/widgets/create_class_dialog.dart';
import 'package:catalyst/features/student%20requests/data/repos/student_requests_repo_impl.dart';
import 'package:catalyst/features/student%20requests/presentation/cubits/approve%20reject%20request/approve_reject_request_cubit.dart';
import 'package:catalyst/features/student%20requests/presentation/cubits/get%20students%20requests%20cubit/get_students_requests_cubit.dart';
import 'package:catalyst/features/student%20requests/presentation/views/student_requests.dart';
import 'package:catalyst/features/exam/presentation/views/create_exam_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
//import 'package:liquid_glass_navbar/liquid_glass_navbar.dart';

class Root extends StatefulWidget {
  const Root({super.key});

  @override
  State<Root> createState() => _RootState();
}

class _RootState extends State<Root> {
  int _index = 0;

  final items = [
    LiquidGlassNavItem(icon: Icons.home, label: "Home"),
    LiquidGlassNavItem(icon: Icons.class_, label: "My Classes"),
    LiquidGlassNavItem(icon: Icons.person, label: "Student Req"),
    LiquidGlassNavItem(icon: Icons.add, label: "Create Exam"),
  ];

  final pages = [
    const HomeView(),
    const MyClassesView(),
    MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) =>
              GetStudentsRequestsCubit(getIt.get<StudentRequestsRepoImpl>()),
        ),
        BlocProvider(
          create: (context) =>
              ApproveRejectRequestCubit(getIt.get<StudentRequestsRepoImpl>()),
        ),
      ],
      child: const StudentRequestsView(),
    ),
    BlocProvider.value(
      value: getIt.get<CreateExamCubit>(),
      child: const CreateExamPage(),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => CreateClassCubit(getIt.get<MyClassesRepoImpl>()),
        ),
        BlocProvider(
          create: (context) =>
              GetMyClassesCubitCubit(getIt.get<MyClassesRepoImpl>()),
        ),
      ],
      child: Builder(
        builder: (context) {
          return BaseScaffold(
            appBar: CustomAppBar(
              title: items[_index].label,
              actions: [
                if (_index == 0)
                  IconButton(
                    icon: const Icon(Icons.notifications),
                    onPressed: () {},
                  ),
                if (_index == 1)
                  IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: () {
                      final cubit = context.read<CreateClassCubit>();
                      final getMyClassesCubit = context
                          .read<GetMyClassesCubitCubit>();

                      showDialog(
                        context: context,
                        builder: (_) {
                          return MultiBlocProvider(
                            providers: [
                              BlocProvider.value(value: cubit),
                              BlocProvider.value(value: getMyClassesCubit),
                            ],
                            child: const CreateClassDialog(),
                          );
                        },
                      );
                    },
                  ),
                if (_index == 2)
                  IconButton(icon: const Icon(Icons.add), onPressed: () {}),
                if (_index == 3)
                  IconButton(icon: const Icon(Icons.add), onPressed: () {}),
              ],
            ),
            drawer: const CustomDrawer(),
            child: LiquidGlassNavBar(
              bubbleColor: Colors.white,
              backgroundColor: AppColors.color1,
              backgroundOpacity: 0.9,
              itemColor: Colors.white,
              currentIndex: _index,
              onPageChanged: (i) => setState(() => _index = i),
              pages: pages,
              items: items,
              bottomPadding: 16,
              horizontalPadding: 16,
              bubbleBorderWidth: 1,
              bubbleOpacity: 0.4,
            ),
          );
        },
      ),
    );
  }
}
