class StudentExamAnswersResponseModel {
  final bool success;
  final String message;
  final StudentExamAnswersDataModel data;

  StudentExamAnswersResponseModel({
    required this.success,
    required this.message,
    required this.data,
  });

  factory StudentExamAnswersResponseModel.fromJson(Map<String, dynamic> json) {
    return StudentExamAnswersResponseModel(
      success: json['success'],
      message: json['message'],
      data: StudentExamAnswersDataModel.fromJson(json['data']),
    );
  }
}

class StudentExamAnswersDataModel {
  final String? studentName;
  final double? totalGrade;
  final List<StudentAnswerModel> answers;
  final bool? completed;

  StudentExamAnswersDataModel({
    this.studentName,
    this.totalGrade,
    required this.answers,
    this.completed,
  });

  factory StudentExamAnswersDataModel.fromJson(Map<String, dynamic> json) {
    return StudentExamAnswersDataModel(
      studentName: json['studentName'],
      totalGrade: json['totalGrade'] != null
          ? (json['totalGrade'] as num).toDouble()
          : null,
      answers: (json['answers'] as List)
          .map((i) => StudentAnswerModel.fromJson(i))
          .toList(),
      completed: json['completed'],
    );
  }
}

class StudentAnswerModel {
  final int id;
  final QuestionDataModel question;
  final List<int>? selectedOptions;
  final String? textAnswer;
  final double? mark;

  StudentAnswerModel({
    required this.id,
    required this.question,
    this.selectedOptions,
    this.textAnswer,
    this.mark,
  });

  factory StudentAnswerModel.fromJson(Map<String, dynamic> json) {
    return StudentAnswerModel(
      id: json['id'],
      question: QuestionDataModel.fromJson(json['question']),
      selectedOptions: json['selectedOptions'] != null
          ? List<int>.from(json['selectedOptions'])
          : null,
      textAnswer: json['textAnswer'],
      mark: json['mark'] != null ? (json['mark'] as num).toDouble() : null,
    );
  }
}

class QuestionDataModel {
  final int id;
  final String text;
  final String type;
  final List<String>? options;
  final int maxPoints;
  final List<int>? correctOptionIndex;
  final String? correctAnswer;

  QuestionDataModel({
    required this.id,
    required this.text,
    required this.type,
    this.options,
    required this.maxPoints,
    this.correctOptionIndex,
    this.correctAnswer,
  });

  factory QuestionDataModel.fromJson(Map<String, dynamic> json) {
    return QuestionDataModel(
      id: json['id'],
      text: json['text'],
      type: json['type'],
      options: json['options'] != null
          ? List<String>.from(json['options'])
          : null,
      maxPoints: json['maxPoints'],
      correctOptionIndex: json['correctOptionIndex'] != null
          ? List<int>.from(
              json['correctOptionIndex'].map((e) => (e as num).toInt()),
            )
          : null,
      correctAnswer: json['correctAnswer'],
    );
  }
}
