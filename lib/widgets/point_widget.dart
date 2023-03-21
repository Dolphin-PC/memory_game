import 'package:card_memory_game/ads/ad_rewarded.dart';
import 'package:card_memory_game/common/widgets/dialogs.dart';
import 'package:card_memory_game/common/widgets/toasts.dart';
import 'package:card_memory_game/main.dart';
import 'package:card_memory_game/providers/point_provider.dart';
import 'package:card_memory_game/screens/point_history_screen.dart';
import 'package:card_memory_game/styles/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';

class PointWidget extends StatefulWidget {
  const PointWidget({Key? key}) : super(key: key);

  @override
  State<PointWidget> createState() => _PointWidgetState();
}

class _PointWidgetState extends State<PointWidget> {
  AdRewarded adRewarded = AdRewarded();

  @override
  void initState() {
    super.initState();
    adRewarded.loadRewardedAd();
  }

  @override
  Widget build(BuildContext context) {
    PointProvider pointProvider = Provider.of(context, listen: true);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Column(
          children: [
            IconButton(
              icon: const Icon(Icons.control_point_duplicate),
              onPressed: () {
                Dialogs.confirmDialog(
                  context: context,
                  contentText: "광고를 시청하면, 츄르를 ${PointType.watchAds}개를 준다냥",
                  succBtnName: "시청",
                  succFn: () {
                    adRewarded.rewardedAd?.show(
                      onUserEarnedReward: (_, RewardItem reward) {
                        logger.d("광고 시청 완료, ${reward.type}");
                        pointProvider.addPoint(PointType.watchAds);
                        Toasts.show(msg: "츄르 5개를 얻었다냥");
                      },
                    );
                    Navigator.pop(context);
                  },
                );
              },
            ),
            Text('츄르', style: TextStyles.labelText)
          ],
        ),
        const SizedBox(width: 8),
        FutureBuilder(
          future: pointProvider.point,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (!snapshot.hasData) return const Text('0');
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    fullscreenDialog: true,
                    builder: (context) => const PointHistoryScreen(),
                  ),
                );
              },
              child: Text(
                'X ${snapshot.data}',
                style: TextStyles.plainText,
              ),
            );
          },
        ),
      ],
    );
  }
}
