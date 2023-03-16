import 'package:card_memory_game/main.dart';
import 'package:card_memory_game/providers/point_provider.dart';
import 'package:flutter/material.dart';

import '../models/card_model.dart';

class GameProvider extends ChangeNotifier {
  List<CardModel> initCardList = [], pairCardList = [], correctedCardList = [], remainCardList = [];

  int remainLife = 3;

  bool isAllCorrect = false, isAllUnCorrect = false, isClickable = false;

  CardType selectedCardType = CardType.text;

  void init() {
    remainLife = 3;

    gameOver();
    initCardList = initCardType();

    remainCardList = [...initCardList];
    initCardList.shuffle();
    notifyListeners();
  }

  List<CardModel> initCardType() {
    List<CardModel> resultList = [];
    switch (selectedCardType) {
      case CardType.image:
        {
          for (int i = 1; i <= 8; i++) {
            resultList.add(CardModel(pairId: i.toString(), displayName: i.toString()));
            resultList.add(CardModel(pairId: i.toString(), displayName: i.toString()));
          }
          return resultList;
        }
      case CardType.icon:
        {
          for (int i = 1; i <= 8; i++) {
            resultList.add(CardModel(pairId: i.toString(), displayName: i.toString()));
            resultList.add(CardModel(pairId: i.toString(), displayName: i.toString()));
          }
          return resultList;
        }
      default:
        {
          for (int i = 1; i <= 8; i++) {
            resultList.add(CardModel(pairId: i.toString(), displayName: i.toString()));
            resultList.add(CardModel(pairId: i.toString(), displayName: i.toString()));
          }
          return resultList;
        }
    }
  }

  void gameStart() {
    init();
    for (var element in initCardList) {
      element.isInit = true;
    }
    isClickable = false;
    Future.delayed(const Duration(milliseconds: 3000), () {
      for (var element in initCardList) {
        element.isInit = false;
      }
      isClickable = true;
      notifyListeners();
    });
    notifyListeners();
  }

  void gameOver() {
    isAllUnCorrect = false;
    isAllCorrect = false;
    initCardList = [];
    pairCardList = [];
    correctedCardList = [];
    remainCardList = [];
  }

  void cardClick(CardModel card) {
    if (card.isCorrect || card.isClicked || !isClickable) return;

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
    if (card1.pairId == card2.pairId) {
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
    logger.d(pairCardList.map((item) => item.pairId));
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
    List<CardModel> pairList = remainCardList.where((element) => element.pairId == firstCard.pairId).toList();
    correctCard(pairList[0], pairList[1]);

    notifyListeners();
  }
}
