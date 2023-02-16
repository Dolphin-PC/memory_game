import 'package:flutter/material.dart';
import 'package:memory_game/models/card_model.dart';
import 'package:memory_game/providers/game_provider.dart';
import 'package:provider/provider.dart';

class FlipCard extends StatelessWidget {
  const FlipCard({
    Key? key,
    required this.index,
  }) : super(key: key);

  final int index;

  @override
  Widget build(BuildContext context) {
    GameProvider gameProvider = Provider.of(context, listen: true);

    CardModel card = gameProvider.initCardList[index];

    return GestureDetector(
      onTap: () {
        gameProvider.cardClick(card);
      },
      child: Container(
        decoration: BoxDecoration(
          color: card.isCorrect
              ? Colors.red
              : card.isClicked
                  ? Colors.grey
                  : Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.green),
        ),
        child: Center(
          child: Text(card.displayName),
        ),
      ),
    );
  }
}
