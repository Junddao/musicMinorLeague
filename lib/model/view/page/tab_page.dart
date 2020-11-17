import 'package:flutter_svg/svg.dart';
import 'package:music_minorleague/model/view/page/lounge/lounge_page.dart';
import 'package:music_minorleague/model/view/page/playlist/my_play_list_page.dart';
import 'package:music_minorleague/model/view/page/user_profile_page.dart';
import 'package:music_minorleague/model/view/style/colors.dart';
import 'package:music_minorleague/model/view/style/size_config.dart';
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
    MyPlayListPage(),
    SizedBox.shrink(), // empty widget
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
                        label: '라운지',
                      ), //
                      BottomNavigationBarItem(
                        icon: Icon(Icons.queue_music_outlined),
                        label: '내 재생목록',
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(Icons.add_circle_outline_outlined),
                        label: '등록하기',
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(Icons.person),
                        label: '프로필',
                      ),
                    ]))));
  }

  void _onItemTapped(int index) {
    if (index == 2) {
      _settingModalBottomSheet(context, index);
    } else {
      Provider.of<TabStates>(context, listen: false).selectedIndex = index;
    }
  }

  void _settingModalBottomSheet(parentContext, index) {
    showModalBottomSheet(
      context: parentContext,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(16), topRight: Radius.circular(16))),
      builder: (BuildContext context) {
        return Container(
          height: SizeConfig.screenHeight * 0.18,
          child: new Row(
            children: <Widget>[
              Expanded(
                flex: 1,
                child: InkWell(
                  onTap: () {
                    setState(() {
                      Navigator.pop(context);
                      _noneNaviBarPage('UploadMusicPage');
                    });
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset('assets/icons/cloud_upload.svg'),
                      SizedBox(height: 10),
                      Text(
                        '업로드',
                        style: MTextStyles.medium14Grey06,
                      )
                    ],
                  ),
                ),
              ),
              Container(
                height: SizeConfig.screenHeight * 0.14,
                width: 2,
                decoration: BoxDecoration(
                    border: Border.all(
                  color: MColors.white_three,
                )),
              ),
              Expanded(
                flex: 1,
                child: InkWell(
                  onTap: () async {},
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset('assets/icons/cloud_download.svg'),
                      SizedBox(height: 10),
                      Text(
                        '다운로드',
                        style: MTextStyles.medium14Grey06,
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _noneNaviBarPage(String page) {
    Navigator.of(context).pushNamed(page);
  }
}
