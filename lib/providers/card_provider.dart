import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

@immutable
class CardModel {
  const CardModel({required this.displayName, required this.pairId});

  final String pairId;
  final String displayName;
}


// 값의 변화를 관리
class CardNotifier extends StateNotifier<List<CardModel>> {
  CardNotifier(): super([]);

  List<String> initList = [
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

  add(CardModel cardModel){
    print(cardModel);
    state = [...state, cardModel];
  }

  set(List<CardModel> cardList){
    state = cardList;
  }

  init() {
    state = List.generate(initList.length, (i) => CardModel(displayName: i.toString(), pairId: initList[i]));
  }

}

final cardProvider = StateNotifierProvider<CardNotifier, List<CardModel>>((ref) {
  return CardNotifier();
});