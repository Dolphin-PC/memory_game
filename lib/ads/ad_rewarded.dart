import 'package:card_memory_game/ads/ad_helper.dart';
import 'package:card_memory_game/main.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdRewarded {
  late RewardedAd? rewardedAd;
  bool isAvailableAds = true;

  loadRewardedAd() {
    RewardedAd.load(
      adUnitId: AdHelper.rewardedAdUnitId,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {
              ad.dispose();
              rewardedAd = null;

              loadRewardedAd();
            },
          );

          rewardedAd = ad;
          isAvailableAds = true;
        },
        onAdFailedToLoad: (err) {
          rewardedAd = null;
          isAvailableAds = false;

          logger.d('Failed to load a rewarded ad: ${err.message}');
        },
      ),
    );
  }
}
