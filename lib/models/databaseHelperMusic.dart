import 'dart:async';

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:world_src_app/models/music.dart';

class DatabaseHelperMusic {
  static final DatabaseHelperMusic _instance =
      new DatabaseHelperMusic.internal();

  factory DatabaseHelperMusic() => _instance;

  final String tablemusic = 'musicTable';
  final String columnId = 'id';
  final String columnmusicName = 'musicName';
  final String columnsongLyrics = 'songLyrics';
  final String columnaltdown = 'altdown';
  final String columnartistName = 'artistName';
  final String columnimage = 'image';
  final String columnyear = 'year';
  final String columnmp3Download = 'mp3Download';
  //final String columnind = 'ind';

  static Database _db;

  DatabaseHelperMusic.internal();

  Future<Database> get db async {
    if (_db != null) {
      return _db;
    }
    _db = await initDb();

    return _db;
  }

  initDb() async {
    String databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'musics.db');

//    await deleteDatabase(path); // just for testing

    var db = await openDatabase(path, version: 1, onCreate: _onCreate);
    return db;
  }

  void _onCreate(Database db, int newVersion) async {
    await db.execute(
        'CREATE TABLE $tablemusic($columnId INTEGER PRIMARY KEY, $columnmusicName TEXT, $columnsongLyrics TEXT , $columnaltdown TEXT , $columnartistName TEXT  , $columnimage TEXT , $columnyear TEXT , $columnmp3Download TEXT)');
  }

  Future<int> savemusic(Music music) async {
    var dbClient = await db;
    var result = await dbClient.insert(tablemusic, music.toMap());
//    var result = await dbClient.rawInsert(
//        'INSERT INTO $tablemusic ($columnmusicName, $columnsongLyrics) VALUES (\'${music.musicName}\', \'${music.songLyrics}\')');

    return result;
  }

  Future<List> getAllmusics() async {
    var dbClient = await db;
    var result = await dbClient.query(tablemusic, columns: [
      columnId,
      columnmusicName,
      columnsongLyrics,
      columnaltdown,
      columnartistName,
      columnimage,
      columnyear,
      columnmp3Download
    ]);
//    var result = await dbClient.rawQuery('SELECT * FROM $tablemusic');

    return result.toList();
  }

  Future<int> getCount() async {
    var dbClient = await db;
    return Sqflite.firstIntValue(
        await dbClient.rawQuery('SELECT COUNT(*) FROM $tablemusic'));
  }

  Future<Music> getmusic(int id) async {
    var dbClient = await db;
    List<Map> result = await dbClient.query(tablemusic,
        columns: [
          columnId,
          columnmusicName,
          columnsongLyrics,
          columnaltdown,
          columnartistName,
          columnimage,
          columnyear,
          columnmp3Download
        ],
        where: '$columnId = ?',
        whereArgs: [id]);
//    var result = await dbClient.rawQuery('SELECT * FROM $tablemusic WHERE $columnId = $id');

    if (result.length > 0) {
      return new Music.fromMap(result.first);
    }

    return null;
  }

  Future<int> deletemusic(int id) async {
    var dbClient = await db;
    return await dbClient
        .delete(tablemusic, where: '$columnId = ?', whereArgs: [id]);
//    return await dbClient.rawDelete('DELETE FROM $tablemusic WHERE $columnId = $id');
  }

  Future<int> updatemusic(Music music) async {
    var dbClient = await db;
    return await dbClient.update(tablemusic, music.toMap(),
        where: "$columnId = ?", whereArgs: [music.id]);
//    return await dbClient.rawUpdate(
//        'UPDATE $tablemusic SET $columnmusicName = \'${music.musicName}\', $columnsongLyrics = \'${music.songLyrics}\' WHERE $columnId = ${music.id}');
  }

  Future close() async {
    var dbClient = await db;
    return dbClient.close();
  }
}
