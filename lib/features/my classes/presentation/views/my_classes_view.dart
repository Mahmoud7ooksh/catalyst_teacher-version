import 'package:catalyst/core/databases/cache/cache_helper.dart';
import 'package:catalyst/core/utils/app_colors.dart';
import 'package:catalyst/features/my%20classes/presentation/cubits/create%20class%20cubit/create_class_cubit.dart';
import 'package:catalyst/features/my%20classes/presentation/cubits/create%20class%20cubit/create_class_state.dart';
import 'package:catalyst/features/my%20classes/presentation/cubits/get%20my%20classes%20cubit/get_my_classes_cubit_cubit.dart';
import 'package:catalyst/features/my%20classes/presentation/cubits/get%20my%20classes%20cubit/get_my_classes_cubit_state.dart';
import 'package:catalyst/features/my%20classes/presentation/widgets/my_classes_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MyClassesView extends StatefulWidget {
  const MyClassesView({super.key});

  @override
  State<MyClassesView> createState() => _MyClassesViewState();
}

class _MyClassesViewState extends State<MyClassesView> {
  @override
  void initState() {
    super.initState();
    CacheHelper.getData(key: 'userId').then((userId) {
      if (userId != null && mounted) {
        context.read<GetMyClassesCubitCubit>().getMyClasses();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<CreateClassCubit, CreateClassState>(
          listenWhen: (previous, current) =>
              previous != current &&
              (current is CreateClassSuccess || current is CreateClassError),
          listener: (context, state) {
            if (state is CreateClassSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Class created successfully'),
                  backgroundColor: Colors.green,
                ),
              );
              context.read<GetMyClassesCubitCubit>().getMyClasses();
            } else if (state is CreateClassError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Failed to create class, try again'),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
        ),
      ],
      child: BlocConsumer<GetMyClassesCubitCubit, GetMyClassesCubitState>(
        listenWhen: (previous, current) =>
            previous != current && current is GetMyClassesCubitError,
        listener: (context, state) {
          if (state is GetMyClassesCubitError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Failed to load classes, try again'),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is GetMyClassesCubitLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is GetMyClassesCubitSuccess) {
            final lessons = state.response;

            // Check if the list is empty
            if (lessons.isEmpty) {
              return Stack(
                children: [
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.class_outlined,
                          size: 80,
                          color: AppColors.color1,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No classes',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: AppColors.color1,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Start by creating a new class',
                          style: TextStyle(
                            fontSize: 16,
                            color: AppColors.color1,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (context.watch<CreateClassCubit>().state
                      is CreateClassLoading)
                    const Center(child: CircularProgressIndicator()),
                ],
              );
            }

            return Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: ListView.builder(
                    itemCount: lessons.length,
                    itemBuilder: (context, index) {
                      final lesson = lessons[index];
                      return ClassItem(item: lesson);
                    },
                  ),
                ),
                if (context.watch<CreateClassCubit>().state
                    is CreateClassLoading)
                  const Center(child: CircularProgressIndicator()),
              ],
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}
