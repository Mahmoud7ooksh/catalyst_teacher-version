import 'package:catalyst/core/utils/vlidation.dart';
import 'package:flutter/material.dart';
import 'package:catalyst/core/utils/app_colors.dart';
import 'package:catalyst/core/widgets/custom_text.dart';
import 'package:catalyst/features/exam/data/models/question_model.dart';

class AddQuestionDialog extends StatefulWidget {
  const AddQuestionDialog({
    super.key,
    required this.onSubmit,
    this.initialQuestion, // 👈 لو مش null يبقى إحنا بنعمل Edit
  });

  final void Function(Question question) onSubmit;
  final Question? initialQuestion;

  bool get isEditing => initialQuestion != null;

  @override
  State<AddQuestionDialog> createState() => _AddQuestionDialogState();
}

class _AddQuestionDialogState extends State<AddQuestionDialog> {
  final _formKey = GlobalKey<FormState>();
  AutovalidateMode _autoValidate = AutovalidateMode.disabled;

  final TextEditingController _questionController = TextEditingController();
  final TextEditingController _answerController = TextEditingController();
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

    // لو بنعدل سؤال قديم، نملى الـ fields
    final q = widget.initialQuestion;
    if (q != null) {
      _questionController.text = q.text;
      _answerController.text = q.answer;
      _selectedType = q.type;

      _optionControllers.clear();

      if (_selectedType == QuestionType.mcq) {
        // لو فيه اختيارات قديمة استخدمها
        if (q.options.isNotEmpty) {
          for (final opt in q.options) {
            _optionControllers.add(TextEditingController(text: opt));
          }
        } else {
          // احتياطي لو options فاضية
          _optionControllers.addAll([
            TextEditingController(),
            TextEditingController(),
          ]);
        }
      } else {
        // في باقي الأنواع مش محتاج options
        _optionControllers.addAll([
          TextEditingController(),
          TextEditingController(),
        ]);
      }
    }
  }

  @override
  void dispose() {
    _questionController.dispose();
    _answerController.dispose();
    for (final c in _optionControllers) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: CustomText(
        text: widget.isEditing ? "Edit Question" : "Add Question Manually",
      ),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          autovalidateMode: _autoValidate,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // ===== Question =====
              TextFormField(
                controller: _questionController,
                decoration: const InputDecoration(
                  labelText: "Question",
                  border: OutlineInputBorder(),
                ),
                validator: Validation.validateQuestion,
              ),
              const SizedBox(height: 12),

              // ===== Type =====
              DropdownButtonFormField<QuestionType>(
                initialValue: _selectedType,
                items: const [
                  DropdownMenuItem(value: QuestionType.mcq, child: Text('MCQ')),
                  DropdownMenuItem(
                    value: QuestionType.shortAnswer,
                    child: Text('Short Answer'),
                  ),
                  DropdownMenuItem(
                    value: QuestionType.trueFalse,
                    child: Text('True/False'),
                  ),
                ],
                decoration: const InputDecoration(
                  labelText: "Type",
                  border: OutlineInputBorder(),
                ),
                onChanged: (v) {
                  if (v == null) return;
                  setState(() {
                    _selectedType = v;
                    _optionsError = null;
                    _answerExtraError = null;
                  });
                },
              ),
              const SizedBox(height: 12),

              // ===== Options (MCQ) =====
              if (_selectedType == QuestionType.mcq) ...[
                Align(
                  alignment: Alignment.centerLeft,
                  child: CustomText(
                    text: "Options",
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                Column(
                  children: List.generate(
                    _optionControllers.length,
                    (index) => Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _optionControllers[index],
                              decoration: InputDecoration(
                                labelText: "Option ${index + 1}",
                                border: const OutlineInputBorder(),
                              ),
                              onChanged: (_) {
                                setState(() {
                                  _optionsError = Validation.validateMcqOptions(
                                    _optionControllers,
                                  );
                                  _answerExtraError = null;
                                  final options = _optionControllers
                                      .map((c) => c.text.trim())
                                      .toList();
                                  _answerExtraError =
                                      Validation.validateMcqAnswer(
                                        _answerController.text,
                                        options,
                                      );
                                });
                              },
                            ),
                          ),
                          const SizedBox(width: 6),
                          if (_optionControllers.length > 2)
                            IconButton(
                              icon: const Icon(
                                Icons.remove_circle_outline,
                                color: Colors.red,
                              ),
                              onPressed: () {
                                setState(() {
                                  _optionControllers.removeAt(index);
                                  _optionsError = Validation.validateMcqOptions(
                                    _optionControllers,
                                  );
                                });
                              },
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton.icon(
                    onPressed: () {
                      setState(() {
                        _optionControllers.add(TextEditingController());
                        _optionsError = Validation.validateMcqOptions(
                          _optionControllers,
                        );
                      });
                    },
                    icon: const Icon(Icons.add),
                    label: const Text("Add option"),
                  ),
                ),
                if (_optionsError != null) ...[
                  const SizedBox(height: 4),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      _optionsError!,
                      style: const TextStyle(color: Colors.red, fontSize: 12),
                    ),
                  ),
                ],
                const SizedBox(height: 8),
              ],

              // ===== Answer =====
              TextFormField(
                controller: _answerController,
                decoration: const InputDecoration(
                  labelText: "Answer",
                  border: OutlineInputBorder(),
                ),
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
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const CustomText(text: "Cancel"),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: AppColors.color1),
          onPressed: _onSubmitPressed,
          child: CustomText(
            text: widget.isEditing ? "Update" : "Add",
            color: Colors.white,
          ),
        ),
      ],
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
    );

    widget.onSubmit(question);
  }
}
