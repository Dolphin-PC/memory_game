import 'package:card_memory_game/common/util.dart';

class SharedKey {
  static Future<int> getStage() async {
    const key = "stage";
    if (!await Util.isSharedData(key)) {
      await Util.setSharedData<int>(key, 1);
    }
    return await Util.getSharedData<int>(key);
  }

  static Future<void> setStage(int value) async {
    const key = "stage";
    await Util.setSharedData<int>(key, value);
  }

  static Future<int> getRound() async {
    const key = "round";
    if (!await Util.isSharedData(key)) {
      await Util.setSharedData<int>(key, 1);
    }
    return await Util.getSharedData<int>(key);
  }

  static Future<void> setRound(int value) async {
    const key = "round";
    await Util.setSharedData<int>(key, value);
  }
}
