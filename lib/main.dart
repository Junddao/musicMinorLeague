import 'package:firebase_core/firebase_core.dart';
import 'package:music_minorleague/model/provider/now_play_music_provider.dart';
import 'package:music_minorleague/route.dart';
import 'package:music_minorleague/splash_screen.dart';
import 'package:music_minorleague/tabstates.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'model/provider/user_profile_provider.dart';
import 'model/view/style/colors.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    new MyApp(),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<UserProfileProvider>(
          create: (_) => UserProfileProvider(),
        ),
        ChangeNotifierProvider<TabStates>(
          create: (_) => TabStates(),
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
        initialRoute: '/',
        onGenerateRoute: Routers.generateRoute,
        home: SplashScreen(),
      ),
    );
  }
}
