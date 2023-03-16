class CardModel {
  CardModel({required this.displayName, required this.pairId}) {
    cardType = CardType.text;
  }

  CardModel.typeImage({required this.displayName, required this.pairId, required this.imageName}) {
    cardType = CardType.image;
  }

  CardModel.typeIcon({required this.displayName, required this.pairId, required this.iconName}) {
    cardType = CardType.icon;
  }

  final String pairId;
  final String displayName;

  bool isCorrect = false, isClicked = false, isInit = false, isView = false;

  CardType? cardType;

  String? imageName = "";
  String? iconName = "";
}

enum CardType { text, image, icon }
