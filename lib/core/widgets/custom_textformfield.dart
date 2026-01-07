import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomTextformfield extends StatelessWidget {
  final TextEditingController controller;
  final String? label;
  final String? hintText;
  final IconData? icon;
  final bool isPassword;
  final FormFieldValidator<String>? validator;
  final Function(String)? onChanged;
  final TextInputType? keyboardType;

  const CustomTextformfield({
    super.key,
    required this.controller,
    this.label,
    this.hintText,
    this.icon,
    this.isPassword = false,
    this.validator,
    this.onChanged,
    this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    return isPassword ? buildPasswordTextField() : buildNormalTextField();
  }

  /// ===== Password Field =====
  Widget buildPasswordTextField() {
    final ValueNotifier<bool> isHidden = ValueNotifier<bool>(true);

    return ValueListenableBuilder<bool>(
      valueListenable: isHidden,
      builder: (context, value, _) {
        return TextFormField(
          cursorColor: Colors.black,
          validator: validator,
          controller: controller,
          obscureText: value,
          style: GoogleFonts.comfortaa(color: Colors.black, fontSize: 14),
          decoration: InputDecoration(
            filled: true,
            fillColor: const Color(0xFFDCDEE1),
            prefixIcon: Icon(icon, color: Colors.grey[700]),
            suffixIcon: IconButton(
              onPressed: () => isHidden.value = !isHidden.value,
              icon: Icon(
                value ? Icons.visibility_off : Icons.visibility,
                color: Colors.grey[700],
              ),
            ),

            labelText: label,
            labelStyle: GoogleFonts.comfortaa(
              color: Colors.grey[700],
              fontSize: 14,
            ),
            floatingLabelBehavior: FloatingLabelBehavior.auto,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide(color: Colors.grey.shade600, width: 1),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 18,
              vertical: 14,
            ),
          ),
          onChanged: onChanged,
        );
      },
    );
  }

  /// ===== Normal Field =====
  Widget buildNormalTextField() {
    return TextFormField(
      keyboardType: keyboardType,
      validator: validator,
      controller: controller,
      style: GoogleFonts.comfortaa(color: Colors.black, fontSize: 14),
      decoration: InputDecoration(
        filled: true,
        fillColor: const Color(0xFFDCDEE1),
        prefixIcon: Icon(icon, color: Colors.grey[700]),
        hintText: hintText,
        hintStyle: GoogleFonts.comfortaa(color: Colors.grey[700], fontSize: 14),
        labelText: label,
        labelStyle: GoogleFonts.comfortaa(
          color: Colors.grey[700],
          fontSize: 14,
        ),
        floatingLabelBehavior: FloatingLabelBehavior.auto,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(color: Colors.grey.shade600, width: 1),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 14,
        ),
      ),
      onChanged: onChanged,
    );
  }
}
