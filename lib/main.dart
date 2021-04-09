import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:flutter_admob_app_open/flutter_admob_app_open.dart';

import 'package:flutter_easyloading/flutter_easyloading.dart';

import 'package:music_minorleague/model/provider/mini_widget_status_provider.dart';
import 'package:music_minorleague/model/provider/now_play_music_provider.dart';
import 'package:music_minorleague/model/provider/thumb_up_provider.dart';

import 'package:music_minorleague/route.dart';
import 'package:music_minorleague/splash_screen.dart';
import 'package:music_minorleague/tabstates.dart';
import 'package:flutter/material.dart';

import 'package:music_minorleague/utils/admob_service.dart';
import 'package:provider/provider.dart';

import 'model/provider/other_user_profile_provider.dart';
import 'model/provider/user_profile_provider.dart';
import 'model/view/style/colors.dart';
import 'model/view/style/custom_animation.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();
  await addAdmob();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  runApp(
    new MyApp(),
  );
  configLoading();
}

Future<void> addAdmob() async {
  AdMobService ams = new AdMobService();
  // final admobAppId = FlutterAdmobAppOpen.testAppId;
  // final appAppOpenAdUnitId = FlutterAdmobAppOpen.testAppOpenAdId;
  final admobAppId = ams.getAdMobID();
  final appAppOpenAdUnitId = ams.getAppOpenAdId();

  MobileAdTargetingInfo targetingInfo = MobileAdTargetingInfo(
    keywords: <String>['flutterio', 'beautiful apps'],
    contentUrl: 'https://flutter.io',
    birthday: DateTime.now(),
    childDirected: false,
    designedForFamilies: false,
    gender:
        MobileAdGender.male, // or MobileAdGender.female, MobileAdGender.unknown
    testDevices: <String>[], // Android emulators are considered test devices
  );

  await FlutterAdmobAppOpen.instance.initialize(
    appId: admobAppId,
    appAppOpenAdUnitId: appAppOpenAdUnitId,
    targetingInfo: targetingInfo,
  );
}

void configLoading() {
  EasyLoading.instance
    ..displayDuration = const Duration(milliseconds: 2000)
    ..indicatorType = EasyLoadingIndicatorType.fadingCircle
    ..loadingStyle = EasyLoadingStyle.dark
    ..indicatorSize = 45.0
    ..radius = 10.0
    ..progressColor = Colors.yellow
    ..backgroundColor = Colors.green
    ..indicatorColor = Colors.yellow
    ..textColor = Colors.yellow
    ..maskColor = Colors.blue.withOpacity(0.5)
    ..userInteractions = true
    ..dismissOnTap = false
    ..customAnimation = CustomAnimation();
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<UserProfileProvider>(
          create: (_) => UserProfileProvider(),
        ),
        ChangeNotifierProvider<OtherUserProfileProvider>(
          create: (_) => OtherUserProfileProvider(),
        ),
        ChangeNotifierProvider<TabStates>(
          create: (_) => TabStates(),
        ),
        ChangeNotifierProvider<MiniWidgetStatusProvider>(
          create: (_) => MiniWidgetStatusProvider(),
        ),
        ChangeNotifierProvider<NowPlayMusicProvider>(
          create: (_) => NowPlayMusicProvider(),
        ),
        ChangeNotifierProvider<ThumbUpProvider>(
          create: (_) => ThumbUpProvider(),
        ),
      ],
      child: MaterialApp(
        navigatorObservers: [HeroController()],
        title: 'MusicMinorLeague',
        theme: ThemeData(
          primaryColor: Colors.white,
          accentColor: MColors.tomato,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        debugShowCheckedModeBanner: false,
        // initialRoute: '/',
        onGenerateRoute: Routers.generateRoute,
        home: SplashScreen(),
        // home: TestPage(),
        builder: EasyLoading.init(),
      ),
    );
  }
}
