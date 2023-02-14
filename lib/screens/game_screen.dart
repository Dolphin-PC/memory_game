import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:memory_game/providers/card_provider.dart';
import 'package:memory_game/providers/hello_world_provider.dart';
import 'package:memory_game/widgets/flip_card.dart';

class GameScreen extends ConsumerStatefulWidget {
  const GameScreen({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState createState() => _GameScreenState();
}

class _GameScreenState extends ConsumerState<GameScreen> {

  @override
  Widget build(BuildContext context) {
    List<CardModel> cardList = ref.watch(cardProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('기억력 게임'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 50),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: GridView.builder(
            itemCount: cardList.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4, // 1개의 행에 보여줄 item 개수
              childAspectRatio: 1 / 1, // item 비율
              mainAxisSpacing: 10, // 수평 padding
              crossAxisSpacing: 10, // 수직 padding
            ),
            itemBuilder: (BuildContext context, int index) {
              return FlipCard(cardModel: cardList[index]);
            },
          ),
        ),
      ),
    );
  }
}
