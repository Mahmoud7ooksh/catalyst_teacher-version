import 'package:flutter/material.dart';
import 'package:catalyst/core/utils/app_colors.dart';

class CustomBox extends StatelessWidget {
  final Widget child;
  final double borderRadius;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry? margin;
  final Color? backgroundColor;
  final double blurRadius;
  final double spreadRadius;
  final Offset shadowOffset;
  final double? height;
  final double? width;

  const CustomBox({
    super.key,
    required this.child,
    this.borderRadius = 16,
    this.padding = const EdgeInsets.all(16),
    this.margin,
    this.backgroundColor,
    this.blurRadius = 12,
    this.spreadRadius = 0,
    this.shadowOffset = const Offset(0, 4),
    this.height,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      margin: margin ?? const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: backgroundColor ?? AppColors.color3, // نفس لون الهوم
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: blurRadius,
            spreadRadius: spreadRadius,
            offset: shadowOffset,
          ),
        ],
      ),
      padding: padding,
      child: child,
    );
  }
}
