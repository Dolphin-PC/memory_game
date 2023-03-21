import 'package:card_memory_game/common/widgets/dialogs.dart';
import 'package:card_memory_game/providers/point_provider.dart';
import 'package:card_memory_game/styles/button_styles.dart';
import 'package:card_memory_game/styles/color_styles.dart';
import 'package:card_memory_game/styles/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/game_provider.dart';

class GameItems extends StatefulWidget {
  const GameItems({Key? key}) : super(key: key);

  @override
  State<GameItems> createState() => _GameItemState();
}

class _GameItemState extends State<GameItems> {
  String itemDialogText = "츄르 아이템 사용";
  Image itemImage = Image.asset("assets/images/chur.png", width: 20);

  Widget commonContentWidget({required String msg, required int itemCnt}) {
    return SizedBox(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Divider(height: 10,color: Colors.grey),
          Text(msg, style: TextStyles.plainText, textAlign: TextAlign.center),
          const SizedBox(height: 10),
          Container(
            decoration: BoxDecoration(
                color: ColorStyles.bgPrimaryColor,
                borderRadius: const BorderRadius.all(Radius.circular(20))
            ),
            // color: Colors.amber,
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  itemImage,
                  const SizedBox(width: 8),
                  Text('$itemCnt')
                ],
              ),
            ),
          ),
          const Divider(height: 10,color: Colors.grey),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    GameProvider gameProvider = Provider.of(context, listen: true);
    PointProvider pointProvider = Provider.of(context, listen: true);
    return Row(
      children: [
        /// [하트충전] 아이템
        IconButton(
          icon: const Icon(Icons.volunteer_activism),
          onPressed: () {
            Dialogs.confirmDialog(
              context: context,
              titleText: itemDialogText,
              succBtnName: "사용",
              succFn: () async {
                if (await pointProvider.point - PointType.itemAddHeart < 0) {
                  return Dialogs.defaultDialog(context: context, contentText: "츄르가 부족하다냥", succBtnName: "닫기");
                }
                if (gameProvider.remainLife == 3) {
                  return Dialogs.defaultDialog(context: context, contentText: "하트가 이미 가득하다냥", succBtnName: "닫기");
                }
                gameProvider.useItemAddHeart(pointProvider: pointProvider);
              },
              contentWidget: commonContentWidget(msg : "츄르를 사용하겠냥?\n[하트충전]", itemCnt: PointType.itemAddHeart),
            );
          },
        ),

        /// [다시보기] 아이템
        IconButton(
          icon: const Icon(Icons.search),
          onPressed: () {
            Dialogs.confirmDialog(
              context: context,
              titleText: itemDialogText,
              succBtnName: "사용",
              succFn: () async {
                if (await pointProvider.point - PointType.itemReview < 0) {
                  return Dialogs.defaultDialog(context: context, contentText: "츄르가 부족하다냥", succBtnName: "닫기");
                }
                gameProvider.useItemReview(pointProvider: pointProvider);
              },
              contentWidget : commonContentWidget(msg : "츄르를 사용하겠냥?\n[다시보기]", itemCnt: PointType.itemReview),
            );
          },
        ),

        /// [1페어 맞추기] 아이템
        IconButton(
          icon: const Icon(Icons.done_all),
          onPressed: () {
            Dialogs.confirmDialog(
              context: context,
              titleText: itemDialogText,
              succBtnName: "사용",
              succFn: () async {
                if (await pointProvider.point - PointType.itemDonePair < 0) {
                  return Dialogs.defaultDialog(context: context, contentText: "츄르가 부족하다냥", succBtnName: "닫기");
                }
                gameProvider.useItemDonePair(pointProvider: pointProvider);
              },
              contentWidget : commonContentWidget(msg : "츄르를 사용하겠냥?\n[짝맞추기]", itemCnt: PointType.itemDonePair),
            );
          },
        ),
      ],
    );
  }
}
