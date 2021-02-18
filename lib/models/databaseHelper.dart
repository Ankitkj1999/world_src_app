import 'dart:async';

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:world_src_app/models/movie.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = new DatabaseHelper.internal();

  factory DatabaseHelper() => _instance;

  final String tablemovie = 'movieTable';
  final String columnId = 'id';
  final String columnmovieName = 'movieName';
  final String columnDescription = 'description';
  final String columnaltdown = 'altdown';
  final String columnsize = 'size';
  final String columnlanguage = 'language';
  final String columnquality = 'quality';
  final String columncountry = 'country';
  final String columnt720p = 't720p';
  final String columnt1080p = 't1080p';
  final String columnimage = 'image';
  final String columnimdb = 'imdb';
  //final String columndata2 = 'data2';
  final String columnyear = 'year';
  final String columnurlName = 'urlName';
  //final String columnind = 'ind';

  static Database _db;

  DatabaseHelper.internal();

  Future<Database> get db async {
    if (_db != null) {
      return _db;
    }
    _db = await initDb();

    return _db;
  }

  initDb() async {
    String databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'movies.db');

//    await deleteDatabase(path); // just for testing

    var db = await openDatabase(path, version: 1, onCreate: _onCreate);
    return db;
  }

  void _onCreate(Database db, int newVersion) async {
    await db.execute(
        'CREATE TABLE $tablemovie($columnId INTEGER PRIMARY KEY, $columnmovieName TEXT, $columnDescription TEXT , $columnaltdown TEXT , $columnsize TEXT , $columnlanguage TEXT , $columnquality TEXT , $columncountry TEXT , $columnt720p TEXT ,$columnt1080p TEXT , $columnimage TEXT , $columnimdb TEXT , $columnyear TEXT , $columnurlName TEXT)');
  }

  Future<int> savemovie(Movie movie) async {
    var dbClient = await db;
    var result = await dbClient.insert(tablemovie, movie.toMap());
//    var result = await dbClient.rawInsert(
//        'INSERT INTO $tablemovie ($columnmovieName, $columnDescription) VALUES (\'${movie.movieName}\', \'${movie.description}\')');

    return result;
  }

  Future<List> getAllmovies() async {
    var dbClient = await db;
    var result = await dbClient.query(tablemovie, columns: [
      columnId,
      columnmovieName,
      columnDescription,
      columnaltdown,
      columnsize,
      columnlanguage,
      columnquality,
      columncountry,
      columnt720p,
      columnt1080p,
      columnimage,
      columnimdb,
      columnyear,
      columnurlName
    ]);
//    var result = await dbClient.rawQuery('SELECT * FROM $tablemovie');

    return result.toList();
  }

  Future<int> getCount() async {
    var dbClient = await db;
    return Sqflite.firstIntValue(
        await dbClient.rawQuery('SELECT COUNT(*) FROM $tablemovie'));
  }

  Future<Movie> getmovie(int id) async {
    var dbClient = await db;
    List<Map> result = await dbClient.query(tablemovie,
        columns: [
          columnId,
          columnmovieName,
          columnDescription,
          columnaltdown,
          columnsize,
          columnlanguage,
          columnquality,
          columncountry,
          columnt720p,
          columnt1080p,
          columnimage,
          columnimdb,
          columnyear,
          columnurlName
        ],
        where: '$columnId = ?',
        whereArgs: [id]);
//    var result = await dbClient.rawQuery('SELECT * FROM $tablemovie WHERE $columnId = $id');

    if (result.length > 0) {
      return new Movie.fromMap(result.first);
    }

    return null;
  }

  Future<int> deletemovie(int id) async {
    var dbClient = await db;
    return await dbClient
        .delete(tablemovie, where: '$columnId = ?', whereArgs: [id]);
//    return await dbClient.rawDelete('DELETE FROM $tablemovie WHERE $columnId = $id');
  }

  Future<int> updatemovie(Movie movie) async {
    var dbClient = await db;
    return await dbClient.update(tablemovie, movie.toMap(),
        where: "$columnId = ?", whereArgs: [movie.id]);
//    return await dbClient.rawUpdate(
//        'UPDATE $tablemovie SET $columnmovieName = \'${movie.movieName}\', $columnDescription = \'${movie.description}\' WHERE $columnId = ${movie.id}');
  }

  Future close() async {
    var dbClient = await db;
    return dbClient.close();
  }
}
