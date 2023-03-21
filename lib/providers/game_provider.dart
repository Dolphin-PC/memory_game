import 'package:card_memory_game/models/stage_info_model.dart';
import 'package:card_memory_game/providers/point_provider.dart';
import 'package:flutter/material.dart';

import '../models/card_model.dart';

class GameProvider extends ChangeNotifier {
  List<CardModel> initCardList = [], pairCardList = [], correctedCardList = [], remainCardList = [];
  bool isAllCorrect = false, isAllUnCorrect = false, isClickable = false;
  // 생명
  int remainLife = 3;
  // pair수(=stageIdx+1)
  int? pairLength;
  // 카드 TYPE
  CardType selectedCardType = CardType.text;
  // 현재 스테이지 정보
  late StageInfoModel stageInfoModel;

  /// 게임시작 전, 초기화
  void preInit({required StageInfoModel stageInfoModel}) {
    this.stageInfoModel = stageInfoModel;
    initCardList = initCardType();
    pairLength = stageInfoModel.stageIdx + 1;
  }

  /// 카드 type에 따라 초기화
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
          for (int i = 1; i <= stageInfoModel.stageIdx + 1; i++) {
            for (int j = 1; j <= stageInfoModel.roundIdx; j++) {
              resultList.add(CardModel(pairId: j.toString(), displayName: j.toString()));
            }
          }
          // for (int i = 1; i <= 8; i++) {
          //   resultList.add(CardModel(pairId: i.toString(), displayName: i.toString()));
          //   resultList.add(CardModel(pairId: i.toString(), displayName: i.toString()));
          // }
          return resultList;
        }
    }
  }

  /// 게임 시작
  void gameStart() {
    gameReset();

    initCardList.shuffle();

    /// 카드 초기화 (앞면)
    for (var element in initCardList) {
      element.isInit = true;
    }
    isClickable = false;

    /// 카드 뒤집기 (뒷면)
    Future.delayed(const Duration(milliseconds: 3000), () {
      for (var element in initCardList) {
        element.isInit = false;
      }
      isClickable = true;
      notifyListeners();
    });
    notifyListeners();
  }

  /// 게임초기화(초기세팅 시 / 게임종료 시)
  void gameReset() {
    /// 생명 리셋
    remainLife = 3;

    /// 정답 여부 리셋
    isAllUnCorrect = false;
    isAllCorrect = false;
    // initCardList = [];

    /// 카드 배열 리셋
    pairCardList = [];
    correctedCardList = [];
    initCardList.forEach((element) => element.resetCard());
    remainCardList = [...initCardList];
  }

  /// 카드 1개 클릭
  void cardClick(CardModel card) {
    if (card.isCorrect || card.isClicked || !isClickable) return;

    card.isClicked = !card.isClicked;
    pairCardList.add(card);

    if (pairCardList.length >= pairLength!) {
      compareCard();
    }

    notifyListeners();
  }

  /// 선택한 카드 비교
  void compareCard() {
    isClickable = false;

    String firstPairId = pairCardList.first.pairId;
    bool isEqual = pairCardList.every((card) => card.pairId == firstPairId);

    if (isEqual) {
      correctCard(pairCardList: pairCardList, firstPairId: firstPairId);
    } else {
      if (allUnCorrect()) return;

      List<CardModel> copyPairCardList = [...pairCardList];
      Future.delayed(const Duration(milliseconds: 1000), () {
        for (CardModel pairCard in copyPairCardList) {
          pairCard.isClicked = false;
        }
        isClickable = true;
        notifyListeners();
      });
    }

    pairCardList = [];
  }

  /// 1-pair 카드 정답
  void correctCard({required String firstPairId, required List<CardModel> pairCardList}) {
    for (CardModel pairCard in pairCardList) {
      pairCard.isCorrect = true;
      correctedCardList.add(pairCard);
    }

    remainCardList.removeWhere((element) => element.pairId == firstPairId);
    allCorrect();
    isClickable = true;
  }

  /// 카드 전체 정답(=스테이지 성공)
  void allCorrect() {
    isAllCorrect = initCardList.every((card) => card.isCorrect == true);
  }

  /// 카드 전체실패 (=스테이지 실패)
  bool allUnCorrect() {
    if (--remainLife <= 0) {
      isAllUnCorrect = true;

      notifyListeners();
      return true;
    }
    return false;
  }

  /// test용 메소드
  void testComplete() {
    isAllCorrect = true;
    notifyListeners();
  }

  /// 아이템 - 하트충전
  void useItemAddHeart({required PointProvider pointProvider}) {
    /// 포인트 차감
    pointProvider.minusPoint(PointType.itemAddHeart);

    remainLife++;
    notifyListeners();
  }

  /// 아이템 - 다시보기
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

  /// 아이템 - 짝맞추기
  void useItemDonePair({required PointProvider pointProvider}) {
    /// 포인트 차감
    pointProvider.minusPoint(PointType.itemDonePair);

    CardModel firstCard = remainCardList.first;
    List<CardModel> pairList = remainCardList.where((element) => element.pairId == firstCard.pairId).toList();
    correctCard(pairCardList: pairList, firstPairId: firstCard.pairId);

    /// 선택된 카드들 전부 초기화
    for (var card in pairCardList) {
      card.isClicked = false;
    }
    pairCardList = [];
    notifyListeners();
  }
}
