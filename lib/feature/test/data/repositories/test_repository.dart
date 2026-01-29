import 'package:flutter_application_9/data/db/db_helper.dart';
import 'package:flutter_application_9/feature/test/data/dataSource/test_local_ds.dart';
import 'package:flutter_application_9/feature/test/data/models/major_score_model.dart';
import 'package:flutter_application_9/feature/test/data/models/question_choice_model.dart';
import 'package:flutter_application_9/feature/test/data/models/question_trait_weight_model.dart';

import '../models/test_model.dart';
import '../models/question_model.dart';
import '../models/likert_point_model.dart';

class TestRepository {
  TestRepository._();
  static final TestRepository instance = TestRepository._();

  Future<TestModel> getActiveTest() async {
    final db = await DbHelper.instance.database;
    final ds = TestLocalDataSource(db);
    return ds.getActiveTest();
  }

  Future<QuestionModel> getFirstCoreQuestion() async {
    final db = await DbHelper.instance.database;
    final ds = TestLocalDataSource(db);
    final test = await ds.getActiveTest();
    return ds.getFirstCoreQuestion(test.id);
  }

  Future<List<LikertPointModel>> getLikertPoints(int scaleId) async {
    final db = await DbHelper.instance.database;
    final ds = TestLocalDataSource(db);
    return ds.getLikertPoints(scaleId);
  }

  Future<QuestionModel?> getNextQuestionInSameGroup({
    required int groupId,
    required int currentOrder,
  }) async {
    final db = await DbHelper.instance.database;
    final ds = TestLocalDataSource(db);
    return ds.getNextQuestionInSameGroup(
      groupId: groupId,
      currentOrder: currentOrder,
    );
  }

  Future<List<QuestionChoiceModel>> getChoices(int questionId) async {
    final db = await DbHelper.instance.database;
    final ds = TestLocalDataSource(db);
    return ds.getChoices(questionId);
  }

  Future<QuestionModel?> getRoutedNextQuestion({
    required int fromQuestionId,
    required int selectedChoiceId,
  }) async {
    final db = await DbHelper.instance.database;
    final ds = TestLocalDataSource(db);
    return ds.getRoutedNextQuestion(
      fromQuestionId: fromQuestionId,
      selectedChoiceId: selectedChoiceId,
    );
  }

  Future<List<QuestionModel>> getCoreQuestions() async {
    final db = await DbHelper.instance.database;
    final ds = TestLocalDataSource(db);
    final test = await ds.getActiveTest();
    return ds.getCoreQuestions(test.id);
  }

  Future<int> getGroupIdByCode(String code) async {
    final db = await DbHelper.instance.database;
    final ds = TestLocalDataSource(db);
    final test = await ds.getActiveTest();
    return ds.getGroupIdByCode(testId: test.id, groupCode: code);
  }

  Future<List<QuestionModel>> getTraitQuestions({
    required int groupId,
    required int traitId,
    required int limit,
    required int offset,
  }) async {
    final db = await DbHelper.instance.database;
    final ds = TestLocalDataSource(db);
    return ds.getTraitQuestions(
      groupId: groupId,
      traitId: traitId,
      limit: limit,
      offset: offset,
    );
  }

  Future<List<QuestionTraitWeightModel>> getTraitWeightsForQuestion(
    int questionId,
  ) async {
    final db = await DbHelper.instance.database;
    final ds = TestLocalDataSource(db);
    return ds.getTraitWeightsForQuestion(questionId);
  }

  Future<List<QuestionModel>> getValidationQuestions({
    required int limit,
  }) async {
    final db = await DbHelper.instance.database;
    final ds = TestLocalDataSource(db);
    final test = await ds.getActiveTest();
    return ds.getValidationQuestions(testId: test.id, limit: limit);
  }

  Future<int> countTraitQuestions({
    required int groupId,
    required int traitId,
  }) async {
    final db = await DbHelper.instance.database;
    final ds = TestLocalDataSource(db);
    return ds.countTraitQuestions(groupId: groupId, traitId: traitId);
  }

  Future<int> createAttempt({required int testId, int? studentId}) async {
    final db = await DbHelper.instance.database;
    final ds = TestLocalDataSource(db);
    return ds.createAttempt(testId: testId, studentId: studentId);
  }

  Future<void> saveLikertAnswer({
    required int attemptId,
    required int questionId,
    required int likertValue,
  }) async {
    final db = await DbHelper.instance.database;
    final ds = TestLocalDataSource(db);
    return ds.upsertLikertAnswer(
      attemptId: attemptId,
      questionId: questionId,
      likertValue: likertValue,
    );
  }

  Future<void> saveChoiceAnswer({
    required int attemptId,
    required int questionId,
    required int choiceId,
  }) async {
    final db = await DbHelper.instance.database;
    final ds = TestLocalDataSource(db);
    return ds.upsertChoiceAnswer(
      attemptId: attemptId,
      questionId: questionId,
      choiceId: choiceId,
    );
  }

  Future<void> completeAttempt(int attemptId) async {
    final db = await DbHelper.instance.database;
    final ds = TestLocalDataSource(db);
    return ds.completeAttempt(attemptId);
  }

  Future<void> saveAttemptTraitScores({
    required int attemptId,
    required Map<int, double> traitScores,
  }) async {
    final db = await DbHelper.instance.database;
    final ds = TestLocalDataSource(db);
    return ds.saveAttemptTraitScores(
      attemptId: attemptId,
      traitScores: traitScores,
    );
  }

  Future<List<Map<String, Object?>>> computeMajorScores(int attemptId) async {
    final db = await DbHelper.instance.database;
    final ds = TestLocalDataSource(db);
    return ds.computeMajorScores(attemptId);
  }

  Future<void> saveAttemptMajorScores({
    required int attemptId,
    required List<Map<String, Object?>> majorRows,
  }) async {
    final db = await DbHelper.instance.database;
    final ds = TestLocalDataSource(db);
    return ds.saveAttemptMajorScores(
      attemptId: attemptId,
      majorRows: majorRows,
    );
  }

  Future<List<MajorScoreModel>> getAttemptMajorScores(
    int attemptId, {
    int limit = 5,
  }) async {
    final db = await DbHelper.instance.database;
    final ds = TestLocalDataSource(db);
    final rows = await ds.getAttemptMajorScores(attemptId, limit: limit);
    return rows.map(MajorScoreModel.fromMap).toList();
  }
}
