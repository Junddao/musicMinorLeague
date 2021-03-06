import 'package:music_minorleague/model/view/page/email_login/email_login_page.dart';
import 'package:music_minorleague/model/view/page/login_page.dart';
import 'package:music_minorleague/model/view/page/music_player/my_music_player_page.dart';
import 'package:music_minorleague/model/view/page/playlist/my_play_list_page.dart';
import 'package:music_minorleague/model/view/page/tab_page.dart';
import 'package:music_minorleague/model/view/page/upload/upload_music_page.dart';
import 'package:music_minorleague/model/view/page/user_profile/my_profile_modify_page.dart';
import 'package:music_minorleague/rootpage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'model/view/onboarding_screen_page.dart';
import 'model/view/page/user_profile/my_music_modify_page.dart';
import 'model/view/page/user_profile/my_profile_modify_page.dart';
import 'model/view/page/user_profile/other_user_profile_page.dart';

class Routers {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    var arguments = settings.arguments;

    switch (settings.name) {
      case 'RootPage':
        return CupertinoPageRoute(builder: (_) => RootPage());
      case 'LoginPage':
        return CupertinoPageRoute(builder: (_) => LoginPage());
      case 'EmailLoginPage':
        return CupertinoPageRoute(builder: (_) => EmailLoginPage());
      case 'TabPage':
        return CupertinoPageRoute(builder: (_) => TabPage());
      case 'UploadMusicPage':
        return CupertinoPageRoute(builder: (_) => UploadMusicPage());
      case 'MyMusicPlayerPage':
        // return CupertinoPageRoute(builder: (_) => MyMusicPlayerPage());
        return PageRouteBuilder(
          transitionDuration: Duration(milliseconds: 500),
          pageBuilder: (BuildContext context, Animation<double> animation,
              Animation<double> secondaryAnimation) {
            return MyMusicPlayerPage();
          },
          transitionsBuilder: (BuildContext context,
              Animation<double> animation,
              Animation<double> secondaryAnimation,
              Widget child) {
            return Align(
              child: child,
              // child: FadeTransition(
              //   opacity: animation,
              //   child: child,
              // ),
            );
          },
        );
      case 'MyPlayListPage':
        return CupertinoPageRoute(builder: (_) => MyPlayListPage());
      case 'MyProfileModifyPage':
        return CupertinoPageRoute(builder: (_) => MyProfileModifyPage());
      case 'MyMusicModifyPage':
        return CupertinoPageRoute(builder: (_) => MyMusicModifyPage());
      case 'OnBoardingScreenPage':
        return CupertinoPageRoute(builder: (_) => OnboardingScreenPage());
      case 'OtherUserProfilePage':
        return CupertinoPageRoute(
            builder: (_) => OtherUserProfilePage(otherUserProfile: arguments));

      // case 'ClassProceedingPage':
      //   return CupertinoPageRoute(
      //       builder: (_) => ClassProceedingPage(id: arguments));

      // case 'GuestProfilePage':
      //   return CupertinoPageRoute(
      //       builder: (_) => ChangeNotifierProvider(
      //             create: (_) =>
      //                 OtherUserProfileProvider('${UserInfo.myProfile.id}'),
      //             child: GuestProfilePage(),
      //           ));

      default:
        return CupertinoPageRoute(
            builder: (_) => Scaffold(
                  body: Center(
                    child:
                        Text('${settings.name} 는 lib/route.dart에 정의 되지 않았습니다.'),
                  ),
                ));
    }
  }
}
