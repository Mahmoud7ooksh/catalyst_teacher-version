import 'package:catalyst/core/utils/routs.dart';
import 'package:catalyst/core/widgets/custom_text.dart';
import 'package:catalyst/core/widgets/glass_books.dart';
import 'package:catalyst/features/auth/presentation/widgets/custom_button.dart';
import 'package:catalyst/features/my%20classes/data/models/get_my_classes.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ClassItem extends StatelessWidget {
  const ClassItem({super.key, required this.item});

  final Lesson item;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: CustomBox(
        shadowOffset: const Offset(0, 6),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 22,
                  backgroundColor: Colors.blue.withValues(alpha: 0.15),
                  child: Icon(Icons.school, color: Colors.blue),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomText(
                        text: item.subject,
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                      ),
                      const SizedBox(height: 2),
                      CustomText(
                        text: item.studentsCount.toString(),
                        color: Colors.black,
                        fontSize: 13,
                      ),
                      const SizedBox(height: 2),
                    ],
                  ),
                ),
                CircleAvatar(
                  radius: 20,
                  backgroundImage: NetworkImage(
                    "https://images.unsplash.com/photo-1544005313-94ddf0286df2?auto=format&fit=crop&w=400&q=80",
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            const Divider(color: Colors.black, thickness: 1),
            const SizedBox(height: 6),
            CustomText(
              text: '2025-11-05 10:00 AM - 11:00 AM',
              color: Colors.black,
              fontSize: 12,
            ),
            const SizedBox(height: 18),
            CustomButton(
              text: 'View Details',
              onPressed: () => GoRouter.of(context).push(Routs.studentsInClass),
            ),
          ],
        ),
      ),
    );
  }
}
