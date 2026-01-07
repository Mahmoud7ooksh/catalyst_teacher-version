import 'package:hive/hive.dart';
part 'exam_info_model.g.dart';

@HiveType(typeId: 0)
class ExamInfo {
  @HiveField(0)
  final String? title;
  @HiveField(1)
  final String? description;
  @HiveField(2)
  final int? totalMarks;
  @HiveField(3)
  final int? durationMinutes;
  @HiveField(4)
  final DateTime? scheduledAt;

  @HiveField(5)
  final List<String> classIds;

  @HiveField(6)
  final int? defaultPoints;

  @HiveField(7)
  final String? examType;

  ExamInfo({
    this.title,
    this.description,
    this.totalMarks,
    this.durationMinutes,
    this.scheduledAt,
    this.classIds = const [],
    this.defaultPoints,
    this.examType,
  });

  factory ExamInfo.fromJson(Map<String, dynamic> json) {
    return ExamInfo(
      title: json['title'] as String?,
      description: json['description'] as String?,
      totalMarks: json['totalMarks'] as int?,
      durationMinutes: json['durationMinutes'] as int?,
      scheduledAt: json['scheduledAt'] != null
          ? DateTime.parse(json['scheduledAt'] as String)
          : null,
      classIds: (json['classIds'] as List?)?.cast<String>() ?? [],
      defaultPoints: json['defaultPoints'] as int?,
      examType: json['examType'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'totalMarks': totalMarks,
      'durationMinutes': durationMinutes,
      'scheduledAt': scheduledAt?.toIso8601String(),
      'classIds': classIds,
      'defaultPoints': defaultPoints,
      'examType': examType,
    };
  }
}
