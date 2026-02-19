class TeacherExamModel {
  final int id;
  final String examName;
  final String examType;
  final DateTime examDateTime;
  final int durationMinutes;

  TeacherExamModel({
    required this.id,
    required this.examName,
    required this.examType,
    required this.examDateTime,
    required this.durationMinutes,
  });

  factory TeacherExamModel.fromJson(Map<String, dynamic> json) {
    return TeacherExamModel(
      id: json['id'],
      examName: json['examName'],
      examType: json['examType'],
      examDateTime: DateTime.parse(json['examDateTime']),
      durationMinutes: json['durationMinutes'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'examName': examName,
      'examType': examType,
      'examDateTime': examDateTime.toIso8601String(),
      'durationMinutes': durationMinutes,
    };
  }
}
