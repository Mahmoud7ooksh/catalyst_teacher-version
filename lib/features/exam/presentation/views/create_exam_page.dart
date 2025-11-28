import 'package:catalyst/core/utils/routs.dart';
import 'package:catalyst/core/widgets/custom_text.dart';
import 'package:catalyst/features/auth/presentation/widgets/custom_button.dart';
import 'package:catalyst/features/exam/data/models/exam_info_model.dart';
import 'package:catalyst/features/exam/presentation/cubits/create_exam_cubit/create_exam_cubit.dart';
import 'package:catalyst/features/exam/presentation/cubits/create_exam_cubit/create_exam_state.dart';
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

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  DateTime? _dateTime;

  String _selectedClass = 'Class 10-A';
  String _examType = 'Mid-Term';

  final Color boxColor = const Color(0xFFDCDEE1);

  bool _initialFilled = false; // عشان ما نعبيش الكنترولرز كل rebuild
  AutovalidateMode _autoValidateMode = AutovalidateMode.disabled;
  String? _dateTimeError;

  @override
  void initState() {
    super.initState();

    // أول ما الصفحة تفتح اطلب من الكيوبيد يجيب ExamInfo من Hive
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CreateExamCubit>().loadExamInfo();
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CreateExamCubit, CreateExamState>(
      listener: (context, state) {
        // لو حفظنا بنجاح ⇒ روح لصفحة الأسئلة
        if (state is CreateExamSuccess) {
          GoRouter.of(context).push(Routs.examQuestions);
        }

        if (state is CreateExamError) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
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
          _dateTime = info.scheduledAt;
          if (info.classIds.isNotEmpty) {
            _selectedClass = info.classIds.first;
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
                        _filledTextField(
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
                        _filledTextField(
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
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _label('Select Class'),
                                  _decoratedDropdown(
                                    DropdownButtonHideUnderline(
                                      child: DropdownButton<String>(
                                        value: _selectedClass,
                                        style: const TextStyle(
                                          color: Colors.black,
                                        ),
                                        items:
                                            [
                                                  'Class 10-A',
                                                  'Class 10-B',
                                                  'Class 11-A',
                                                ]
                                                .map(
                                                  (c) => DropdownMenuItem(
                                                    value: c,
                                                    child: Text(c),
                                                  ),
                                                )
                                                .toList(),
                                        onChanged: (v) =>
                                            setState(() => _selectedClass = v!),
                                        dropdownColor: Colors.white,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 12),

                            // Exam Type (UI فقط)
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _label('Exam Type'),
                                  _decoratedDropdown(
                                    DropdownButtonHideUnderline(
                                      child: DropdownButton<String>(
                                        value: _examType,
                                        style: const TextStyle(
                                          color: Colors.black,
                                        ),
                                        items: ['Mid-Term', 'Final', 'Quiz']
                                            .map(
                                              (c) => DropdownMenuItem(
                                                value: c,
                                                child: Text(c),
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
                          ],
                        ),

                        const SizedBox(height: 12),
                        _label('Date & Time'),
                        GestureDetector(
                          onTap: _pickDateTime,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 18,
                            ),
                            decoration: BoxDecoration(
                              color: boxColor,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: CustomText(
                                    text: _dateTime == null
                                        ? 'mm/dd/yyyy, --:--'
                                        : '${_dateTime!.month}/${_dateTime!.day}/${_dateTime!.year}, ${_dateTime!.hour.toString().padLeft(2, '0')}:${_dateTime!.minute.toString().padLeft(2, '0')}',
                                    color: Colors.black.withValues(alpha: 0.8),
                                  ),
                                ),
                                Icon(
                                  Icons.calendar_month_outlined,
                                  color: Colors.black.withValues(alpha: 0.8),
                                ),
                              ],
                            ),
                          ),
                        ),
                        if (_dateTimeError != null) ...[
                          const SizedBox(height: 4),
                          Text(
                            _dateTimeError!,
                            style: const TextStyle(
                              color: Colors.red,
                              fontSize: 12,
                            ),
                          ),
                        ],

                        const SizedBox(height: 12),
                        Row(
                          children: [
                            // Duration
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _label('Duration (mins)'),
                                  _filledTextField(
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
                                  _filledTextField(
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

    // validation على الـ DateTime
    setState(() {
      _dateTimeError = _dateTime == null
          ? 'Please select exam date & time'
          : null;

      // لو الفورم مش valid أول مرة، فعّل الـ autoValidate زي شاشة الـ Register
      if (!valid || _dateTimeError != null) {
        _autoValidateMode = AutovalidateMode.always;
      }
    });

    if (!valid || _dateTimeError != null) return;

    final examInfo = ExamInfo(
      title: _titleController.text.trim(),
      description: _descController.text.trim(),
      totalMarks: int.tryParse(_marksController.text.trim()),
      durationMinutes: int.tryParse(_durationController.text.trim()),
      scheduledAt: _dateTime,
      classIds: [_selectedClass],
    );

    context.read<CreateExamCubit>().saveExamInfo(examInfo);
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

  Widget _filledTextField({
    required TextEditingController controller,
    required String hint,
    int maxLines = 1,
    String? Function(String?)? validator,
    TextInputType? keyboardType,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: boxColor,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: TextFormField(
        controller: controller,
        maxLines: maxLines,
        keyboardType: keyboardType,
        style: const TextStyle(color: Colors.black87),
        validator: validator,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: Colors.black45),
          border: InputBorder.none,
        ),
      ),
    );
  }

  Widget _decoratedDropdown(Widget child) {
    return Container(
      decoration: BoxDecoration(
        color: boxColor,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: child,
    );
  }
}
