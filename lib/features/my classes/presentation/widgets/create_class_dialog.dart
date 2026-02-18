import 'package:catalyst/core/utils/app_colors.dart';
import 'package:catalyst/core/widgets/custom_text.dart';
import 'package:catalyst/core/widgets/custom_textformfield.dart';
import 'package:catalyst/features/my%20classes/data/models/create_class_model.dart';
import 'package:catalyst/features/my%20classes/presentation/cubits/create%20class%20cubit/create_class_cubit.dart';
import 'package:catalyst/features/my%20classes/presentation/cubits/create%20class%20cubit/create_class_state.dart';
import 'package:catalyst/features/my%20classes/presentation/cubits/get%20my%20classes%20cubit/get_my_classes_cubit_cubit.dart';
import 'package:catalyst/features/my%20classes/presentation/widgets/add_schedule_dialog.dart';
import 'package:catalyst/features/my%20classes/presentation/widgets/schedule_item_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CreateClassDialog extends StatefulWidget {
  const CreateClassDialog({super.key});

  @override
  State<CreateClassDialog> createState() => _CreateClassDialogState();
}

class _CreateClassDialogState extends State<CreateClassDialog> {
  @override
  Widget build(BuildContext context) {
    final cubit = context.read<CreateClassCubit>();
    final getMyClassesCubit = context.read<GetMyClassesCubitCubit>();

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.8,
          maxWidth: MediaQuery.of(context).size.width * 0.9,
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            const CustomText(
              text: "Create New Class",
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
            const SizedBox(height: 20),

            // Scrollable content
            Flexible(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Subject input
                    CustomTextformfield(
                      controller: cubit.subjectController,
                      label: 'Subject Name',
                      hintText: 'e.g. Mathematics',
                      icon: Icons.book,
                    ),

                    const SizedBox(height: 20),

                    // Add Schedule Section
                    _label('Lesson Schedules'),
                    GestureDetector(
                      onTap: () async {
                        final schedule = await showDialog<LessonSchedule>(
                          context: context,
                          builder: (_) => const AddScheduleDialog(),
                        );
                        if (schedule != null) {
                          setState(() {
                            cubit.addSchedule(schedule);
                          });
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 18,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.color3,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.add_circle_outline,
                                size: 26,
                                color: AppColors.color1,
                              ),
                              const SizedBox(height: 6),
                              CustomText(
                                text: 'Add Schedule',
                                color: AppColors.color1,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Schedules list
                    if (cubit.lessonSchedules.isNotEmpty)
                      ...cubit.lessonSchedules.asMap().entries.map((entry) {
                        return ScheduleItemWidget(
                          schedule: entry.value,
                          onDelete: () {
                            setState(() {
                              cubit.removeSchedule(entry.key);
                            });
                          },
                        );
                      }),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Buttons
            BlocConsumer<CreateClassCubit, CreateClassState>(
              listener: (context, state) {
                if (state is CreateClassSuccess) {
                  Navigator.pop(context);
                  cubit.subjectController.clear();
                  cubit.lessonSchedules.clear();
                  getMyClassesCubit.getMyClasses(forceRefresh: true);
                }
              },
              builder: (context, state) {
                if (state is CreateClassLoading) {
                  return const Center(child: CircularProgressIndicator());
                }
                return Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {
                        cubit.subjectController.clear();
                        cubit.lessonSchedules.clear();
                        Navigator.pop(context);
                      },
                      child: const CustomText(
                        text: "CANCEL",
                        color: Colors.black54,
                      ),
                    ),
                    const SizedBox(width: 12),
                    ElevatedButton(
                      onPressed: () async {
                        await cubit.createClass();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.color1,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const CustomText(
                        text: "CREATE",
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _label(String text) => Padding(
    padding: const EdgeInsets.only(bottom: 6.0),
    child: CustomText(
      text: text,
      fontWeight: FontWeight.w600,
      color: Colors.black,
    ),
  );
}
