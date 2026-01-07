import 'package:catalyst/core/widgets/custom_textformfield.dart';
import 'package:catalyst/features/exam/presentation/widgets/mcq_options_section.dart';
import 'package:flutter/material.dart';
import 'package:catalyst/core/widgets/custom_dialog.dart';
import 'package:catalyst/core/utils/vlidation.dart';
import 'package:catalyst/core/utils/app_colors.dart';
import 'package:catalyst/core/widgets/custom_text.dart';
import 'package:catalyst/features/exam/data/models/question_model.dart';

class AddQuestionDialog extends StatefulWidget {
  const AddQuestionDialog({
    super.key,
    required this.onSubmit,
    this.initialQuestion,
    this.defaultPoints,
  });

  final void Function(Question question) onSubmit;
  final Question? initialQuestion;
  final int? defaultPoints;

  bool get isEditing => initialQuestion != null;

  @override
  State<AddQuestionDialog> createState() => _AddQuestionDialogState();
}

class _AddQuestionDialogState extends State<AddQuestionDialog> {
  final _formKey = GlobalKey<FormState>();
  AutovalidateMode _autoValidate = AutovalidateMode.disabled;

  final TextEditingController _questionController = TextEditingController();
  final TextEditingController _answerController = TextEditingController();
  final TextEditingController _pointsController = TextEditingController();
  QuestionType _selectedType = QuestionType.mcq;

  final List<TextEditingController> _optionControllers = [
    TextEditingController(),
    TextEditingController(),
  ];

  String? _optionsError;
  String? _answerExtraError;

  @override
  void initState() {
    super.initState();

    final q = widget.initialQuestion;
    if (q != null) {
      _questionController.text = q.text;
      _answerController.text = q.answer;
      _pointsController.text = q.points.toString();
      _selectedType = q.type;

      _optionControllers.clear();

      if (_selectedType == QuestionType.mcq) {
        if (q.options.isNotEmpty) {
          for (final opt in q.options) {
            _optionControllers.add(TextEditingController(text: opt));
          }
        } else {
          _optionControllers.addAll([
            TextEditingController(),
            TextEditingController(),
          ]);
        }
      } else {
        _optionControllers.addAll([
          TextEditingController(),
          TextEditingController(),
        ]);
      }
    } else {
      _pointsController.text = widget.defaultPoints?.toString() ?? '1';
    }
  }

  @override
  void dispose() {
    _questionController.dispose();
    _answerController.dispose();
    _pointsController.dispose();
    for (final c in _optionControllers) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomDialog(
      padding: const EdgeInsets.all(18),
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          autovalidateMode: _autoValidate,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // title
              Row(
                children: [
                  Expanded(
                    child: CustomText(
                      text: widget.isEditing
                          ? "Edit Question"
                          : "Add Question Manually",
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Question
              CustomTextformfield(
                hintText: "Question",
                controller: _questionController,
                validator: Validation.validateQuestion,
              ),
              const SizedBox(height: 12),
              CustomTextformfield(
                hintText: "Points",
                controller: _pointsController,
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) return "Required";
                  if (int.tryParse(value) == null) return "Invalid number";
                  return null;
                },
              ),
              const SizedBox(height: 24),

              // Question Type & Options Container
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black26, width: 1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Type
                    DropdownButtonFormField<QuestionType>(
                      initialValue: _selectedType,
                      items: const [
                        DropdownMenuItem(
                          value: QuestionType.mcq,
                          child: Text('MCQ'),
                        ),
                        DropdownMenuItem(
                          value: QuestionType.shortAnswer,
                          child: Text('Short Answer'),
                        ),
                        DropdownMenuItem(
                          value: QuestionType.trueFalse,
                          child: Text('True/False'),
                        ),
                      ],
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: const Color(0xFFDCDEE1),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      onChanged: (v) {
                        if (v == null) return;
                        setState(() {
                          _selectedType = v;
                          _optionsError = null;
                          _answerExtraError = null;

                          // ensure controllers exist for mcq
                          if (_selectedType == QuestionType.mcq &&
                              _optionControllers.isEmpty) {
                            _optionControllers.addAll([
                              TextEditingController(),
                              TextEditingController(),
                            ]);
                          }
                        });
                      },
                    ),

                    // Options (MCQ)
                    if (_selectedType == QuestionType.mcq)
                      McqOptionsSection(
                        controllers: _optionControllers,
                        errorText: _optionsError,
                        onAddOption: () {
                          setState(() {
                            _optionControllers.add(TextEditingController());
                            _optionsError = Validation.validateMcqOptions(
                              _optionControllers,
                            );
                          });
                        },
                        onRemoveOption: (index) {
                          setState(() {
                            _optionControllers.removeAt(index);
                            _optionsError = Validation.validateMcqOptions(
                              _optionControllers,
                            );
                          });
                        },
                        onOptionsChanged: (_) {
                          setState(() {
                            _optionsError = Validation.validateMcqOptions(
                              _optionControllers,
                            );
                            _answerExtraError = null;
                            final options = _optionControllers
                                .map((c) => c.text.trim())
                                .toList();
                            _answerExtraError = Validation.validateMcqAnswer(
                              _answerController.text,
                              options,
                            );
                          });
                        },
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Answer
              CustomTextformfield(
                hintText: "Answer",
                controller: _answerController,
                validator: (value) {
                  if (_selectedType == QuestionType.trueFalse) {
                    return Validation.validateTrueFalseAnswer(value);
                  }
                  return Validation.validateAnswer(value);
                },
                onChanged: (_) {
                  if (_selectedType == QuestionType.mcq) {
                    setState(() {
                      final options = _optionControllers
                          .map((c) => c.text.trim())
                          .toList();
                      _answerExtraError = Validation.validateMcqAnswer(
                        _answerController.text,
                        options,
                      );
                    });
                  } else {
                    setState(() {
                      _answerExtraError = null;
                    });
                  }
                },
              ),
              if (_answerExtraError != null) ...[
                const SizedBox(height: 4),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    _answerExtraError!,
                    style: const TextStyle(color: Colors.red, fontSize: 12),
                  ),
                ),
              ],

              const SizedBox(height: 14),

              // Actions
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const CustomText(text: "Cancel"),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.color1,
                    ),
                    onPressed: _onSubmitPressed,
                    child: CustomText(
                      text: widget.isEditing ? "Update" : "Add",
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onSubmitPressed() {
    setState(() {
      _optionsError = null;
      _answerExtraError = null;
    });

    final isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid) {
      setState(() {
        _autoValidate = AutovalidateMode.always;
      });
      return;
    }

    final qText = _questionController.text.trim();
    final aText = _answerController.text.trim();
    List<String> options = [];

    if (_selectedType == QuestionType.mcq) {
      final optError = Validation.validateMcqOptions(_optionControllers);
      final optList = _optionControllers.map((c) => c.text.trim()).toList();
      final ansError = Validation.validateMcqAnswer(aText, optList);

      if (optError != null || ansError != null) {
        setState(() {
          _optionsError = optError;
          _answerExtraError = ansError;
          _autoValidate = AutovalidateMode.always;
        });
        return;
      }

      options = optList;
    }

    final question = Question(
      id:
          widget.initialQuestion?.id ??
          DateTime.now().millisecondsSinceEpoch.toString(),
      text: qText,
      type: _selectedType,
      answer: aText,
      options: options,
      points: int.tryParse(_pointsController.text) ?? 1,
    );

    widget.onSubmit(question);
  }
}
