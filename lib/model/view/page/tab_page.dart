import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter_svg/svg.dart';
import 'package:music_minorleague/model/provider/thumb_up_provider.dart';
import 'package:music_minorleague/model/provider/user_profile_provider.dart';

import 'package:music_minorleague/model/view/page/lounge/lounge_page.dart';
import 'package:music_minorleague/model/view/page/playlist/my_play_list_page.dart';
import 'package:music_minorleague/model/view/page/user_profile/my_profile_page.dart';
import 'package:music_minorleague/model/view/style/colors.dart';
import 'package:music_minorleague/model/view/style/size_config.dart';
import 'package:music_minorleague/model/view/style/textstyles.dart';
import 'package:music_minorleague/tabstates.dart';
import 'package:flutter/material.dart';

import 'package:music_minorleague/utils/push_manager.dart';

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
    SizedBox.shrink(), // empty widget
    MyProfilePage(),
  ];

  @override
  void initState() {
    PushManager().registerToken();
    PushManager().listenFirebaseMessaging();

    ThumbUpData thumbUpData = new ThumbUpData();
    thumbUpData.todayCnt = 3;
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      context.read<ThumbUpProvider>().thumbUpData = thumbUpData;
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        setState(() {
          print("You can not get out of here! kkk");
        });
        return Future(() => false);
      },
      child: Consumer<TabStates>(
        builder: (context, value, child) => Scaffold(
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
                  icon: Icon(
                    Icons.home,
                    size: 20,
                  ),
                  label: '라운지',
                ), //
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.queue_music_outlined,
                    size: 20,
                  ),
                  label: '내가 찜한 노래',
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.add_circle_outline_outlined,
                    size: 30,
                  ),
                  label: '등록하기',
                ),

                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.music_note_rounded,
                    size: 20,
                  ),
                  label: '플레이어',
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.person,
                    size: 20,
                  ),
                  label: '프로필',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _onItemTapped(int index) {
    if (index == 2) {
      context.read<UserProfileProvider>().userProfileData.id == 'Guest'
          ? showCancelDialog(context)
          : _settingModalBottomSheet(context, index);
    } else if (index == 3) {
      _noneNaviBarPage('MyMusicPlayerPage');
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
                      SvgPicture.asset(
                        'assets/icons/error_outline-24px.svg',
                        color: MColors.tomato,
                      ),
                      SizedBox(height: 10),
                      Text(
                        '준비중',
                        style: MTextStyles.medium14Tomato,
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

  Future<void> showCancelDialog(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14.0)), //this right here

          child: Container(
            width: 270,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 20),
                Text(
                  '잠시만요',
                  style: MTextStyles.bold16Tomato,
                ),
                SizedBox(height: 4),
                Text('Guest는 음악을 등록할 수 없습니다.',
                    style: MTextStyles.regular12Grey06),
                SizedBox(height: 20),
                Divider(height: 0),
                Container(
                  height: 43.5,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: FlatButton(
                          onPressed: () {
                            Navigator.pop(context, false);
                          },
                          child: Text('확인'),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
