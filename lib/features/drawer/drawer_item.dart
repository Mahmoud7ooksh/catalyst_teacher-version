import 'package:flutter/material.dart';
import 'package:catalyst/core/widgets/custom_text.dart';

class DrawerItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool hasDropdown;
  final VoidCallback? onTap;
  final Color? iconColor;
  final double? height;

  const DrawerItem({
    this.height,
    super.key,
    required this.icon,
    required this.label,
    this.onTap,
    this.hasDropdown = false,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height ?? 50,
      decoration: BoxDecoration(
        color: Color(0xFFDCDEE1).withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.25),
            offset: const Offset(0, 2),
            blurRadius: 2,
          ),
        ],
      ),

      child: Center(
        child: ListTile(
          leading: Icon(
            icon,
            color: iconColor ?? const Color(0xFF393E46), // 🔹 وردي فوشيا
            size: 30,
          ),
          title: CustomText(
            text: label,
            fontSize: 17,
            color: const Color(0xFF393E46), // 🔹 نص أبيض
            fontWeight: FontWeight.w500,
          ),
          trailing: hasDropdown
              ? const Icon(Icons.keyboard_arrow_down, color: Color(0xFF393E46))
              : null,
          onTap: onTap,
          visualDensity: VisualDensity.compact,
          hoverColor: Colors.white.withValues(
            alpha: (0.05), // تأثير بسيط عند الضغط
          ),
        ),
      ),
    );
  }
}
