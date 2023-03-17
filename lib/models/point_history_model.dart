import 'package:card_memory_game/db/db_helper.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';

class PointHistoryModel {
  PointHistoryModel({Key? key, this.id, required this.pointCnt, required this.pointMemo, this.regDate});

  final int? id;
  final int pointCnt;
  final String pointMemo;
  final DateTime? regDate;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'point_cnt': pointCnt,
      'point_memo': pointMemo,
      'reg_dt': DateFormat("yyyy-MM-dd HH:mm:ss").format(DateTime.now()),
    };
  }

  static Future<List<PointHistoryModel>> selectList() async {
    final db = await DBHelper().database;
    final List<dynamic> maps = await db.query("point_history");

    var list = List.generate(maps.length, (i) {
      return PointHistoryModel(
        id: maps[i]['id'],
        pointCnt: maps[i]['point_cnt'],
        pointMemo: maps[i]['point_memo'],
        regDate: DateTime.parse(maps[i]['reg_dt']),
      );
    });

    return list;
  }

  Future<void> insert() async {
    final db = await DBHelper().database;

    await db.insert(
      'point_history',
      toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> delete() async {
    final db = await DBHelper().database;
    await db.delete('point_history', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> update(Map<String, dynamic> prmMap) async {
    final db = await DBHelper().database;
    await db.update('point_history', prmMap, where: 'id = ?', whereArgs: [id]);
  }
}
