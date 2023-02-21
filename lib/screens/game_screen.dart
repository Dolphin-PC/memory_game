import 'package:flutter/material.dart';
import 'package:memory_game/common/util.dart';
import 'package:memory_game/providers/game_provider.dart';
import 'package:memory_game/styles/color_styles.dart';
import 'package:memory_game/styles/text_styles.dart';
import 'package:memory_game/widgets/flip_card.dart';
import 'package:provider/provider.dart';

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
    // Util.execAfterBinding(() {
    //   gameStart();
    // });
  }

  gameStart() {
    gameProvider.gameStart();
    // showDialog(
    //   context: context,
    //   barrierDismissible: false,
    //   builder: (BuildContext context) {
    //     return AlertDialog(
    //       content: Text(
    //         '3초 뒤에 시작합니다.',
    //         style: TextStyles.plainText,
    //       ),
    //       actions: [
    //         ElevatedButton(
    //           child: Text('시작'),
    //           onPressed: () {
    //             Navigator.of(context).pop();
    //             gameProvider.gameStart();
    //           },
    //         )
    //       ],
    //     );
    //   },
    // );
  }

  @override
  Widget build(BuildContext context) {
    gameProvider = Provider.of(context, listen: true);

    if (gameProvider.isAllCorrect) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Text('전부 맞췄습니다!'),
            actions: [
              ElevatedButton(
                child: Text('나가기'),
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                },
              ),
              ElevatedButton(
                child: Text('다시 시작'),
                onPressed: () {
                  Navigator.of(context).pop();
                  gameStart();
                },
              )
            ],
          );
        },
      );
    }
    if (gameProvider.isAllUnCorrect) {
      print('gameProvider.isAllUnCorrect');
      Util.execAfterBinding(() {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return AlertDialog(
              backgroundColor: ColorStyles.bgPrimaryColor,
              content: Text(
                '남은 생명 수가 없어요...',
                style: TextStyles.plainText,
              ),
              actions: [
                OutlinedButton(
                  style: OutlinedButton.styleFrom(backgroundColor: Colors.transparent, foregroundColor: Colors.black),
                  child: Text(
                    '나가기',
                    style: TextStyles.buttonText,
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                  },
                ),
                ElevatedButton(
                  child: Text(
                    '다시 시작',
                    style: TextStyles.buttonText,
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                    gameStart();
                  },
                )
              ],
            );
          },
        );
      });
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
                    : GestureDetector(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Hero(
                              tag: 'default_icon',
                              child: Image.asset(
                                'assets/images/default_icon.png',
                                fit: BoxFit.contain,
                              ),
                            ),
                            Text(
                              '3초 동안 보여줄테니, 잘봐라냥',
                              style: TextStyles.cardText,
                            )
                          ],
                        ),
                        onTap: () {},
                      ),
              ),
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: Icon(Icons.arrow_back, color: ColorStyles.borderColor, size: 50),
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    gameProvider.gameOver();
  }
}
