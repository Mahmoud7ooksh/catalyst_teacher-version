class ExamDetailsEntity {
  final int id;
  final String examName;
  final int maxGrade;
  final List<StudentGradeEntity> students;

  ExamDetailsEntity({
    required this.id,
    required this.examName,
    required this.maxGrade,
    required this.students,
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
