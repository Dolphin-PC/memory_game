import 'package:flutter/material.dart';
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
  @override
  Widget build(BuildContext context) {
    GameProvider gameProvider = Provider.of(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text('기억력 게임'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 50),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: GridView.builder(
            itemCount: gameProvider.initCardList.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4, // 1개의 행에 보여줄 item 개수
              childAspectRatio: 1 / 1, // item 비율
              mainAxisSpacing: 10, // 수평 padding
              crossAxisSpacing: 10, // 수직 padding
            ),
            itemBuilder: (BuildContext context, int index) {
              return FlipCard(index: index);
            },
          ),
        ),
      ),
    );
  }
}
