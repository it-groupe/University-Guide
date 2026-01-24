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
  Future<Database>? _opening;
  Future<Database> get database async {
    if (_db != null) {
      return _db!;
    }
    _opening ??= _openDB();
    _db = await _opening!;
    _opening = null;
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

      onUpgrade: (db, oldVersion, newVersion) async {
        // TODO: عندما نرفع dbVersion نضع migrations هنا
      },
    );
  }

  Future<void> runSqlFile(Database db, String filePath) async {
    final sql = await rootBundle.loadString(filePath);

    final statements = sql
        .split(';')
        .map((chunk) {
          final lines = chunk
              .split('\n')
              .map((l) => l.trimRight())
              .where((l) => l.trim().isNotEmpty)
              .where((l) => !l.trimLeft().startsWith('--'))
              .toList();

          final cleaned = lines.join('\n').trim();
          return cleaned;
        })
        .where((s) => s.isNotEmpty)
        .toList();

    await db.transaction((txn) async {
      final batch = txn.batch();
      for (final stmt in statements) {
        batch.execute(stmt);
      }
      try {
        await batch.commit(noResult: true);
      } catch (e) {
        throw Exception('Failed to run sql asset: $filePath\nError: $e');
      }
    });
  }

  Future<void> close() async {
    await _db?.close();
    _db = null;
  }

  Future<void> deleteDb() async {
    final dbPath = await getDatabasesPath();
    final path = p.join(dbPath, dbName);
    await close();
    await deleteDatabase(path);
  }
}
