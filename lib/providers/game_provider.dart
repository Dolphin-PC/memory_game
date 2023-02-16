import 'package:flutter/material.dart';
import 'package:memory_game/models/card_model.dart';

class GameProvider extends ChangeNotifier {
  List<CardModel> initCardList = [];
  List<CardModel> pairCardList = [];

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
    initCardList = List.generate(initList.length, (i) => CardModel(displayName: i.toString(), pairId: initList[i]));
  }

  void cardClick(CardModel card) {
    if (card.isCorrect) return;

    card.isClicked = !card.isClicked;
    pairCardList.add(card);

    if (pairCardList.length == 2) {
      compareCard();
    }

    notifyListeners();
  }

  void compareCard() {
    var card1 = pairCardList[0];
    var card2 = pairCardList[1];
    if (card1.pairId == card2.pairId && card1.displayName != card2.displayName) {
      print('pair!!');
      card1.isCorrect = true;
      card2.isCorrect = true;
    } else {
      card1.isClicked = false;
      card2.isClicked = false;
    }
    pairCardList = [];
  }
}
