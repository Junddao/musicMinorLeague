import 'dart:io';

import 'package:firebase_admob/firebase_admob.dart';

class AdMobService {
  String getAdMobID() {
    if (Platform.isIOS) {
      return 'ca-app-pub-9695790043722201~3375902957';
    } else if (Platform.isAndroid) {
      return "ca-app-pub-9695790043722201~2171273127";
    }
    return null;
  }

  String getBannerAdID() {
    if (Platform.isIOS) {
    } else if (Platform.isAndroid) {
      // return "ca-app-pub-9695790043722201/8889394257";
    }
    return null;
  }

  String getInterstitialAdId() {
    if (Platform.isIOS) {
      return 'ca-app-pub-9695790043722201/5618922910'; // 내꺼
      // return 'ca-app-pub-3940256099942544/4411468910'; // test광고
    } else if (Platform.isAndroid) {
      // my admob
      return "ca-app-pub-9695790043722201/5374368577"; // 내꺼
      // return 'ca-app-pub-3940256099942544/1033173712'; //test 광고
    }
    return null;
  }

  String getAppOpenAdId() {
    if (Platform.isIOS) {
      return 'ca-app-pub-9695790043722201/4857162122';
    } else if (Platform.isAndroid) {
      return 'ca-app-pub-9695790043722201/1433740677';
    }
  }

  InterstitialAd getNewInterstitial() {
    return InterstitialAd(
      adUnitId: getInterstitialAdId(),
      listener: (MobileAdEvent event) {
        print("InterstitialAd event is $event");
      },
    );
  }
}
