import 'package:catalyst/core/widgets/custom_text.dart';
import 'package:catalyst/core/widgets/custom_textformfield.dart';
import 'package:flutter/material.dart';

class McqOptionsSection extends StatefulWidget {
  final List<TextEditingController> controllers;
  final Function(String?) onOptionsChanged;
  final VoidCallback onAddOption;
  final Function(int) onRemoveOption;
  final String? errorText;

  const McqOptionsSection({
    super.key,
    required this.controllers,
    required this.onOptionsChanged,
    required this.onAddOption,
    required this.onRemoveOption,
    this.errorText,
  });

  @override
  State<McqOptionsSection> createState() => _McqOptionsSectionState();
}

class _McqOptionsSectionState extends State<McqOptionsSection> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        CustomText(
          text: "Options",
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: Colors
              .white, // Note: Parent container might need dark background or this color needs changing if used on white
        ),
        const SizedBox(height: 12),
        Column(
          children: List.generate(
            widget.controllers.length,
            (index) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                children: [
                  Expanded(
                    child: CustomTextformfield(
                      controller: widget.controllers[index],
                      hintText: "Option ${index + 1}",
                      onChanged: (_) => widget.onOptionsChanged(null),
                    ),
                  ),
                  const SizedBox(width: 6),
                  if (widget.controllers.length > 2)
                    IconButton(
                      icon: const Icon(
                        Icons.remove_circle_outline,
                        color: Colors.red,
                      ),
                      onPressed: () => widget.onRemoveOption(index),
                    ),
                ],
              ),
            ),
          ),
        ),
        Align(
          alignment: Alignment.centerRight,
          child: TextButton.icon(
            onPressed: widget.onAddOption,
            icon: const Icon(Icons.add),
            label: const Text("Add option"),
          ),
        ),
        if (widget.errorText != null) ...[
          const SizedBox(height: 4),
          Text(
            widget.errorText!,
            style: const TextStyle(color: Colors.red, fontSize: 12),
          ),
        ],
      ],
    );
  }
}
