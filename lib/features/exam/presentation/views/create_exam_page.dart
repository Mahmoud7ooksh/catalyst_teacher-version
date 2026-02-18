import 'package:catalyst/core/utils/routs.dart';
import 'package:catalyst/core/widgets/custom_text.dart';
import 'package:catalyst/core/widgets/custom_button.dart';
import 'package:catalyst/features/exam/data/models/exam_info_model.dart';
import 'package:catalyst/features/exam/presentation/cubits/create_exam_cubit/create_exam_cubit.dart';
import 'package:catalyst/features/exam/presentation/cubits/create_exam_cubit/create_exam_state.dart';
import 'package:catalyst/features/exam/presentation/widgets/exam_date_picker.dart';
import 'package:catalyst/features/exam/presentation/widgets/exam_dropdown.dart';
import 'package:catalyst/features/exam/presentation/widgets/exam_form_field.dart';
import 'package:catalyst/features/my classes/presentation/cubits/get my classes cubit/get_my_classes_cubit_cubit.dart';
import 'package:catalyst/features/my classes/presentation/cubits/get my classes cubit/get_my_classes_cubit_state.dart';
import 'package:catalyst/features/my classes/data/models/get_my_classes.dart';
import 'package:catalyst/core/utils/vlidation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class CreateExamPage extends StatefulWidget {
  const CreateExamPage({super.key});

  @override
  State<CreateExamPage> createState() => _CreateExamPageState();
}

class _CreateExamPageState extends State<CreateExamPage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descController = TextEditingController();
  final TextEditingController _durationController = TextEditingController();
  final TextEditingController _marksController = TextEditingController();
  final TextEditingController _defaultPointsController =
      TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  DateTime? _dateTime;
  DateTime? _closingDate;
  List<Lesson> _availableClasses = [];
  Lesson? _selectedClass;
  String _examType = 'Midterm';

  bool _initialFilled = false; // عشان ما نعبيش الكنترولرز كل rebuild
  AutovalidateMode _autoValidateMode = AutovalidateMode.disabled;
  String? _dateTimeError;
  String? _closingDateError;

  @override
  void initState() {
    super.initState();

    // أول ما الصفحة تفتح اطلب من الكيوبيد يجيب ExamInfo من Hive
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final cubit = context.read<CreateExamCubit>();
      cubit.reset(); // Reset to clear any previous success states
      cubit.loadExamInfo();
      context.read<GetMyClassesCubitCubit>().getMyClasses();
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CreateExamCubit, CreateExamState>(
      listener: (context, state) {
        // لو حفظنا بنجاح ⇒ روح لصفحة الأسئلة
        if (state is CreateExamInfoSaved) {
          GoRouter.of(context).push(
            Routs.examQuestions,
            extra: int.tryParse(_defaultPointsController.text.trim()),
          );
        }

        if (state is CreateExamError) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
        }

        if (state is CreateExamFinalSuccess) {
          _titleController.clear();
          _descController.clear();
          _durationController.clear();
          _marksController.clear();
          _defaultPointsController.text = '1';
          _dateTime = null;
          _closingDate = null;
          _selectedClass = null;
          _initialFilled = false;
          _autoValidateMode = AutovalidateMode.disabled;
          setState(() {});
        }
      },
      builder: (context, state) {
        // أول ما يرجع ExamInfo من Hive نعبي الفورم مرة واحدة
        if (state is CreateExamInfoLoaded && !_initialFilled) {
          final info = state.examInfo;
          _titleController.text = info.title ?? '';
          _descController.text = info.description ?? '';
          _durationController.text = info.durationMinutes?.toString() ?? '';
          _marksController.text = info.totalMarks?.toString() ?? '';
          _defaultPointsController.text = info.defaultPoints?.toString() ?? '1';
          _dateTime = info.scheduledAt;
          _closingDate = info.closingDate;

          if (info.title == null &&
              info.description == null &&
              info.classIds.isEmpty) {
            // This means it was an empty ExamInfo from Repo (cache miss)
            // Explicitly reset selection just in case
            _selectedClass = null;
          } else if (info.classIds.isNotEmpty && _availableClasses.isNotEmpty) {
            try {
              _selectedClass = _availableClasses.firstWhere(
                (c) => c.id.toString() == info.classIds.first,
              );
            } catch (_) {
              // If not found, ignore or pick first
            }
          }
          _initialFilled = true;
        }

        return Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: ListView(
                children: [
                  const SizedBox(height: 12),
                  Form(
                    key: _formKey,
                    autovalidateMode: _autoValidateMode,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _label('Exam Title'),
                        ExamFormField(
                          controller: _titleController,
                          hint: 'e.g. Mid-Term Biology Test',
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Please enter exam title';
                            }
                            return null;
                          },
                        ),

                        const SizedBox(height: 12),
                        _label('Description'),
                        ExamFormField(
                          controller: _descController,
                          hint: 'Enter a brief description of the exam',
                          maxLines: 4,
                          // description هنا نخليها اختيارية
                          validator: (_) => null,
                        ),

                        const SizedBox(height: 12),

                        Row(
                          children: [
                            // Select Class
                            Expanded(
                              flex: 1,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _label('Select Class'),
                                  BlocConsumer<
                                    GetMyClassesCubitCubit,
                                    GetMyClassesCubitState
                                  >(
                                    listener: (context, state) {
                                      if (state is GetMyClassesCubitSuccess) {
                                        setState(() {
                                          _availableClasses = state.response;

                                          // Check if currently selected class exists in the new list
                                          final exists = _availableClasses.any(
                                            (c) => c == _selectedClass,
                                          );

                                          // If not selected or doesn't exist, pick the first one
                                          if (_availableClasses.isNotEmpty &&
                                              (_selectedClass == null ||
                                                  !exists)) {
                                            _selectedClass =
                                                _availableClasses.first;
                                          }
                                        });
                                      }
                                    },
                                    builder: (context, state) {
                                      if (state is GetMyClassesCubitSuccess) {
                                        _availableClasses = state.response;
                                      }
                                      if (state is GetMyClassesCubitLoading &&
                                          _availableClasses.isEmpty) {
                                        return const Center(
                                          child: SizedBox(
                                            height: 20,
                                            width: 20,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2,
                                            ),
                                          ),
                                        );
                                      }
                                      return ExamDropdown(
                                        child: DropdownButtonHideUnderline(
                                          child: DropdownButton<Lesson>(
                                            value:
                                                _availableClasses.any(
                                                  (c) =>
                                                      c.id ==
                                                      _selectedClass?.id,
                                                )
                                                ? _availableClasses.firstWhere(
                                                    (c) =>
                                                        c.id ==
                                                        _selectedClass?.id,
                                                  )
                                                : null,
                                            hint: const Text('Select Class'),
                                            isExpanded: true,
                                            style: const TextStyle(
                                              color: Colors.black,
                                            ),
                                            items: _availableClasses
                                                .map(
                                                  (c) => DropdownMenuItem(
                                                    value: c,
                                                    child: Text(
                                                      c.subject,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                  ),
                                                )
                                                .toList(),
                                            onChanged: (v) => setState(
                                              () => _selectedClass = v,
                                            ),
                                            dropdownColor: Colors.white,
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 12),

                            // Exam Type
                            Expanded(
                              flex: 1,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _label('Exam Type'),
                                  ExamDropdown(
                                    child: DropdownButtonHideUnderline(
                                      child: DropdownButton<String>(
                                        value: _examType,
                                        style: const TextStyle(
                                          color: Colors.black,
                                        ),
                                        items: ['Midterm', 'Final', 'Quiz']
                                            .map(
                                              (c) => DropdownMenuItem(
                                                value: c,
                                                child: Text(
                                                  c,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: const TextStyle(
                                                    fontSize: 12,
                                                  ),
                                                ),
                                              ),
                                            )
                                            .toList(),
                                        onChanged: (v) =>
                                            setState(() => _examType = v!),
                                        dropdownColor: Colors.white,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 12),

                            // Default Points
                            Expanded(
                              flex: 1,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _label('Def. Points'),
                                  ExamFormField(
                                    controller: _defaultPointsController,
                                    hint: '1',
                                    keyboardType: TextInputType.number,
                                    validator: (value) {
                                      if (value == null ||
                                          value.trim().isEmpty) {
                                        return 'Required';
                                      }
                                      final n = int.tryParse(value.trim());
                                      if (n == null || n <= 0) {
                                        return '> 0';
                                      }
                                      return null;
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 12),
                        _label('Date & Time'),
                        ExamDatePicker(
                          dateTime: _dateTime,
                          onTap: _pickDateTime,
                          errorText: _dateTimeError,
                        ),

                        const SizedBox(height: 12),
                        _label('Closing Date & Time'),
                        ExamDatePicker(
                          dateTime: _closingDate,
                          onTap: _pickClosingDateTime,
                          errorText: _closingDateError,
                        ),

                        const SizedBox(height: 12),
                        Row(
                          children: [
                            // Duration
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _label('Duration (mins)'),
                                  ExamFormField(
                                    controller: _durationController,
                                    hint: 'e.g. 60',
                                    keyboardType: TextInputType.number,
                                    validator: (value) {
                                      if (value == null ||
                                          value.trim().isEmpty) {
                                        return 'Please enter duration';
                                      }
                                      final n = int.tryParse(value.trim());
                                      if (n == null || n <= 0) {
                                        return 'Duration must be a positive number';
                                      }
                                      return null;
                                    },
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 12),

                            // Total Marks
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _label('Total Marks'),
                                  ExamFormField(
                                    controller: _marksController,
                                    hint: 'e.g. 100',
                                    keyboardType: TextInputType.number,
                                    validator: (value) {
                                      if (value == null ||
                                          value.trim().isEmpty) {
                                        return 'Please enter total marks';
                                      }
                                      final n = int.tryParse(value.trim());
                                      if (n == null || n <= 0) {
                                        return 'Marks must be a positive number';
                                      }
                                      return null;
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 25),

                        if (state is CreateExamLoading)
                          const Center(child: CircularProgressIndicator())
                        else
                          CustomButton(text: 'NEXT', onPressed: _onNextPressed),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _onNextPressed() {
    // شغل ال validators
    final valid = _formKey.currentState?.validate() ?? false;

    // validation على التواريخ
    setState(() {
      _dateTimeError = Validation.validateExamStartDate(_dateTime);
      _closingDateError = Validation.validateExamClosingDate(
        _closingDate,
        _dateTime,
      );

      if (!valid || _dateTimeError != null || _closingDateError != null) {
        _autoValidateMode = AutovalidateMode.always;
      }
    });

    if (!valid || _dateTimeError != null || _closingDateError != null) return;

    final examInfo = ExamInfo(
      title: _titleController.text.trim(),
      description: _descController.text.trim(),
      totalMarks: int.tryParse(_marksController.text.trim()),
      durationMinutes: int.tryParse(_durationController.text.trim()),
      scheduledAt: _dateTime,
      classIds: _selectedClass != null ? [_selectedClass!.id.toString()] : [],
      defaultPoints: int.tryParse(_defaultPointsController.text.trim()),
      examType: _examType,
      closingDate: _closingDate,
    );

    context.read<CreateExamCubit>().saveExamInfo(examInfo);
  }

  Future<void> _pickClosingDateTime() async {
    final d = await showDatePicker(
      context: context,
      initialDate: _closingDate ?? DateTime.now(),
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 365 * 2)),
    );
    if (d == null) return;
    final t = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_closingDate ?? DateTime.now()),
    );
    if (t == null) return;
    setState(() {
      _closingDate = DateTime(d.year, d.month, d.day, t.hour, t.minute);
    });
  }

  Future<void> _pickDateTime() async {
    final d = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 365 * 2)),
    );
    if (d == null) return;
    final t = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (t == null) return;
    setState(() {
      _dateTime = DateTime(d.year, d.month, d.day, t.hour, t.minute);
      _dateTimeError = null;
    });
  }

  Widget _label(String text) => Padding(
    padding: const EdgeInsets.only(bottom: 6.0),
    child: CustomText(text: text, fontWeight: FontWeight.w600),
  );
}
