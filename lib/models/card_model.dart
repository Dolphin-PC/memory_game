class CardModel {
  CardModel({required this.displayName, required this.pairId});

  final String pairId;
  final String displayName;

  bool isCorrect = false, isClicked = false, isInit = false;
}
