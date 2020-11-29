import 'package:music_minorleague/model/view/page/login_page.dart';
import 'package:music_minorleague/model/view/page/music_player/my_music_player_page.dart';
import 'package:music_minorleague/model/view/page/playlist/my_play_list_page.dart';
import 'package:music_minorleague/model/view/page/tab_page.dart';
import 'package:music_minorleague/model/view/page/upload/upload_music_page.dart';
import 'package:music_minorleague/rootpage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Routers {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    var arguments = settings.arguments;

    switch (settings.name) {
      case 'RootPage':
        return CupertinoPageRoute(builder: (_) => RootPage());
      case 'LoginPage':
        return CupertinoPageRoute(builder: (_) => LoginPage());
      case 'TabPage':
        return CupertinoPageRoute(builder: (_) => TabPage());
      case 'UploadMusicPage':
        return CupertinoPageRoute(builder: (_) => UploadMusicPage());
      case 'MyMusicPlayerPage':
        return CupertinoPageRoute(builder: (_) => MyMusicPlayerPage());
      case 'MyPlayListPage':
        return CupertinoPageRoute(
            builder: (_) => MyPlayListPage(selectedMusicList: arguments));

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
