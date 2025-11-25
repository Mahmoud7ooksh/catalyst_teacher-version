import 'package:flutter/material.dart';
import 'package:catalyst/core/utils/app_colors.dart';
import 'package:catalyst/core/widgets/custom_text.dart';

class AddQuestionSheet extends StatelessWidget {
  const AddQuestionSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CustomText(
            text: "Add a Question",
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
          const SizedBox(height: 16),

          // 1) Add Manually
          _optionItem(
            icon: Icons.edit_note_outlined,
            label: "Add Manually",
            onTap: () {
              // 👈 نقفل الشيت ونرجّع نوع الاختيار
              Navigator.pop(context, 'manual');
            },
          ),

          // 2) Upload from File
          _optionItem(
            icon: Icons.upload_file_outlined,
            label: "Upload from File",
            onTap: () {
              Navigator.pop(context, 'file');
            },
          ),

          // 3) My Question Bank
          _optionItem(
            icon: Icons.folder_special_outlined,
            label: "Choose from My Question Bank",
            onTap: () {
              Navigator.pop(context, 'myBank');
            },
          ),

          // 4) Global Question Bank
          _optionItem(
            icon: Icons.public,
            label: "Choose from Global Question Bank",
            onTap: () {
              Navigator.pop(context, 'globalBank');
            },
          ),
        ],
      ),
    );
  }

  Widget _optionItem({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: AppColors.color1, size: 26),
      title: CustomText(text: label, fontSize: 15),
      onTap: onTap,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      hoverColor: AppColors.color3.withOpacity(0.2),
    );
  }
}
