import 'package:flutter/material.dart';
import 'package:memory_game/models/card_model.dart';

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
  }

  void gameStart() {
    init();
    initCardList.forEach((element) => element.isInit = true);
    Future.delayed(Duration(milliseconds: 3000), () {
      initCardList.forEach((element) => element.isInit = false);
      notifyListeners();
    });
    notifyListeners();
  }

  void gameOver() {
    // isAllUnCorrect = isAllCorrect = false;
    initCardList = pairCardList = [];
  }

  void cardClick(CardModel card) {
    if (card.isCorrect || !isClickable) return;

    card.isClicked = !card.isClicked;
    pairCardList.add(card);

    print(pairCardList.length);
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
      print('pair!!');
      card1.isCorrect = true;
      card2.isCorrect = true;
      allCorrect();
      isClickable = true;
    } else {
      if (allUnCorrect()) return;
      Future.delayed(Duration(milliseconds: 1000), () {
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
      print('all correct');
    }
  }

  bool allUnCorrect() {
    if (--remainLife <= 0) {
      isAllUnCorrect = true;
      gameOver();
      print('all un correct');
      notifyListeners();
      return true;
    }
    return false;
  }
}
