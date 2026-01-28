import 'package:flutter_application_9/feature/test/data/models/likert_point_model.dart';
import 'package:flutter_application_9/feature/test/data/models/question_choice_model.dart';
import 'package:flutter_application_9/feature/test/data/models/question_model.dart';
import 'package:flutter_application_9/feature/test/data/models/test_model.dart';
import 'package:sqflite/sqflite.dart';

class TestLocalDataSource {
  final Database db;
  TestLocalDataSource(this.db);

  Future<TestModel> getActiveTest() async {
    final rows = await db.query('tests', where: 'is_active = 1', limit: 1);

    if (rows.isEmpty) {
      throw Exception('No active test found in tests table.');
    }
    return TestModel.fromMap(rows.first);
  }

  Future<QuestionModel> getFirstCoreQuestion(int testId) async {
    final rows = await db.rawQuery(
      '''
      SELECT q.*
      FROM questions q
      JOIN question_groups g ON g.group_id = q.group_id
      WHERE g.test_id = ?
        AND g.code = 'CORE'
      ORDER BY q.display_order ASC
      LIMIT 1
    ''',
      [testId],
    );

    if (rows.isEmpty) {
      throw Exception('No CORE questions found for test_id=$testId');
    }
    return QuestionModel.fromMap(rows.first);
  }

  Future<List<LikertPointModel>> getLikertPoints(int scaleId) async {
    final rows = await db.query(
      'likert_scale_points',
      where: 'scale_id = ?',
      whereArgs: [scaleId],
      orderBy: 'value ASC',
    );
    return rows.map(LikertPointModel.fromMap).toList();
  }

  Future<QuestionModel?> getNextQuestionInSameGroup({
    required int groupId,
    required int currentOrder,
  }) async {
    final rows = await db.rawQuery(
      '''
      SELECT *
      FROM questions
      WHERE group_id = ?
        AND display_order > ?
      ORDER BY display_order ASC
      LIMIT 1
    ''',
      [groupId, currentOrder],
    );

    if (rows.isEmpty) return null;
    return QuestionModel.fromMap(rows.first);
  }

  Future<List<QuestionChoiceModel>> getChoices(int questionId) async {
    final rows = await db.query(
      'question_choices',
      where: 'question_id = ?',
      whereArgs: [questionId],
      orderBy: 'display_order ASC',
    );
    return rows.map(QuestionChoiceModel.fromMap).toList();
  }

  Future<QuestionModel?> getFirstQuestionInGroup(int groupId) async {
    final rows = await db.query(
      'questions',
      where: 'group_id = ?',
      whereArgs: [groupId],
      orderBy: 'display_order ASC',
      limit: 1,
    );
    if (rows.isEmpty) return null;
    return QuestionModel.fromMap(rows.first);
  }

  Future<QuestionModel?> getQuestionById(int questionId) async {
    final rows = await db.query(
      'questions',
      where: 'question_id = ?',
      whereArgs: [questionId],
      limit: 1,
    );
    if (rows.isEmpty) return null;
    return QuestionModel.fromMap(rows.first);
  }

  Future<QuestionModel?> getRoutedNextQuestion({
    required int fromQuestionId,
    required int selectedChoiceId,
  }) async {
    final rows = await db.rawQuery(
      '''
      SELECT *
      FROM routing_rules
      WHERE from_question_id = ?
        AND from_choice_id = ?
      ORDER BY priority ASC
      LIMIT 1
      ''',
      [fromQuestionId, selectedChoiceId],
    );

    if (rows.isEmpty) return null;

    final rule = rows.first;
    final toQuestionId = rule['to_question_id'] as int?;
    final toGroupId = rule['to_group_id'] as int?;

    if (toQuestionId != null) {
      return getQuestionById(toQuestionId);
    }

    if (toGroupId != null) {
      return getFirstQuestionInGroup(toGroupId);
    }

    return null;
  }
}
