import 'dart:ui';
import 'package:catalyst/core/widgets/custom_text.dart';
import 'package:catalyst/features/auth/presentation/widgets/custom_textformfield.dart';
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
    context.read<GetMyClassesCubitCubit>().getMyClasses();
  }

  void showAddClassDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.all(20),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.white.withOpacity(0.3)),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const CustomText(
                      text: "Add New Class",
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    const SizedBox(height: 16),
                    CustomTextformfield(
                      controller: context
                          .read<CreateClassCubit>()
                          .subjectController,
                      label: 'Subject',
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                            context
                                .read<CreateClassCubit>()
                                .subjectController
                                .clear();
                          },
                          child: const CustomText(
                            text: "Cancel",
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(width: 10),
                        ElevatedButton(
                          onPressed: () async {
                            await context
                                .read<CreateClassCubit>()
                                .createClass();
                            Navigator.pop(context);
                            context
                                .read<CreateClassCubit>()
                                .subjectController
                                .clear();
                            context
                                .read<GetMyClassesCubitCubit>()
                                .getMyClasses();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blueAccent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const CustomText(
                            text: "Add",
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<CreateClassCubit, CreateClassState>(
          listener: (context, state) {
            if (state is CreateClassSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Class created successfully')),
              );
              context.read<GetMyClassesCubitCubit>().getMyClasses();
            } else if (state is CreateClassError) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(state.message)));
            }
          },
        ),
      ],
      child: BlocConsumer<GetMyClassesCubitCubit, GetMyClassesCubitState>(
        listener: (context, state) {
          if (state is GetMyClassesCubitError) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        builder: (context, state) {
          if (state is GetMyClassesCubitLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is GetMyClassesCubitSuccess) {
            final lessons = state.response;

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
