import 'package:catalyst/core/utils/app_colors.dart';
import 'package:catalyst/core/widgets/custom_text.dart';
import 'package:flutter/material.dart';

class EmptyStateWidget extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;

  const EmptyStateWidget({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                color: AppColors.color1.withOpacity(0.05),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 84,
                color: AppColors.color1.withOpacity(0.8),
              ),
            ),
            const SizedBox(height: 24),
            CustomText(
              text: title,
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: AppColors.color1,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            CustomText(
              text: description,
              fontSize: 16,
              color: AppColors.text.withOpacity(0.7),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
