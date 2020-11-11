import 'package:music_minorleague/model/view/page/lounge/lounge_page.dart';
import 'package:music_minorleague/model/view/page/search_page.dart';
import 'package:music_minorleague/model/view/page/user_profile_page.dart';
import 'package:music_minorleague/model/view/page/write_page.dart';
import 'package:music_minorleague/model/view/style/textstyles.dart';
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
    WritePage(),
    SearchPage(),
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
                    // sets the background color of the `BottomNavigationBar`
                    canvasColor: Colors.white,
                    // sets the active color of the `BottomNavigationBar` if `Brightness` is light
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
                        icon: Icon(Icons.create),
                        title: Text('글쓰기'),
                      ), // 계약서 작성 페이지
                      BottomNavigationBarItem(
                        icon: Icon(Icons.search),
                        title: Text('찾기'),
                      ), // 내 계정 확인, 작성 문서찾기
                      BottomNavigationBarItem(
                        icon: Icon(Icons.person),
                        title: Text('프로필'),
                      ), // 내 계정 확인, 작성 문서찾기
                    ]))));
  }

  Text getTitleText() {
    String titleText;

    if (Provider.of<TabStates>(context).selectedIndex == 0) titleText = '라운지';
    if (Provider.of<TabStates>(context).selectedIndex == 1) titleText = '글쓰기';
    if (Provider.of<TabStates>(context).selectedIndex == 2) titleText = '찾기';
    if (Provider.of<TabStates>(context).selectedIndex == 3) titleText = '프로필';

    return Text(
      titleText,
      style: MTextStyles.bold18Black,
    );
  }

  void _onItemTapped(int value) {
    Provider.of<TabStates>(context, listen: false).selectedIndex = value;
  }
}
