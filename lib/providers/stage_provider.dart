import 'package:card_memory_game/shared_key.dart';
import 'package:flutter/cupertino.dart';

class StageProvider extends ChangeNotifier {
  /// 스테이지 정보
  int currentStage = 1, currentRound = 1;
  bool isInitStageInfo = false;

  int maxStage = 5, maxRound = 10;

  Future initStageInfo() async {
    currentStage = await SharedKey.getStage();
    currentRound = await SharedKey.getRound();
    isInitStageInfo = true;
  }
}
