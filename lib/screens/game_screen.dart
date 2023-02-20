import 'package:flutter/material.dart';
import 'package:memory_game/common/util.dart';
import 'package:memory_game/providers/game_provider.dart';
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

  @override
  void initState() {
    super.initState();
    Util.execAfterBinding(() {
      gameStart();
    });
  }

  gameStart() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Text('3초 뒤에 시작합니다.'),
          actions: [
            ElevatedButton(
              child: Text('시작'),
              onPressed: () {
                Navigator.of(context).pop();
                gameProvider.gameStart();
              },
            )
          ],
        );
      },
    );
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
              content: Text('게임 오버...'),
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
      });
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('기억력 게임'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 20),
        child: Column(
          children: [
            Text('남은 생명 수 : ${gameProvider.remainLife.toString()}'),
            SizedBox(
              height: 30,
            ),
            Expanded(
              child: GridView.builder(
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
            ),
          ],
        ),
      ),
    );
  }
}
