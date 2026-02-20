class VerifyStudentExamResponseModel {
  final bool success;
  final String message;

  VerifyStudentExamResponseModel({
    required this.success,
    required this.message,
  });

  factory VerifyStudentExamResponseModel.fromJson(Map<String, dynamic> json) {
    return VerifyStudentExamResponseModel(
      success: json['success'],
      message: json['message'],
    );
  }
}

class VerifyStudentExamRequestModel {
  final int answerId;
  final double mark;

  VerifyStudentExamRequestModel({required this.answerId, required this.mark});

  Map<String, dynamic> toJson() {
    return {'answerId': answerId, 'mark': mark};
  }
}
