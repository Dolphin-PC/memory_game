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
      text = "정답이다냥";
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
        ),
        Visibility(
          visible: gameProvider.isAllCorrect,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: Icon(Icons.list_rounded),
                    iconSize: 32,
                  ),
                  Text('목록으로', style: TextStyles.plainText)
                ],
              ),
              Column(
                children: [
                  IconButton(
                    onPressed: () => gameStart(),
                    icon: Icon(Icons.refresh),
                    iconSize: 32,
                  ),
                  Text('다시하기', style: TextStyles.plainText)
                ],
              ),
            ],
          ),
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
      Toasts.show(msg: "다음 스테이지가 열렸다냥\n츄르 1개를 얻었다냥");
    }
  }

  double getGridWidth(int cnt) {
    double result = 10.0;
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height * 0.8;

    // result = (width + height) / cnt;

    // if (result * cnt > height) {
    // result = ((width + height) / cnt) / cnt;
    // }
    if (cnt < 6) {
      result = width / 2;
    } else if (cnt < 12) {
      result = width / 3;
    } else if (cnt < 18) {
      result = width / 4;
    } else if (cnt < 24) {
      result = width / 5;
    } else if (cnt < 30) {
      result = width / 6;
    } else if (cnt < 36) {
      result = width / 7;
    } else if (cnt < 42) {
      result = width / 8;
    } else if (cnt < 48) {
      result = width / 9;
    } else if (cnt < 54) {
      result = width / 10;
    } else if (cnt < 60) {
      result = width / 11;
    } else {
      result = width / 12;
    }

    return result;
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

              /// 상단 툴 (아이템 / 하트)
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

              /// 게임 카드 Grid View
              Expanded(
                child: isGameRunning
                    ? Center(
                        child: GridView.builder(
                          shrinkWrap: true,
                          itemCount: gameProvider.initCardList.length,
                          gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                            maxCrossAxisExtent: getGridWidth(gameProvider.initCardList.length),
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

              /// 테스트용 버튼
              Visibility(
                visible: kDebugMode && isGameRunning,
                child: ElevatedButton(
                  onPressed: () => gameProvider.testComplete(),
                  child: const Text('완료 처리'),
                ),
              ),

              /// 뒤로 가기 버튼
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
