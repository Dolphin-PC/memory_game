import 'package:card_memory_game/data/data.dart';
import 'package:card_memory_game/models/stage_info_model.dart';
import 'package:card_memory_game/shared_key.dart';
import 'package:flutter/cupertino.dart';

class StageProvider extends ChangeNotifier {
  /// 스테이지 정보
  int currentStage = 1, currentRound = 1;
  bool isInitStageInfo = false;

  int maxStage = Data.maxStage, maxRound = Data.maxRound;

  Future initStageInfo() async {
    currentStage = await SharedKey.getStage();
    currentRound = await SharedKey.getRound();
    isInitStageInfo = true;
  }

  Future<List<StageInfoModel>> selectList() async {
    return await StageInfoModel.selectList();
  }

  Future update({required StageInfoModel stageInfoModel, required Map<String, dynamic> prmMap}) async {
    await stageInfoModel.update(prmMap);
  }

  Future unlockNextRound({required StageInfoModel stageInfoModel}) async {
    int currentStageId = stageInfoModel.id!;

    /// currentStageId가 마지막일 경우, 그냥 넘어감
    // TODO
  }
}
