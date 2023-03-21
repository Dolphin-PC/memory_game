import 'package:card_memory_game/data/data.dart';
import 'package:card_memory_game/models/stage_info_model.dart';
import 'package:card_memory_game/shared_key.dart';
import 'package:flutter/cupertino.dart';

class StageProvider extends ChangeNotifier {
  /// 스테이지 정보
  int currentStage = 1, currentRound = 1;
  bool isInitStageInfo = false;

  int maxStage = Data.maxStage, maxRound = Data.maxRound;

  /// 스테이지 정보 초기화
  Future initStageInfo() async {
    currentStage = await SharedKey.getStage();
    currentRound = await SharedKey.getRound();
    // 초기 스테이지 정보 세팅
    await StageInfoModel.initData();
    isInitStageInfo = true;
    notifyListeners();
  }

  /// DB stage 정보 조회
  Future<List<StageInfoModel>> selectList() async {
    return await StageInfoModel.selectList();
  }

  Future update({required StageInfoModel stageInfoModel, required Map<String, dynamic> prmMap}) async {
    await stageInfoModel.update(prmMap);
  }

  /// 다음 레벨 unlock
  Future<bool> unlockNextRound({required StageInfoModel stageInfoModel}) async {
    int currentId = stageInfoModel.id!;
    int currentRoundIdx = stageInfoModel.roundIdx;

    /// currentStageId가 마지막일 경우, 그냥 넘어감
    if (currentRoundIdx == Data.maxRound) return false;

    int nextId = currentId + 1;
    StageInfoModel.updateOne(id: nextId, prmMap: {'is_lock': false});
    notifyListeners();
    return true;
  }
}
