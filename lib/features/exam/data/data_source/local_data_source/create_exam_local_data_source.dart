import 'package:catalyst/core/databases/cache/constant.dart';
import 'package:catalyst/features/exam/data/models/question_model.dart';
import 'package:catalyst/features/exam/data/models/exam_info_model.dart';
import 'package:hive/hive.dart';

abstract class CreateExamLocalDataSource {
  // questions
  Future<void> addQuestion(Question question);
  Future<void> updateQuestion(Question question);
  Future<void> deleteQuestion(String questionId);
  Future<List<Question>> loadQuestions();
  Future<void> clearQuestions();

  // exam info
  Future<ExamInfo?> loadExamInfo();
  Future<void> saveExamInfo(ExamInfo examInfo);
  Future<void> clearExamInfo();
}

class CreateExamLocalDataSourceImpl implements CreateExamLocalDataSource {
  CreateExamLocalDataSourceImpl();

  final Box<Question> _questionsBox = Hive.box<Question>(Constant.questionsKey);
  final Box<ExamInfo> _examInfoBox = Hive.box<ExamInfo>(Constant.examInfoKey);

  // ===================== questions =====================

  @override
  Future<void> addQuestion(Question question) async {
    // نخزن السؤال بالـ id بتاعه
    await _questionsBox.put(question.id, question);
  }

  @override
  Future<void> updateQuestion(Question question) async {
    // نفس الفكرة، لو الـ id موجود هيعمل update
    await _questionsBox.put(question.id, question);
  }

  @override
  Future<void> deleteQuestion(String questionId) async {
    await _questionsBox.delete(questionId);
  }

  @override
  Future<List<Question>> loadQuestions() async {
    return _questionsBox.values.toList();
  }

  @override
  Future<void> clearQuestions() async {
    await _questionsBox.clear();
  }

  // ===================== exam info =====================

  @override
  Future<void> saveExamInfo(ExamInfo examInfo) async {
    // بما إن ExamInfo HiveType، خزنها زي ما هي
    await _examInfoBox.put(Constant.examInfoKey, examInfo);
  }

  @override
  Future<ExamInfo?> loadExamInfo() async {
    return _examInfoBox.get(Constant.examInfoKey);
  }

  @override
  Future<void> clearExamInfo() async {
    await _examInfoBox.delete(Constant.examInfoKey);
  }
}
