import 'package:flutter/material.dart';

class ExamDropdown extends StatelessWidget {
  final Widget child;
  final Color boxColor;

  const ExamDropdown({
    super.key,
    required this.child,
    this.boxColor = const Color(0xFFDCDEE1),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: boxColor,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: child,
    );
  }
}
