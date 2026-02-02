import 'package:flutter_application_9/feature/test/data/models/likert_point_model.dart';
import 'package:flutter_application_9/feature/test/data/models/question_choice_model.dart';
import 'package:flutter_application_9/feature/test/data/models/question_model.dart';
import 'package:flutter_application_9/feature/test/data/models/question_trait_weight_model.dart';
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

  Future<List<QuestionModel>> getCoreQuestions(int testId) async {
    final rows = await db.rawQuery(
      '''
    SELECT q.*
    FROM questions q
    JOIN question_groups g ON g.group_id = q.group_id
    WHERE g.test_id = ?
      AND g.code = 'CORE'
    ORDER BY q.display_order ASC
    ''',
      [testId],
    );

    if (rows.isEmpty) {
      throw Exception('No CORE questions found for test_id=$testId');
    }
    return rows.map(QuestionModel.fromMap).toList();
  }

  Future<int> getGroupIdByCode({
    required int testId,
    required String groupCode,
  }) async {
    final rows = await db.query(
      'question_groups',
      columns: ['group_id'],
      where: 'test_id = ? AND code = ?',
      whereArgs: [testId, groupCode],
      limit: 1,
    );

    if (rows.isEmpty) {
      throw Exception('Group not found: test_id=$testId code=$groupCode');
    }
    return rows.first['group_id'] as int;
  }

  Future<List<QuestionModel>> getTraitQuestions({
    required int groupId,
    required int traitId,
    required int limit,
    required int offset,
  }) async {
    final rows = await db.rawQuery(
      '''
    SELECT q.*
    FROM questions q
    JOIN question_trait_weights w ON w.question_id = q.question_id
    WHERE q.group_id = ?
      AND w.trait_id = ?
    ORDER BY q.display_order ASC
    LIMIT ?
    OFFSET ?
    ''',
      [groupId, traitId, limit, offset],
    );

    return rows.map(QuestionModel.fromMap).toList();
  }

  Future<List<QuestionTraitWeightModel>> getTraitWeightsForQuestion(
    int questionId,
  ) async {
    final rows = await db.query(
      'question_trait_weights',
      where: 'question_id = ?',
      whereArgs: [questionId],
    );
    return rows.map(QuestionTraitWeightModel.fromMap).toList();
  }

  Future<List<QuestionModel>> getValidationQuestions({
    required int testId,
    required int limit,
  }) async {
    final rows = await db.rawQuery(
      '''
    SELECT q.*
    FROM questions q
    JOIN question_groups g ON g.group_id = q.group_id
    WHERE g.test_id = ?
      AND g.code = 'VALIDATE'
    ORDER BY q.display_order ASC
    LIMIT ?
    ''',
      [testId, limit],
    );

    return rows.map(QuestionModel.fromMap).toList();
  }

  Future<int> countTraitQuestions({
    required int groupId,
    required int traitId,
  }) async {
    final rows = await db.rawQuery(
      '''
    SELECT COUNT(*) as c
    FROM questions q
    JOIN question_trait_weights w ON w.question_id = q.question_id
    WHERE q.group_id = ? AND w.trait_id = ?
    ''',
      [groupId, traitId],
    );
    return (rows.first['c'] as int?) ?? 0;
  }

  Future<int> createAttempt({required int testId, int? studentId}) async {
    return db.insert('attempts', {
      'test_id': testId,
      'student_id': studentId,
      'status': 'in_progress',
    });
  }

  Future<void> upsertLikertAnswer({
    required int attemptId,
    required int questionId,
    required int likertValue,
  }) async {
    await db.insert('answers', {
      'attempt_id': attemptId,
      'question_id': questionId,
      'choice_id': null,
      'likert_value': likertValue,
      // answered_at له DEFAULT
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> upsertChoiceAnswer({
    required int attemptId,
    required int questionId,
    required int choiceId,
  }) async {
    await db.insert('answers', {
      'attempt_id': attemptId,
      'question_id': questionId,
      'choice_id': choiceId,
      'likert_value': null,
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> completeAttempt(int attemptId) async {
    await db.update(
      'attempts',
      {'status': 'completed', 'completed_at': DateTime.now().toIso8601String()},
      where: 'attempt_id = ?',
      whereArgs: [attemptId],
    );
  }

  Future<void> upsertAttemptTraitScore({
    required int attemptId,
    required int traitId,
    required double score,
  }) async {
    await db.insert('attempt_trait_scores', {
      'attempt_id': attemptId,
      'trait_id': traitId,
      'score': score,
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> saveAttemptTraitScores({
    required int attemptId,
    required Map<int, double> traitScores,
  }) async {
    await db.transaction((txn) async {
      final batch = txn.batch();
      traitScores.forEach((traitId, score) {
        batch.insert('attempt_trait_scores', {
          'attempt_id': attemptId,
          'trait_id': traitId,
          'score': score,
        }, conflictAlgorithm: ConflictAlgorithm.replace);
      });
      await batch.commit(noResult: true);
    });
  }

  Future<List<Map<String, Object?>>> computeMajorScores(int attemptId) async {
    // score = SUM(trait_score * major_trait_weight)
    final rows = await db.rawQuery(
      '''
    SELECT
      m.major_id,
      m.code,
      m.name,
      m.college,
      SUM(ts.score * w.weight) AS score
    FROM major_trait_weights w
    JOIN attempt_trait_scores ts
      ON ts.trait_id = w.trait_id
     AND ts.attempt_id = ?
    JOIN majors m
      ON m.major_id = w.major_id
    GROUP BY m.major_id
    ORDER BY score DESC
  ''',
      [attemptId],
    );

    return rows;
  }

  Future<void> saveAttemptMajorScores({
    required int attemptId,
    required List<Map<String, Object?>> majorRows,
  }) async {
    await db.transaction((txn) async {
      final batch = txn.batch();

      for (var i = 0; i < majorRows.length; i++) {
        final r = majorRows[i];
        batch.insert('attempt_major_scores', {
          'attempt_id': attemptId,
          'major_id': r['major_id'],
          'score': r['score'],
          'rank_no': i + 1,
        }, conflictAlgorithm: ConflictAlgorithm.replace);
      }

      await batch.commit(noResult: true);
    });
  }

  Future<List<Map<String, Object?>>> getAttemptMajorScores(
    int attemptId, {
    int limit = 5,
  }) async {
    return db.rawQuery(
      '''
    SELECT
      ams.major_id,
      m.code,
      m.name,
      m.college,
      ams.score,
      ams.rank_no
    FROM attempt_major_scores ams
    JOIN majors m ON m.major_id = ams.major_id
    WHERE ams.attempt_id = ?
    ORDER BY ams.rank_no ASC
    LIMIT ?
  ''',
      [attemptId, limit],
    );
  }

  Future<int?> getLastCompletedAttemptId({
    required int testId,
    required int studentId,
  }) async {
    final rows = await db.query(
      'attempts',
      columns: ['attempt_id'],
      where: 'test_id = ? AND student_id = ? AND status = ?',
      whereArgs: [testId, studentId, 'completed'],
      orderBy: 'completed_at DESC, attempt_id DESC',
      limit: 1,
    );

    if (rows.isEmpty) return null;
    return rows.first['attempt_id'] as int?;
  }
}
