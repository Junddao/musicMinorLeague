import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:music_minorleague/model/data/music_info_data.dart';
import 'package:music_minorleague/model/enum/lounge_bottom_widget_enum.dart';
import 'package:music_minorleague/model/provider/mini_widget_status_provider.dart';
import 'package:music_minorleague/model/provider/user_profile_provider.dart';
import 'package:music_minorleague/model/view/page/upload/component/upload_result_Dialog.dart';
import 'package:music_minorleague/model/view/style/colors.dart';
import 'package:music_minorleague/model/view/style/size_config.dart';
import 'package:music_minorleague/model/view/style/textstyles.dart';
import 'package:music_minorleague/utils/db_helper.dart';
import 'package:music_minorleague/utils/firebase_db_helper.dart';
import 'package:music_minorleague/utils/play_func.dart';
import 'package:provider/provider.dart';

class MyPlaylistSmallSelectListWidget extends StatefulWidget {
  const MyPlaylistSmallSelectListWidget({
    Key key,
    List<MusicInfoData> musicList,
    List<bool> selectedList,
    Function playOrPauseMusicForSelectedListFunc,
    Function refreshSelectedListAndWidgetFunc,
  })  : _musicList = musicList,
        _selectedList = selectedList,
        _playOrPauseMusicForSelectedListFunc =
            playOrPauseMusicForSelectedListFunc,
        _refreshSelectedListAndWidgetFunc = refreshSelectedListAndWidgetFunc,
        super(key: key);

  final List<MusicInfoData> _musicList;
  final List<bool> _selectedList;

  final Function _playOrPauseMusicForSelectedListFunc;
  final Function _refreshSelectedListAndWidgetFunc;

  @override
  _MyPlaylistSmallSelectListWidget createState() =>
      _MyPlaylistSmallSelectListWidget();
}

class _MyPlaylistSmallSelectListWidget
    extends State<MyPlaylistSmallSelectListWidget> {
  List<MusicInfoData> selectedMusicList = new List<MusicInfoData>();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 0,
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Container(
              height: 100,
              width: SizeConfig.screenWidth,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(
                  Radius.circular(4),
                ),
                border: Border.all(color: MColors.black, width: 0.1),
                color: MColors.white,
                // boxShadow: [
                //   BoxShadow(
                //     color: Colors.grey,
                //     blurRadius: 1.0,
                //   ),
                // ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                          iconSize: 14,
                          icon: Icon(FontAwesomeIcons.play),
                          onPressed: () {
                            getSelectedMusicList();
                            playSelectMusic();
                          }),
                      Text(
                        '선택 항목 재생',
                        style: MTextStyles.regular12Black,
                      ),
                    ],
                  ),
                  VerticalDivider(
                    thickness: 2,
                    indent: 5,
                    endIndent: 5,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                          iconSize: 16,
                          icon: Icon(FontAwesomeIcons.trashAlt),
                          onPressed: () {
                            getSelectedMusicList();
                            // TODO: 업데이트 하도록 구현해야함
                            deleteMyMusicList();
                            setState(() {
                              widget._refreshSelectedListAndWidgetFunc();
                              widget._selectedList.forEach((element) {
                                element = false;
                              });
                            });
                          }),
                      Text(
                        '선택 항목 삭제',
                        style: MTextStyles.regular12Black,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            left: 10,
            child: widget._selectedList == null
                ? SizedBox.shrink()
                : CircleAvatar(
                    radius: 13,
                    backgroundColor: MColors.grey_06,
                    child: CircleAvatar(
                      radius: 12,
                      backgroundColor: MColors.white,
                      child: Text(
                        widget._selectedList
                            .where((element) => element == true)
                            .length
                            .toString(),
                        style: MTextStyles.bold12Black,
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  void getSelectedMusicList() {
    selectedMusicList.clear();
    for (int i = 0; i < widget._selectedList.length; i++) {
      if (widget._selectedList[i] == true) {
        selectedMusicList.add(widget._musicList[i]);
      }
    }
  }

  playSelectMusic() {
    widget._playOrPauseMusicForSelectedListFunc();

    // playOrPauseMusicForSelectedList();
  }

  // void playOrPauseMusicForSelectedList() {
  //   PlayMusic.stopFunc().whenComplete(() {
  //     PlayMusic.makeNewPlayer();
  //     PlayMusic.playListFunc(selectedMusicList);
  //   });
  // }

  void deleteMyMusicList() {
    String mainCollection = FirebaseDBHelper.myMusicCollection;
    String mainDoc = Provider.of<UserProfileProvider>(context, listen: false)
        .userProfileData
        .id;
    String subCollection = FirebaseDBHelper.mySelectedMusicCollection;
    selectedMusicList.forEach((element) {
      String subDoc = element.id;
      FirebaseDBHelper.deleteSubDoc(
          mainCollection, mainDoc, subCollection, subDoc);
    });
  }
}
