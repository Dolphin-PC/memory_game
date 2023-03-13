import 'package:card_memory_game/common/util.dart';
import 'package:card_memory_game/providers/game_provider.dart';
import 'package:card_memory_game/styles/text_styles.dart';
import 'package:card_memory_game/widgets/flip_card.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_windowmanager/flutter_windowmanager.dart';
import 'package:provider/provider.dart';

import '../styles/color_styles.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late GameProvider gameProvider;
  bool isGameRunning = false;

  @override
  void initState() {
    super.initState();
    Util.execAfterBinding(() {
      gameProvider.init();

      // 캡쳐 방지
      FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE);
    });
  }

  @override
  void dispose() {
    super.dispose();
    gameProvider.gameOver();
  }

  gameStart() {
    gameProvider.gameStart();
    setState(() {
      isGameRunning = true;
    });
  }

  Text resultText() {
    String text = "날 누르고\n3초 동안 보여주니, 잘봐라냥";

    if (gameProvider.isAllUnCorrect) {
      text = "남은 생명이 없다냥\n다시 할거면 날 눌러라냥";
    } else if (gameProvider.isAllCorrect) {
      text = "정답이다냥\n다시 할거면 날 눌러라냥";
    }

    return Text(text, textAlign: TextAlign.center, style: TextStyles.cardText);
  }

  @override
  Widget build(BuildContext context) {
    gameProvider = Provider.of(context, listen: true);

    if (gameProvider.isAllCorrect || gameProvider.isAllUnCorrect) {
      isGameRunning = false;
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
              Visibility(
                visible: isGameRunning,
                child: Text(
                  '남은 생명 수 : ${gameProvider.remainLife.toString()}',
                  textAlign: TextAlign.center,
                  style: TextStyles.titleText,
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
                            onTap: () {
                              gameStart();
                              print('게임 사직냥');
                            },
                            child: Hero(
                              tag: 'default_cat',
                              child: Image.asset(
                                'assets/images/default_cat.png',
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                          resultText(),
                        ],
                      ),
              ),
              Visibility(
                visible: kDebugMode && isGameRunning,
                child: ElevatedButton(
                  onPressed: () => gameProvider.testComplete(),
                  child: Text('완료 처리'),
                ),
              ),
              Container(
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
