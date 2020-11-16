import 'package:music_minorleague/model/view/page/lounge/lounge_page.dart';
import 'package:music_minorleague/model/view/page/playlist/my_play_list_page.dart';
import 'package:music_minorleague/model/view/page/search_page.dart';
import 'package:music_minorleague/model/view/page/upload/upload_music_page.dart';
import 'package:music_minorleague/model/view/page/user_profile_page.dart';
import 'package:music_minorleague/tabstates.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TabPage extends StatefulWidget {
  @override
  _TabPageState createState() => _TabPageState();
}

class _TabPageState extends State<TabPage> {
  final List<Widget> _tabs = [
    LoungePage(),
    MyPlayListPage(),
    UploadMusicPage(),
    UserProfilePage(),
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TabStates>(
        builder: (context, value, child) => Scaffold(
            // appBar: AppBar(
            //   automaticallyImplyLeading: false,
            //   leading: IconButton(
            //     icon: Icon(Icons.menu_outlined),
            //   ),
            //   title: getTitleText(),
            //   backgroundColor: Colors.transparent,
            //   elevation: 0.0,
            // ),
            body: _tabs[Provider.of<TabStates>(context).selectedIndex],
            bottomNavigationBar: new Theme(
                data: Theme.of(context).copyWith(
                    canvasColor: Colors.white,
                    primaryColor: Colors.red,
                    textTheme: Theme.of(context).textTheme.copyWith(
                        caption: new TextStyle(
                            color: Colors
                                .grey))), // sets the inactive color of the `BottomNavigationBar`

                child: new BottomNavigationBar(
                    onTap: _onItemTapped,
                    type: BottomNavigationBarType.fixed,
                    currentIndex: value.selectedIndex,
                    items: <BottomNavigationBarItem>[
                      // BottomNavigationBarItem(
                      //     icon: Icon(Icons.mic),
                      //     title: Text('녹음')), // 뭘 보여줘야 할까...
                      BottomNavigationBarItem(
                        icon: Icon(Icons.home),
                        title: Text('라운지'),
                      ), //
                      BottomNavigationBarItem(
                        icon: Icon(Icons.queue_music_outlined),
                        title: Text('내 재생목록'),
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(Icons.add_circle_outline_outlined),
                        title: Text('등록하기'),
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(Icons.person),
                        title: Text('프로필'),
                      ),
                    ]))));
  }

  void _onItemTapped(int value) {
    Provider.of<TabStates>(context, listen: false).selectedIndex = value;
  }
}
