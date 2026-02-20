class ExamDetailsEntity {
  final int id;
  final String examName;
  final int maxGrade;
  final String? closingDate;
  final List<StudentGradeEntity> students;
  final bool completed;

  ExamDetailsEntity({
    required this.id,
    required this.examName,
    required this.maxGrade,
    this.closingDate,
    required this.students,
    required this.completed,
  });
}

class StudentGradeEntity {
  final int id;
  final String? studentName;
  final double? grade;
  final bool verified;

  StudentGradeEntity({
    required this.id,
    this.studentName,
    this.grade,
    required this.verified,
  });
}
