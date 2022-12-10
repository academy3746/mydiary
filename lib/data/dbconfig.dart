import 'package:mydiary/data/diary.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final _databaseName = "diary.db";
  static final _databaseVersion = 1;
  static final diaryTable = "diary";

  DatabaseHelper._privateConstructor();

  // 비어있는 상태의 기본 생성자 생성 in Java

  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await _initDatabase();
    return _database;
  }

  _initDatabase() async {
    var databasePath = await getDatabasesPath();

    String path = join(databasePath, _databaseName);
    return await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate, onUpgrade: _onUpgrade);
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
    CREATE TABLE IF NOT EXISTS $diaryTable (
      title String,
      memo String,
      image String,
      date INTEGER DEFAULT 0,
      status INTEGER DEFAULT 0
    )
    ''');
  }

  Future _onUpgrade(Database db, int oldVersion, int newVersion) async {}

  // INSERT INTO VALUES (?,?,?,?,?,?) Diary_table
  Future<int> insertDiary(Diary diary) async {
    Database db = await instance.database;

    List<Diary> d = await getDiaryByDate(diary.date);

    if (d.isEmpty) {
      Map<String, dynamic> row = {
        "title": diary.title,
        "memo": diary.memo,
        "image": diary.image,
        "date": diary.date,
        "status": diary.status
      };

      return await db.insert(diaryTable, row);
    } else {
      Map<String, dynamic> row = {
        "title": diary.title,
        "memo": diary.memo,
        "image": diary.image,
        "date": diary.date,
        "status": diary.status
      };

      return await db
          .update(diaryTable, row, where: "date = ?", whereArgs: [diary.date]);
    }
  }

  // SELECT * FROM diary_table
  Future<List<Diary>> getAllDiary() async {
    Database db = await instance.database;
    List<Diary> diarys = [];

    var queries = await db.query(diaryTable);

    for (var query in queries) {
      diarys.add(Diary(
        title: query["title"],
        memo: query["memo"],
        image: query["image"],
        date: query["date"],
        status: query["status"],
      ));
    }

    return diarys;
  }

  // SELECT * FROM Diary_table GROUP BY date
  Future<List<Diary>> getDiaryByDate(int date) async {
    Database db = await instance.database;
    List<Diary> diarys = [];

    var queries =
        await db.query(diaryTable, where: "date = ?", whereArgs: [date]);

    for (var query in queries) {
      diarys.add(Diary(
        title: query["title"],
        memo: query["memo"],
        image: query["image"],
        date: query["date"],
        status: query["status"],
      ));
    }

    return diarys;
  }
}
