import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:music_minorleague/model/provider/mini_widget_status_provider.dart';
import 'package:music_minorleague/model/provider/now_play_music_provider.dart';

import 'package:music_minorleague/route.dart';
import 'package:music_minorleague/splash_screen.dart';
import 'package:music_minorleague/tabstates.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'model/provider/other_user_profile_provider.dart';
import 'model/provider/user_profile_provider.dart';
import 'model/view/style/colors.dart';
import 'model/view/style/custom_animation.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    new MyApp(),
  );
  configLoading();
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
      ],
      child: MaterialApp(
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
        builder: EasyLoading.init(),
      ),
    );
  }
}
