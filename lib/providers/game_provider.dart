import 'package:card_memory_game/main.dart';
import 'package:card_memory_game/providers/point_provider.dart';
import 'package:flutter/material.dart';

import '../models/card_model.dart';

class GameProvider extends ChangeNotifier {
  List<CardModel> initCardList = [], pairCardList = [], correctedCardList = [], remainCardList = [];

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
    gameOver();
    remainCardList = initCardList = List.generate(initList.length, (i) => CardModel(displayName: i.toString(), pairId: initList[i]));
    remainCardList = [...initCardList];
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
    initCardList = pairCardList = correctedCardList = remainCardList = [];
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
    CardModel card1 = pairCardList[0];
    CardModel card2 = pairCardList[1];
    if (card1.pairId == card2.pairId && card1.displayName != card2.displayName) {
      correctCard(card1, card2);
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

  void correctCard(CardModel card1, CardModel card2) {
    card1.isCorrect = true;
    card2.isCorrect = true;
    correctedCardList.add(card1);
    correctedCardList.add(card2);
    remainCardList.removeWhere((element) => element.pairId == card1.pairId);
    allCorrect();
    isClickable = true;
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

  void useItemAddHeart({required PointProvider pointProvider}) {
    /// 포인트 차감
    pointProvider.minusPoint(PointType.itemAddHeart);

    remainLife++;
    notifyListeners();
  }

  void useItemReview({required PointProvider pointProvider}) {
    /// 포인트 차감
    pointProvider.minusPoint(PointType.itemReview);

    for (var card in remainCardList) {
      card.isView = true;
    }
    Future.delayed(const Duration(milliseconds: 3000), () {
      for (var element in remainCardList) {
        element.isView = false;
      }
      notifyListeners();
    });
    notifyListeners();
  }

  void useItemDonePair({required PointProvider pointProvider}) {
    /// 포인트 차감
    pointProvider.minusPoint(PointType.itemDonePair);

    CardModel firstCard = remainCardList.first;
    List<CardModel> pairCardList = remainCardList.where((element) => element.pairId == firstCard.pairId).toList();
    correctCard(pairCardList[0], pairCardList[1]);

    notifyListeners();
  }
}
