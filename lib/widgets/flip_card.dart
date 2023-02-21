import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/card_model.dart';
import '../providers/game_provider.dart';
import '../styles/color_styles.dart';
import '../styles/text_styles.dart';

class FlipCard extends StatefulWidget {
  const FlipCard({
    Key? key,
    required this.index,
    required this.card,
  }) : super(key: key);

  final int index;
  final CardModel card;

  @override
  State<FlipCard> createState() => _FlipCardState();
}

class _FlipCardState extends State<FlipCard> {
  bool getIsFront() => widget.card.isCorrect || widget.card.isClicked || widget.card.isInit;

  renderCard() {
    if (getIsFront()) {
      return renderFront();
    }

    return renderBack();
  }

  renderFront() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: ColorStyles.borderColor),
        color: ColorStyles.bgSecondaryColor,
      ),
      key: const ValueKey<int>(0),
      child: Center(
        child: Text(widget.card.pairId, style: TextStyles.cardText),
      ),
    );
  }

  renderBack() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: ColorStyles.borderColor),
      ),
      key: const ValueKey<int>(1),
      child: Center(
        child: Text('BACK', style: TextStyles.cardText),
      ),
    );
  }

  Widget wrapAnimatedBuilder(Widget widget, Animation<double> animation) {
    var pi = 3.14;
    final rotate = Tween(begin: pi, end: 0.0).animate(animation);

    return AnimatedBuilder(
      animation: rotate,
      child: widget,
      builder: (_, widget) {
        final isBack = getIsFront() ? widget?.key == ValueKey(false) : widget?.key != ValueKey(false);

        final value = isBack ? min(rotate.value, pi / 2) : rotate.value;

        return Transform(
          transform: Matrix4.rotationY(value),
          child: widget,
          alignment: Alignment.center,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    GameProvider gameProvider = Provider.of(context, listen: true);

    return GestureDetector(
      onTap: () {
        gameProvider.cardClick(widget.card);
      },
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        transitionBuilder: wrapAnimatedBuilder,
        child: renderCard(),
      ),
    );
  }
}
