import 'package:flutter/material.dart';
import 'package:catalyst/core/widgets/custom_button.dart';

class CreateExamSection extends StatelessWidget {
  const CreateExamSection({super.key, required this.onCreateExam});

  final VoidCallback onCreateExam;

  @override
  Widget build(BuildContext context) {
    return CustomButton(text: 'Create Exam', onPressed: onCreateExam);
  }
}
