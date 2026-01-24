import 'package:flutter_application_9/feature/test/data/models/likert_point_model.dart';
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

  /// أول سؤال من مجموعة CORE بناءً على test_id النشط
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

  /// نقاط مقياس ليكرت (1..5 مع labels العربية من DB)
  Future<List<LikertPointModel>> getLikertPoints(int scaleId) async {
    final rows = await db.query(
      'likert_scale_points',
      where: 'scale_id = ?',
      whereArgs: [scaleId],
      orderBy: 'value ASC',
    );
    return rows.map(LikertPointModel.fromMap).toList();
  }
}
