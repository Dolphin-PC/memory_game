import 'package:card_memory_game/main.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DBHelper {
  DBHelper._();
  static final DBHelper _db = DBHelper._();
  factory DBHelper() => _db;

  static Database? _database;

  Future<Database> get database async => _database ??= await initDB();

  Future<Database> initDB() async {
    Database db = await openDatabase(
      join(await getDatabasesPath(), 'my_database.db'),
      version: 1,
      onCreate: onCreate,
      // onUpgrade: (Database db, int oldVersion, int newVersion) => {},
    );

    await devInitDB(db);

    return db;
  }

  // 데이터베이스 테이블을 생성한다.
  static Future onCreate(Database db, int version) async {
    logger.d("_onCreate");
    await devInitDB(db);
  }

  static Future devInitDB(Database db) async {
    await db.execute('DROP TABLE if exists point_history');

    String sql1 = '''
      CREATE TABLE if not exists point_history (
        id         INTEGER PRIMARY KEY AUTOINCREMENT,
        point_cnt  INTEGER NOT NULL,
        point_memo VARCHAR NULL,
        reg_dt     TIMESTAMP
      );
    ''';

    await db.execute(sql1);
  }
}
