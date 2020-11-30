import 'dart:async';
import 'dart:io' as io;

import 'package:music_minorleague/model/data/music_info_data.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class DBHelper {
  static Database _db;
  static const String TABLE = 'MyMusicList';
  static const String DB_NAME = 'listItem.db';
  static const String SQLITE_ID = 'sqliteId';
  static const String FIREBASE_ID = 'id';
  static const String TITLE = 'title';
  static const String DATE_TIME = 'dateTime';
  static const String ARTIST = 'artist';
  static const String MUSIC_PATH = 'musicPath';
  static const String IAMGE_PATH = 'imagePath';
  static const String MUSIC_TYPE = 'musicType';
  static const String FAVORITE = 'favorite';

  Future<Database> get db async {
    if (_db != null) {
      return _db;
    }
    _db = await initDb();
    return _db;
  }

  initDb() async {
    io.Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, DB_NAME);
    var db = await openDatabase(path, version: 1, onCreate: _onCreate);
    return db;
  }

  _onCreate(Database db, int version) async {
    await db.execute(
        "CREATE TABLE $TABLE ($SQLITE_ID INTEGER PRIMARY KEY, $FIREBASE_ID TEXT, $DATE_TIME TEXT, $TITLE TEXT, $ARTIST TEXT, $MUSIC_TYPE TEXT, $MUSIC_PATH TEXT, $IAMGE_PATH TEXT, $FAVORITE INTEGER)");
  }

  Future<MusicInfoData> save(MusicInfoData listItem) async {
    var dbClient = await db;
    listItem.sqliteId = await dbClient.insert(TABLE, listItem.toMap());
    return listItem;
  }

  Future<List<MusicInfoData>> getListItem() async {
    var dbClient = await db;
    List<Map> maps = await dbClient.query(TABLE, columns: [
      SQLITE_ID,
      FIREBASE_ID,
      DATE_TIME,
      TITLE,
      ARTIST,
      MUSIC_TYPE,
      MUSIC_PATH,
      IAMGE_PATH,
      FAVORITE
    ]);
    //List<Map> maps = await dbClient.rawQuery("SELECT * FROM $TABLE");
    List<MusicInfoData> listItems = [];
    if (maps.length > 0) {
      for (int i = 0; i < maps.length; i++) {
        listItems.add(MusicInfoData.fromMap(maps[i]));
      }
    }
    return listItems;
  }

  Future<int> delete(int id) async {
    var dbClient = await db;
    return await dbClient
        .delete(TABLE, where: '$SQLITE_ID = ?', whereArgs: [id]);
  }

  Future<int> update(MusicInfoData listItem) async {
    var dbClient = await db;
    return await dbClient.update(TABLE, listItem.toMap(),
        where: '$SQLITE_ID = ?', whereArgs: [listItem.id]);
  }

  Future close() async {
    var dbClient = await db;
    dbClient.close();
  }
}
