import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomText extends StatelessWidget {
  const CustomText({
    super.key,
    required this.text,
    this.fontSize,
    this.fontWeight,
    this.color,
    this.letterSpacing,
    this.textAlign,
  });

  final String text;
  final double? fontSize;
  final FontWeight? fontWeight;
  final Color? color;
  final double? letterSpacing;
  final TextAlign? textAlign;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlign,
      style: GoogleFonts.comfortaa(
        color: color ?? Colors.black,
        fontSize: fontSize ?? 16,
        fontWeight: fontWeight ?? FontWeight.normal,
        letterSpacing: letterSpacing ?? 0,
      ),
    );
  }
}
