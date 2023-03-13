import 'package:card_memory_game/main.dart';
import 'package:flutter/material.dart';

import '../models/card_model.dart';

class GameProvider extends ChangeNotifier {
  List<CardModel> initCardList = [];
  List<CardModel> pairCardList = [];

  int remainLife = 3;

  bool isAllCorrect = false, isAllUnCorrect = false, isClickable = false;

  final List<String> initList = [
    '1',
    '1',
    '2',
    '2',
    '3',
    '3',
    '4',
    '4',
    '5',
    '5',
    '6',
    '6',
    '7',
    '7',
    '8',
    '8',
  ];

  void init() {
    remainLife = 3;
    isClickable = true;
    isAllUnCorrect = isAllCorrect = false;
    pairCardList = [];
    initCardList = List.generate(initList.length, (i) => CardModel(displayName: i.toString(), pairId: initList[i]));
    initCardList.shuffle();
    notifyListeners();
  }

  void gameStart() {
    init();
    for (var element in initCardList) {
      element.isInit = true;
    }
    Future.delayed(const Duration(milliseconds: 3000), () {
      for (var element in initCardList) {
        element.isInit = false;
      }
      notifyListeners();
    });
    notifyListeners();
  }

  void gameOver() {
    isAllUnCorrect = isAllCorrect = false;
    initCardList = pairCardList = [];
  }

  void cardClick(CardModel card) {
    if (card.isCorrect || !isClickable) return;

    card.isClicked = !card.isClicked;
    pairCardList.add(card);

    if (pairCardList.length >= 2) {
      compareCard();
    }

    notifyListeners();
  }

  void compareCard() {
    isClickable = false;
    var card1 = pairCardList[0];
    var card2 = pairCardList[1];
    if (card1.pairId == card2.pairId && card1.displayName != card2.displayName) {
      logger.d('pair!!');
      card1.isCorrect = true;
      card2.isCorrect = true;
      allCorrect();
      isClickable = true;
    } else {
      if (allUnCorrect()) return;
      Future.delayed(const Duration(milliseconds: 1000), () {
        card1.isClicked = false;
        card2.isClicked = false;
        isClickable = true;
        notifyListeners();
      });
    }
    pairCardList = [];
  }

  void allCorrect() {
    isAllCorrect = initCardList.every((card) => card.isCorrect == true);
    if (isAllCorrect) {
      logger.d('all correct');
    }
  }

  bool allUnCorrect() {
    if (--remainLife <= 0) {
      isAllUnCorrect = true;

      notifyListeners();
      return true;
    }
    return false;
  }

  void testComplete() {
    isAllCorrect = true;
    notifyListeners();
  }
}
