import 'package:card_memory_game/ads/ad_rewarded.dart';
import 'package:card_memory_game/common/widgets/dialogs.dart';
import 'package:card_memory_game/common/widgets/toasts.dart';
import 'package:card_memory_game/main.dart';
import 'package:card_memory_game/providers/point_provider.dart';
import 'package:card_memory_game/screens/point_history_screen.dart';
import 'package:card_memory_game/styles/button_styles.dart';
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
        GestureDetector(
          onTap: () {
            Dialogs.confirmDialog(
              context: context,
              titleText: "츄르 충전",
              succBtnName: "광고시청",
              succFn: () {
                adRewarded.rewardedAd?.show(
                  onUserEarnedReward: (_, RewardItem reward) {
                    logger.d("광고 시청 완료, ${reward.type}");
                    pointProvider.addPoint(PointType.watchAds);
                    Toasts.show(msg: "츄르 5개를 얻었다냥");
                  },
                );
              },
              contentWidget: SizedBox(
                child: Column(
                  children: [
                    const Divider(height: 10, color: Colors.grey),
                    Text(
                      "광고를 시청하면\n 츄르를 ${PointType.watchAds}개를 준다냥",
                      style: TextStyles.plainText,
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 10),
                    Image.asset("assets/images/kitty.png", width: 50),
                    const Divider(height: 10, color: Colors.grey),
                  ],
                ),
              ),
            );
          },
          child: Image.asset("assets/icons/chur.png", width: 30),
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
