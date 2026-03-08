import 'package:catalyst/core/utils/app_colors.dart';
import 'package:catalyst/core/widgets/custom_text.dart';
import 'package:catalyst/features/exam/data/models/question_model.dart';
import 'package:catalyst/features/exam/presentation/cubits/create_exam_cubit/create_exam_cubit.dart';
import 'package:catalyst/features/exam/presentation/cubits/create_exam_cubit/create_exam_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GenerateAIQuestionsSheet extends StatefulWidget {
  const GenerateAIQuestionsSheet({
    super.key,
    required this.examId,
    required this.onQuestionsGenerated,
  });

  final String examId;
  final ValueChanged<List<Question>> onQuestionsGenerated;

  @override
  State<GenerateAIQuestionsSheet> createState() =>
      _GenerateAIQuestionsSheetState();
}

class _GenerateAIQuestionsSheetState extends State<GenerateAIQuestionsSheet> {
  final _promptController = TextEditingController();

  @override
  void dispose() {
    _promptController.dispose();
    super.dispose();
  }

  void _onGenerate(BuildContext context) {
    final prompt = _promptController.text.trim();
    if (prompt.isEmpty) return;

    context.read<CreateExamCubit>().generateQuestionsWithAI(
      examId: widget.examId,
      userMessage: prompt,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CreateExamCubit, CreateExamState>(
      listener: (context, state) {
        if (state is GenerateAIQuestionsSuccess) {
          widget.onQuestionsGenerated(state.questions);
          Navigator.pop(context);
        } else if (state is CreateExamError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message), backgroundColor: Colors.red),
          );
          Navigator.pop(context);
        }
      },
      builder: (context, state) {
        final isLoading = state is GenerateAIQuestionsLoading;

        return Padding(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 20,
            bottom: MediaQuery.of(context).viewInsets.bottom + 24,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ---- Handle bar ----
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),

              // ---- Title ----
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.color1.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.auto_awesome,
                      color: AppColors.color1,
                      size: 22,
                    ),
                  ),
                  const SizedBox(width: 10),
                  const CustomText(
                    text: 'Generate Questions with AI',
                    fontWeight: FontWeight.bold,
                    fontSize: 17,
                  ),
                ],
              ),

              const SizedBox(height: 6),
              CustomText(
                text: 'Describe what questions you want the AI to generate.',
                fontSize: 13,
                color: Colors.grey.shade600,
              ),

              const SizedBox(height: 16),

              // ---- Prompt TextField ----
              TextField(
                controller: _promptController,
                enabled: !isLoading,
                maxLines: 4,
                decoration: InputDecoration(
                  hintText:
                      'e.g. Generate 5 MCQ questions from this lesson about photosynthesis...',
                  hintStyle: TextStyle(
                    fontSize: 13,
                    color: Colors.grey.shade400,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: AppColors.color1,
                      width: 1.5,
                    ),
                  ),
                  filled: true,
                  fillColor: Colors.grey.shade50,
                  contentPadding: const EdgeInsets.all(14),
                ),
              ),

              const SizedBox(height: 16),

              // ---- Generate Button ----
              SizedBox(
                height: 50,
                child: ElevatedButton(
                  onPressed: isLoading ? null : () => _onGenerate(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.color1,
                    disabledBackgroundColor: AppColors.color1.withOpacity(0.6),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: isLoading
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.5,
                            color: Colors.white,
                          ),
                        )
                      : const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.auto_awesome,
                              color: Colors.white,
                              size: 18,
                            ),
                            SizedBox(width: 8),
                            CustomText(
                              text: 'Generate',
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ],
                        ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
