import 'package:card_memory_game/common/widgets/dialogs.dart';
import 'package:card_memory_game/providers/point_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/game_provider.dart';

class GameItems extends StatefulWidget {
  const GameItems({Key? key}) : super(key: key);

  @override
  State<GameItems> createState() => _GameItemState();
}

class _GameItemState extends State<GameItems> {
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
                contentText: "${PointType.itemAddHeart} 츄르를 사용해서\n1 하트를 충전한다냥",
                succBtnName: "사용",
                succFn: () async {
                  if (await pointProvider.point - PointType.itemAddHeart < 0) {
                    return Dialogs.defaultDialog(context: context, contentText: "츄르가 부족하다냥", succBtnName: "닫기");
                  }
                  if (gameProvider.remainLife == 3) {
                    return Dialogs.defaultDialog(context: context, contentText: "하트가 이미 가득하다냥", succBtnName: "닫기");
                  }
                  gameProvider.useItemAddHeart(pointProvider: pointProvider);
                  Navigator.pop(context);
                });
          },
        ),

        /// [다시보기] 아이템
        IconButton(
          icon: const Icon(Icons.search),
          onPressed: () {
            Dialogs.confirmDialog(
                context: context,
                contentText: "${PointType.itemReview} 츄르를 사용해서\n3초간 다시 본다냥",
                succBtnName: "사용",
                succFn: () async {
                  if (await pointProvider.point - PointType.itemReview < 0) {
                    return Dialogs.defaultDialog(context: context, contentText: "츄르가 부족하다냥", succBtnName: "닫기");
                  }
                  gameProvider.useItemReview(pointProvider: pointProvider);
                  Navigator.pop(context);
                });
          },
        ),

        /// [1페어 맞추기] 아이템
        IconButton(
          icon: const Icon(Icons.done_all),
          onPressed: () {
            Dialogs.confirmDialog(
                context: context,
                contentText: "${PointType.itemDonePair} 츄르를 사용해서\n한쌍의 카드를 맞춘다냥",
                succBtnName: "사용",
                succFn: () async {
                  if (await pointProvider.point - PointType.itemDonePair < 0) {
                    return Dialogs.defaultDialog(context: context, contentText: "츄르가 부족하다냥", succBtnName: "닫기");
                  }
                  gameProvider.useItemDonePair(pointProvider: pointProvider);
                  Navigator.pop(context);
                });
          },
        ),
      ],
    );
  }
}
