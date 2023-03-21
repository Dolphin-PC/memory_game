import 'package:card_memory_game/common/util.dart';
import 'package:card_memory_game/common/widgets/toasts.dart';
import 'package:card_memory_game/models/stage_info_model.dart';
import 'package:card_memory_game/providers/game_provider.dart';
import 'package:card_memory_game/providers/point_provider.dart';
import 'package:card_memory_game/providers/stage_provider.dart';
import 'package:card_memory_game/styles/text_styles.dart';
import 'package:card_memory_game/widgets/flip_card.dart';
import 'package:card_memory_game/widgets/game_items.dart';
import 'package:card_memory_game/widgets/point_widget.dart';
import 'package:card_memory_game/widgets/remain_life.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_windowmanager/flutter_windowmanager.dart';
import 'package:provider/provider.dart';

import '../styles/color_styles.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({Key? key, required this.stageInfoModel}) : super(key: key);

  final StageInfoModel stageInfoModel;

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late GameProvider gameProvider;
  late PointProvider pointProvider;
  late StageProvider stageProvider;
  bool isGameRunning = false;

  @override
  void initState() {
    Util.execAfterBinding(() {
      gameProvider.preInit(stageInfoModel: widget.stageInfoModel);
      // gameStart();

      // 캡쳐 방지
      FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE);
    });
    super.initState();
  }

  @override
  void dispose() {
    gameProvider.gameReset();
    super.dispose();
  }

  /// [게임 시작] 버튼 클릭
  gameStart() {
    gameProvider.gameStart();
    setState(() {
      isGameRunning = true;
    });
  }

  Column buildGameStartWidget() {
    String text = "날 누르고\n3초 동안 보여주니, 잘봐라냥";
    String catImageName = "default_cat.png";

    if (gameProvider.isAllUnCorrect) {
      text = "남은 생명이 없다냥\n다시 할거면 날 눌러라냥";
    } else if (gameProvider.isAllCorrect) {
      text = "정답이다냥\n다시 할거면 날 눌러라냥";
      catImageName = "same_card_cat_hands_up.png";
    }

    return Column(
      children: [
        Image.asset(
          'assets/images/$catImageName',
          fit: BoxFit.contain,
        ),
        Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyles.cardText,
        )
      ],
    );
  }

  /// round 최초 clear 시
  Future<void> onRoundClear() async {
    /// 모든 카드 맞췄을 시, 포인트지급(최초 1회), is_complete && 다음 스테이지 잠금 해제
    await pointProvider.addPoint(PointType.gameClear);
    await stageProvider.update(stageInfoModel: widget.stageInfoModel, prmMap: {'is_clear': true});
    if (await stageProvider.unlockNextRound(stageInfoModel: widget.stageInfoModel)) {
      Toasts.show(msg: "다음 스테이지가 열렸다냥");
    }
  }

  @override
  Widget build(BuildContext context) {
    gameProvider = Provider.of(context, listen: true);
    pointProvider = Provider.of(context, listen: false);
    stageProvider = Provider.of(context, listen: false);

    /// 게임 시작 전/후 화면
    if (gameProvider.isAllCorrect || gameProvider.isAllUnCorrect) {
      isGameRunning = false;
    }

    if (gameProvider.isAllCorrect) {
      if (!gameProvider.stageInfoModel.isClear) {
        gameProvider.stageInfoModel.isClear = true;
        onRoundClear();
      }
    }

    return Scaffold(
      backgroundColor: ColorStyles.bgPrimaryColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const PointWidget(),
              Visibility(
                visible: isGameRunning,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const GameItems(),
                    RemainLife(life: gameProvider.remainLife),
                  ],
                ),
              ),
              Expanded(
                child: isGameRunning
                    ? Center(
                        child: GridView.builder(
                          shrinkWrap: true,
                          itemCount: gameProvider.initCardList.length,
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 4, // 1개의 행에 보여줄 item 개수
                            childAspectRatio: 1 / 1, // item 비율
                            mainAxisSpacing: 10, // 수평 padding
                            crossAxisSpacing: 10, // 수직 padding
                          ),
                          itemBuilder: (BuildContext context, int index) {
                            return FlipCard(index: index, card: gameProvider.initCardList[index]);
                          },
                        ),
                      )
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: () => gameStart(),
                            child: Hero(
                              tag: 'default_cat',
                              child: buildGameStartWidget(),
                            ),
                          ),
                        ],
                      ),
              ),
              Visibility(
                visible: kDebugMode && isGameRunning,
                child: ElevatedButton(
                  onPressed: () => gameProvider.testComplete(),
                  child: const Text('완료 처리'),
                ),
              ),
              SizedBox(
                height: 50,
                child: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Icon(Icons.arrow_back, color: ColorStyles.borderColor, size: 50),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
