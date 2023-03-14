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
    PointHistoryModel pointHistoryModel = PointHistoryModel(pointMemo: PointType.addPointMap[value] ?? '-', pointCnt: value);
    await pointHistoryModel.insert();

    notifyListeners();
  }

  Future minusPoint(int value) async {
    int orgPoint = await point;
    int updatePoint = orgPoint - value;
    if (updatePoint < 0) return;

    await Util.setSharedData<int>(key, updatePoint);

    /// 포인트 이력 저장
    PointHistoryModel pointHistoryModel = PointHistoryModel(pointMemo: PointType.minusPointMap[value] ?? '-', pointCnt: value);
    await pointHistoryModel.insert();

    notifyListeners();
  }

  Future<List<PointHistoryModel>> selectList() async {
    return await PointHistoryModel.selectList();
  }
}

class PointType {
  static int get gameClear => 1;
  static int get watchAds => 5;
  static int get stageClear => 10;
  static Map<int, String> addPointMap = {
    gameClear: "[보상] 게임 클리어",
    watchAds: "[보상] 광고 시청",
    stageClear: "[보상] 스테이지 클리어",
  };

  static int get itemAddHeart => 1;
  static int get itemReview => 2;
  static int get itemDonePair => 3;
  static Map<int, String> minusPointMap = {
    itemAddHeart: "[사용] 하트 충전",
    itemReview: "[사용] 다시 보기",
    itemDonePair: "[사용] 짝 맞추기",
  };
}
