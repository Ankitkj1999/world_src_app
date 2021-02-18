import 'dart:async';

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:world_src_app/models/apk.dart';

class DatabaseHelperApk {
  static final DatabaseHelperApk _instance = new DatabaseHelperApk.internal();

  factory DatabaseHelperApk() => _instance;

  final String tableapk = 'apkTable';
  final String columnId = 'id';
  final String columnapkName = 'apkName';
  final String columnDescription = 'description';
  final String columndUrl = 'dUrl';
  final String columnimage2 = 'image2';
  final String columnicon = 'icon';
  final String columndeveloper = 'developer';
  final String columngraphicImage = 'graphicImage';
  final String columnversion = 'version';
  final String columnfileSize = 'fileSize';
  final String columnimage1 = 'image1';
  final String columndownloads = 'downloads';

  static Database _db;

  DatabaseHelperApk.internal();

  Future<Database> get db async {
    if (_db != null) {
      return _db;
    }
    _db = await initDb();

    return _db;
  }

  initDb() async {
    String databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'apks.db');

//    await deleteDatabase(path); // just for testing

    var db = await openDatabase(path, version: 1, onCreate: _onCreate);
    return db;
  }

  void _onCreate(Database db, int newVersion) async {
    await db.execute(
        'CREATE TABLE $tableapk($columnId INTEGER PRIMARY KEY, $columnapkName TEXT, $columnDescription TEXT , $columndUrl TEXT , $columnimage2 TEXT , $columnicon TEXT , $columndeveloper TEXT , $columngraphicImage TEXT , $columnversion TEXT ,$columnfileSize TEXT , $columnimage1 TEXT , $columndownloads TEXT )');
  }

  Future<int> saveapk(Apk apk) async {
    var dbClient = await db;
    var result = await dbClient.insert(tableapk, apk.toMap());
//    var result = await dbClient.rawInsert(
//        'INSERT INTO $tableapk ($columnapkName, $columnDescription) VALUES (\'${apk.apkName}\', \'${apk.description}\')');

    return result;
  }

  Future<List> getAllapks() async {
    var dbClient = await db;
    var result = await dbClient.query(tableapk, columns: [
      columnId,
      columnapkName,
      columnDescription,
      columndUrl,
      columnimage2,
      columnicon,
      columndeveloper,
      columngraphicImage,
      columnversion,
      columnfileSize,
      columnimage1,
      columndownloads,
    ]);
//    var result = await dbClient.rawQuery('SELECT * FROM $tableapk');

    return result.toList();
  }

  Future<int> getCount() async {
    var dbClient = await db;
    return Sqflite.firstIntValue(
        await dbClient.rawQuery('SELECT COUNT(*) FROM $tableapk'));
  }

  Future<Apk> getapk(int id) async {
    var dbClient = await db;
    List<Map> result = await dbClient.query(tableapk,
        columns: [
          columnId,
          columnapkName,
          columnDescription,
          columndUrl,
          columnimage2,
          columnicon,
          columndeveloper,
          columngraphicImage,
          columnversion,
          columnfileSize,
          columnimage1,
          columndownloads,
        ],
        where: '$columnId = ?',
        whereArgs: [id]);
//    var result = await dbClient.rawQuery('SELECT * FROM $tableapk WHERE $columnId = $id');

    if (result.length > 0) {
      return new Apk.fromMap(result.first);
    }

    return null;
  }

  Future<int> deleteapk(int id) async {
    var dbClient = await db;
    return await dbClient
        .delete(tableapk, where: '$columnId = ?', whereArgs: [id]);
//    return await dbClient.rawDelete('DELETE FROM $tableapk WHERE $columnId = $id');
  }

  Future<int> updateapk(Apk apk) async {
    var dbClient = await db;
    return await dbClient.update(tableapk, apk.toMap(),
        where: "$columnId = ?", whereArgs: [apk.id]);
//    return await dbClient.rawUpdate(
//        'UPDATE $tableapk SET $columnapkName = \'${apk.apkName}\', $columnDescription = \'${apk.description}\' WHERE $columnId = ${apk.id}');
  }

  Future close() async {
    var dbClient = await db;
    return dbClient.close();
  }
}
