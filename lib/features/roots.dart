import 'package:catalyst/core/utils/app_colors.dart';
import 'package:catalyst/core/utils/service_locator.dart';
import 'package:catalyst/core/widgets/app_bar.dart';
import 'package:catalyst/core/widgets/base_scaffold.dart';
import 'package:catalyst/features/bubble_liquid_glass_navbar.dart';
import 'package:catalyst/features/drawer/drawer.dart';
import 'package:catalyst/features/home/presentation/views/home_view.dart';
import 'package:catalyst/features/my%20classes/presentation/cubits/create%20class%20cubit/create_class_cubit.dart';
import 'package:catalyst/features/my%20classes/data/repos/my_classes_repo_impl.dart';
import 'package:catalyst/features/my%20classes/presentation/cubits/get%20my%20classes%20cubit/get_my_classes_cubit_cubit.dart';
import 'package:catalyst/features/my%20classes/presentation/views/my_classes_view.dart';
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
    BlocProvider(
      create: (context) => CreateClassCubit(getIt.get<MyClassesRepoImpl>()),
      child: const MyClassesView(),
    ),
    const StudentRequestsView(),
    const CreateExamPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      appBar: CustomAppBar(
        title: items[_index].label,
        actions: [
          if (_index == 0)
            IconButton(icon: const Icon(Icons.notifications), onPressed: () {}),
          if (_index == 1)
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: const Text("Create New Class"),
                      content: TextField(
                        controller: context
                            .read<CreateClassCubit>()
                            .subjectController,
                        decoration: const InputDecoration(
                          labelText: "Class Name",
                          border: OutlineInputBorder(),
                        ),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text("Cancel"),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            final className = context
                                .read<CreateClassCubit>()
                                .subjectController
                                .text
                                .trim();
                            if (className.isNotEmpty) {
                              context.read<CreateClassCubit>().createClass();
                              context
                                  .read<GetMyClassesCubitCubit>()
                                  .getMyClasses();

                              Navigator.pop(context);
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("Please enter a class name"),
                                ),
                              );
                            }
                          },
                          child: const Text("Create"),
                        ),
                      ],
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
  }
}
