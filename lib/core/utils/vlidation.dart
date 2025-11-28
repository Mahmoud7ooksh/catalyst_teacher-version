import 'package:flutter/material.dart';

abstract class Validation {
  // ===== Email =====
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email';
    }

    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      return 'Enter a valid email address';
    }

    return null;
  }

  // ===== Password =====
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your password';
    }

    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }

    return null;
  }

  // ===== Confirm Password =====
  static String? validateConfirmPassword(String? value, String password) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }

    if (value != password) {
      return 'Passwords do not match';
    }

    return null;
  }

  // ===== Name =====
  static String? validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter your name';
    }

    if (value.length < 2) {
      return 'Name must be at least 2 characters';
    }

    return null;
  }

  // ===== Phone =====
  static String? validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your phone number';
    }

    final phoneRegex = RegExp(r'^\+?\d{10,13}$');
    if (!phoneRegex.hasMatch(value)) {
      return 'Enter a valid phone number';
    }

    return null;
  }

  // ===== Address =====
  static String? validateAddress(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter your address';
    }

    return null;
  }

  static String? validateQuestion(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Question is required';
    }
    if (value.trim().length < 5) {
      return 'Question is too short';
    }
    return null;
  }

  static String? validateAnswer(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Answer is required';
    }
    return null;
  }

  // يتحقق من:
  // - كل الخيارات مش فاضية
  // - على الأقل خيارين
  // - مفيش تكرار
  static String? validateMcqOptions(List<TextEditingController> controllers) {
    final options = controllers.map((c) => c.text.trim()).toList();

    if (options.any((o) => o.isEmpty)) {
      return 'All options are required';
    }

    if (options.length < 2) {
      return 'At least two options are required';
    }

    if (options.toSet().length != options.length) {
      return 'Options must be unique (no duplicates)';
    }

    return null;
  }

  // يتحقق إن الإجابة واحدة من الاختيارات بالظبط
  static String? validateMcqAnswer(String answer, List<String> options) {
    final trimmedAnswer = answer.trim();
    if (trimmedAnswer.isEmpty) {
      return 'Answer is required';
    }
    if (!options.contains(trimmedAnswer)) {
      return 'Answer must be exactly one of the options';
    }
    return null;
  }

  // اختياري: لو عايز تضبط True/False
  static String? validateTrueFalseAnswer(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Answer is required';
    }
    final v = value.trim().toLowerCase();
    if (v != 'true' && v != 'false') {
      return 'Answer must be True or False';
    }
    return null;
  }
}
