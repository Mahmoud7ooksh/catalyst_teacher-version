import 'package:catalyst/core/utils/app_colors.dart';
import 'package:catalyst/core/widgets/custom_text.dart';
import 'package:catalyst/features/my%20classes/data/models/create_class_model.dart';
import 'package:flutter/material.dart';

class AddScheduleDialog extends StatefulWidget {
  const AddScheduleDialog({super.key});

  @override
  State<AddScheduleDialog> createState() => _AddScheduleDialogState();
}

class _AddScheduleDialogState extends State<AddScheduleDialog> {
  String selectedDay = 'Monday';
  TimeOfDay selectedTime = const TimeOfDay(hour: 10, minute: 0);
  int duration = 60;

  final List<String> days = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday',
  ];

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const CustomText(
        text: 'add schedule',
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Day dropdown
            const CustomText(text: 'day', color: Colors.black, fontSize: 14),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              initialValue: selectedDay,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
              ),
              items: days.map((day) {
                return DropdownMenuItem(value: day, child: Text(day));
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() => selectedDay = value);
                }
              },
            ),
            const SizedBox(height: 16),

            // Time picker
            const CustomText(text: 'time', color: Colors.black, fontSize: 14),
            const SizedBox(height: 8),
            InkWell(
              onTap: () async {
                final time = await showTimePicker(
                  context: context,
                  initialTime: selectedTime,
                );
                if (time != null) {
                  setState(() => selectedTime = time);
                }
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 12,
                ),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${selectedTime.hour.toString().padLeft(2, '0')}:${selectedTime.minute.toString().padLeft(2, '0')}',
                      style: const TextStyle(color: Colors.black, fontSize: 16),
                    ),
                    const Icon(Icons.access_time, color: Colors.black),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Duration input
            const CustomText(
              text: 'Duration (minutes)',
              color: Colors.black,
              fontSize: 14,
            ),
            const SizedBox(height: 8),
            TextFormField(
              initialValue: duration.toString(),
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 12,
                ),
              ),
              onChanged: (value) {
                duration = int.tryParse(value) ?? 60;
              },
              style: const TextStyle(color: Colors.black),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const CustomText(text: 'إلغاء', color: Colors.black),
        ),
        ElevatedButton(
          onPressed: () {
            final schedule = LessonSchedule(
              day: selectedDay,
              duration: duration,
              startTime:
                  '${selectedTime.hour.toString().padLeft(2, '0')}:${selectedTime.minute.toString().padLeft(2, '0')}:00',
            );
            Navigator.pop(context, schedule);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.color1,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: const CustomText(text: 'إضافة', color: Colors.white),
        ),
      ],
    );
  }
}
