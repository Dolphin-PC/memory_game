import 'package:card_memory_game/common/util.dart';
import 'package:card_memory_game/models/point_history_model.dart';
import 'package:flutter/cupertino.dart';

class PointProvider extends ChangeNotifier {
  final String key = "point";

  int _point = 0;

  Future<int> get point async {
    /// GET 포인트 정보
    if (!await Util.isSharedData(key)) {
      await Util.setSharedData<int>(key, 0);
    }
    _point = await Util.getSharedData<int>(key);

    return _point;
  }

  Future addPoint(int value) async {
    int orgPoint = await point;
    int updatePoint = orgPoint + value;

    await Util.setSharedData<int>(key, updatePoint);

    /// 포인트 이력 저장
    PointHistoryModel pointHistoryModel = PointHistoryModel(pointMemo: '광고 시청', pointCnt: value);
    pointHistoryModel.insert();
    notifyListeners();
  }

  Future minusPoint(int value) async {
    int orgPoint = await point;
    int updatePoint = orgPoint - value;
    if (updatePoint < 0) return;

    await Util.setSharedData<int>(key, updatePoint);
    notifyListeners();
  }
}

class PointType {
  static int get gameClear => 1;
  static int get watchAds => 5;
  static int get stageClear => 10;

  static int get itemAddHeart => 1;
  static int get itemReview => 2;
  static int get itemDonePair => 3;
}
