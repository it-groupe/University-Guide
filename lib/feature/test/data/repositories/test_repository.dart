import 'package:flutter_application_9/data/db/db_helper.dart';
import 'package:flutter_application_9/feature/test/data/dataSource/test_local_ds.dart';
import 'package:flutter_application_9/feature/test/data/models/question_choice_model.dart';

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
}
