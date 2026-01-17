import 'dart:async';
import 'package:flutter/services.dart' show rootBundle;
import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';

class DbHelper {
  DbHelper._internal();
  static final DbHelper instance = DbHelper._internal();
  static const String dbName = 'uniguide.db';
  static const int dbVersion = 1;

  Database? _db;

  Future<Database> get database async {
    if (_db != null) {
      return _db!;
    }
    _db = await _openDB();
    return _db!;
  }

  Future<Database> _openDB() async {
    final dbPath = await getDatabasesPath();
    final path = p.join(dbPath, dbName);

    return openDatabase(
      path,
      version: dbVersion,
      onConfigure: (db) async {
        // احتياط لكي يفعل العلاقات بين الجداول لان قاعدة البيانات تعتمد على الجداول
        await db.execute('PRAGMA foreign_keys = ON;');
      },
      onCreate: (db, version) async {
        await runSqlFile(db, 'assets/sql/interest_test.sql');
      },
    );
  }

  Future<void> runSqlFile(Database db, String filePath) async {
    final sql = await rootBundle.loadString(filePath);
    final statment = sql
        .split(';')
        .map((s) => s.trim())
        .where((s) => s.isNotEmpty)
        .toList();

    await db.transaction((txn) async {
      final batch = txn.batch();
      for (final stmt in statment) {
        batch.execute(stmt);
      }
      try {
        await batch.commit(noResult: true);
      } catch (e) {
        throw Exception('Faild to run sql assets: $filePath\nError: $e');
      }
    });
  }
}
