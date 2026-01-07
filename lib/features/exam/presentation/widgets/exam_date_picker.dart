import 'package:catalyst/core/widgets/custom_text.dart';
import 'package:flutter/material.dart';

class ExamDatePicker extends StatelessWidget {
  final DateTime? dateTime;
  final VoidCallback onTap;
  final Color boxColor;
  final String? errorText;

  const ExamDatePicker({
    super.key,
    required this.dateTime,
    required this.onTap,
    this.boxColor = const Color(0xFFDCDEE1),
    this.errorText,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 18),
            decoration: BoxDecoration(
              color: boxColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Expanded(
                  child: CustomText(
                    text: dateTime == null
                        ? 'mm/dd/yyyy, --:--'
                        : '${dateTime!.month}/${dateTime!.day}/${dateTime!.year}, ${dateTime!.hour.toString().padLeft(2, '0')}:${dateTime!.minute.toString().padLeft(2, '0')}',
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
        if (errorText != null) ...[
          const SizedBox(height: 4),
          Text(
            errorText!,
            style: const TextStyle(color: Colors.red, fontSize: 12),
          ),
        ],
      ],
    );
  }
}
