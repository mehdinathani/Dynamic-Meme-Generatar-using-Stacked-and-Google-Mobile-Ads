import 'dart:async';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:memegeneraterappusingstacked/config/config.dart';
import 'package:stacked/stacked.dart';

class AdmobService with ListenableServiceMixin {
  late BannerAd bannerAd;
  late InterstitialAd interstitialAd;
  late RewardedAd rewardedAd;
  bool isInterstitialAdLoaded = false;
  int rewardedScore = 0;
  bool isRewardedAdLoaded = false;

  AdmobService() {
    _loadBannerAd();
    _loadInterstitialAd();
    _loadRewardedAd();
  }
  void _loadBannerAd() {
    bannerAd = BannerAd(
      adUnitId: Config.bannerAdUnitID,
      size: AdSize.banner,
      request: const AdRequest(),
      listener: const BannerAdListener(),
    )..load();
  }

  void _loadInterstitialAd() {
    InterstitialAd.load(
      adUnitId: Config.interstitialAdUnitIDTest,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(onAdLoaded: (ad) {
        interstitialAd = ad;
        isInterstitialAdLoaded = true;
        notifyListeners();
        interstitialAd.fullScreenContentCallback = FullScreenContentCallback(
          onAdDismissedFullScreenContent: (ad) {
            ad.dispose();
            isInterstitialAdLoaded = false;
            notifyListeners();
            debugPrint("Ad is Dismissed");
          },
          onAdFailedToShowFullScreenContent: (ad, error) {
            ad.dispose();
            isInterstitialAdLoaded = false;
            notifyListeners();
            debugPrint("Ad is Dismissed");
          },
        );
      }, onAdFailedToLoad: ((error) {
        interstitialAd.dispose();
      })),
    );
  }

  void _loadRewardedAd() {
    RewardedAd.load(
      adUnitId: Config.rewardedAdUnitIDTest,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(onAdLoaded: (ad) {
        rewardedAd = ad;
        isRewardedAdLoaded = true;
        notifyListeners();
      }, onAdFailedToLoad: (error) {
        rewardedAd.dispose();
      }),
    );
  }

  void showInterstitialAd() {
    if (isInterstitialAdLoaded) {
      interstitialAd.show().then((_) {
        _loadInterstitialAd();
      }).catchError((error) {
        debugPrint('Failed to show interstitial ad: $error');
        _loadInterstitialAd();
      });
    } else {
      debugPrint('Interstitial Ad not loaded. Attempting to load...');
      _loadInterstitialAd();
    }
  }

  void callBackshowInterstitialAd() {
    if (!isInterstitialAdLoaded) {
      _loadInterstitialAd();
      showInterstitialAd();
    }
  }

  Future<void> showRewardedAd() async {
    if (isRewardedAdLoaded) {
      Completer<void> adCompleter = Completer<void>();

      rewardedAd.fullScreenContentCallback = FullScreenContentCallback(
        onAdDismissedFullScreenContent: (ad) {
          ad.dispose();
          _loadRewardedAd();
          adCompleter.complete();
        },
        onAdFailedToShowFullScreenContent: (ad, error) {
          ad.dispose();
          _loadRewardedAd();
          adCompleter.completeError("Failed to show rewarded ad: $error");
        },
      );

      rewardedAd.show(onUserEarnedReward: (ad, reward) {
        rewardedScore++;
        notifyListeners();
        debugPrint("Total rewarded Score $rewardedScore ");
        adCompleter.complete();
      });

      isRewardedAdLoaded = false;
      notifyListeners();
      return adCompleter.future;
    }
  }

  String generateRandomGuestNumber() {
    Random random = Random();
    return 'Guest${1000 + random.nextInt(9000)}';
  }
}
