import 'package:catalyst/core/utils/app_colors.dart';
import 'package:catalyst/core/widgets/app_bar.dart';
import 'package:catalyst/core/widgets/base_scaffold.dart';
import 'package:catalyst/core/widgets/custom_text.dart';
import 'package:catalyst/core/widgets/custom_button.dart';
import 'package:catalyst/core/widgets/custom_textformfield.dart';
import 'package:catalyst/features/my%20classes/data/models/create_class_model.dart';
import 'package:catalyst/features/my%20classes/presentation/cubits/create%20class%20cubit/create_class_cubit.dart';
import 'package:catalyst/features/my%20classes/presentation/cubits/create%20class%20cubit/create_class_state.dart';
import 'package:catalyst/features/my%20classes/presentation/widgets/add_schedule_dialog.dart';
import 'package:catalyst/features/my%20classes/presentation/widgets/schedule_item_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CreateClassPage extends StatefulWidget {
  const CreateClassPage({super.key});

  @override
  State<CreateClassPage> createState() => _CreateClassPageState();
}

class _CreateClassPageState extends State<CreateClassPage> {
  final Color boxColor = const Color(0xFFDCDEE1);

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<CreateClassCubit>();

    return BlocConsumer<CreateClassCubit, CreateClassState>(
      listener: (context, state) {
        if (state is CreateClassSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('تم إنشاء الكلاس بنجاح ✓'),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.pop(context);
        }

        if (state is CreateClassError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message), backgroundColor: Colors.red),
          );
        }
      },
      builder: (context, state) {
        return BaseScaffold(
          appBar: CustomAppBar(
            title: 'Create Class',
            leading: GestureDetector(
              onTap: () {
                cubit.subjectController.clear();
                cubit.lessonSchedules.clear();
                Navigator.pop(context);
              },
              child: const Icon(
                Icons.arrow_back,
                color: Colors.white,
                size: 24,
              ),
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: ListView(
                children: [
                  const SizedBox(height: 12),

                  // Subject input
                  _label('Subject Name'),
                  CustomTextformfield(
                    controller: cubit.subjectController,
                    label: 'e.g. Mathematics',
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

                  const SizedBox(height: 25),

                  // Create button
                  if (state is CreateClassLoading)
                    const Center(child: CircularProgressIndicator())
                  else
                    CustomButton(
                      text: 'CREATE CLASS',
                      onPressed: () async {
                        await cubit.createClass();
                      },
                    ),

                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _label(String text) => Padding(
    padding: const EdgeInsets.only(bottom: 6.0),
    child: CustomText(text: text, fontWeight: FontWeight.w600),
  );
}
