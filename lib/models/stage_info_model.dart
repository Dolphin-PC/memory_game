import 'package:card_memory_game/data/data.dart';
import 'package:card_memory_game/db/db_helper.dart';
import 'package:sqflite/sqlite_api.dart';

const String tableName = "stage_info";

class StageInfoModel {
  StageInfoModel({this.id, required this.stageIdx, required this.roundIdx, required this.isClear, required this.isLock});

  final int? id;
  final int stageIdx;
  final int roundIdx;
  final bool isClear;
  final bool isLock;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'stage_idx': stageIdx,
      'round_idx': roundIdx,
      'is_clear': isClear,
      'is_lock': isLock,
    };
  }

  static Future<List<StageInfoModel>> selectList() async {
    final db = await DBHelper().database;
    final List<dynamic> maps = await db.query(tableName, orderBy: 'stage_idx asc, round_idx asc');

    if (maps.isEmpty) {
      await initData();
    }

    var list = List.generate(maps.length, (i) {
      return StageInfoModel(
        id: maps[i]['id'],
        stageIdx: maps[i]['stage_idx'],
        roundIdx: maps[i]['round_idx'],
        isClear: maps[i]['is_clear'] == 1 ? true : false,
        isLock: maps[i]['is_lock'] == 1 ? true : false,
      );
    });

    // logger.d(list);

    return list;
  }

  static Future<void> initData() async {
    for (int stage = 1; stage <= Data.maxStage; stage++) {
      for (int round = 1; round <= Data.maxRound; round++) {
        bool isLock = true;
        if (round == 1) {
          isLock = false;
        }
        await StageInfoModel(stageIdx: stage, roundIdx: round, isClear: false, isLock: isLock).insert();
      }
    }
  }

  Future<void> insert() async {
    final db = await DBHelper().database;

    await db.insert(
      tableName,
      toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> delete() async {
    final db = await DBHelper().database;
    await db.delete(tableName, where: 'id = ?', whereArgs: [id]);
  }

  Future<void> update(Map<String, dynamic> prmMap) async {
    final db = await DBHelper().database;
    await db.update(tableName, prmMap, where: 'id = ?', whereArgs: [id]);
  }
}
