import 'package:catalyst/features/exam/data/models/question_model.dart';
import 'package:flutter/material.dart';
import 'package:catalyst/core/utils/app_colors.dart';
import 'package:catalyst/core/widgets/custom_text.dart';

class AddQuestionDialog extends StatefulWidget {
  final void Function(Question question) onSubmit;

  const AddQuestionDialog({super.key, required this.onSubmit});

  @override
  State<AddQuestionDialog> createState() => _AddQuestionDialogState();
}

class _AddQuestionDialogState extends State<AddQuestionDialog> {
  final TextEditingController _questionController = TextEditingController();
  final TextEditingController _answerController = TextEditingController();
  QuestionType _selectedType = QuestionType.mcq;

  final List<TextEditingController> _optionControllers = [
    TextEditingController(),
    TextEditingController(),
  ];

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
    final parentContext = context;

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: const CustomText(text: "Add Question Manually"),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _questionController,
              decoration: const InputDecoration(
                labelText: "Question",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
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
                  if (_selectedType == QuestionType.mcq &&
                      _optionControllers.length < 2) {
                    _optionControllers.add(TextEditingController());
                    _optionControllers.add(TextEditingController());
                  }
                });
              },
            ),
            const SizedBox(height: 12),

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
                    });
                  },
                  icon: const Icon(Icons.add),
                  label: const Text("Add option"),
                ),
              ),
              const SizedBox(height: 8),
            ],

            TextField(
              controller: _answerController,
              decoration: const InputDecoration(
                labelText: "Answer",
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const CustomText(text: "Cancel"),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: AppColors.color1),
          onPressed: () {
            final qText = _questionController.text.trim();
            final aText = _answerController.text.trim();

            if (qText.isEmpty) {
              ScaffoldMessenger.of(parentContext).showSnackBar(
                const SnackBar(content: Text("Please enter the question")),
              );
              return;
            }

            List<String> options = [];
            if (_selectedType == QuestionType.mcq) {
              options = _optionControllers
                  .map((c) => c.text.trim())
                  .where((t) => t.isNotEmpty)
                  .toList();

              if (options.length < 2) {
                ScaffoldMessenger.of(parentContext).showSnackBar(
                  const SnackBar(
                    content: Text(
                      "MCQ must have at least two non-empty options",
                    ),
                  ),
                );
                return;
              }
            }

            if (aText.isEmpty) {
              ScaffoldMessenger.of(parentContext).showSnackBar(
                const SnackBar(content: Text("Please enter the answer")),
              );
              return;
            }

            final question = Question(
              id: DateTime.now().millisecondsSinceEpoch.toString(),
              text: qText,
              type: _selectedType,
              answer: aText,
              options: options,
            );

            widget.onSubmit(question);
          },
          child: const CustomText(text: "Add", color: Colors.white),
        ),
      ],
    );
  }
}
