import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:music_minorleague/model/data/music_info_data.dart';
import 'package:music_minorleague/model/provider/user_profile_provider.dart';
import 'package:music_minorleague/model/view/page/upload/component/upload_result_Dialog.dart';
import 'package:music_minorleague/model/view/style/colors.dart';
import 'package:music_minorleague/model/view/style/size_config.dart';
import 'package:music_minorleague/model/view/style/textstyles.dart';
import 'package:music_minorleague/utils/db_helper.dart';
import 'package:music_minorleague/utils/firebase_db_helper.dart';
import 'package:provider/provider.dart';

class SmallSelectListWidget extends StatefulWidget {
  const SmallSelectListWidget({
    Key key,
    List<MusicInfoData> musicList,
    Function snackBarFunc,
    List<bool> selectedList,
    Function visibleMiniPlayerFunc,
    Function playOrPauseMusicForSelectedListFunc,
  })  : _musicList = musicList,
        _selectedList = selectedList,
        _snackBarFunc = snackBarFunc,
        _visibleMiniPlayerFunc = visibleMiniPlayerFunc,
        _playOrPauseMusicForSelectedListFunc =
            playOrPauseMusicForSelectedListFunc,
        super(key: key);

  final List<MusicInfoData> _musicList;
  final List<bool> _selectedList;
  final Function _snackBarFunc;
  final Function _visibleMiniPlayerFunc;
  final Function _playOrPauseMusicForSelectedListFunc;

  @override
  _SmallSelectListWidgetState createState() => _SmallSelectListWidgetState();
}

class _SmallSelectListWidgetState extends State<SmallSelectListWidget> {
  List<MusicInfoData> selectedMusicList = new List<MusicInfoData>();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 10,
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Container(
              height: 100,
              width: SizeConfig.screenWidth - 20,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(
                  Radius.circular(16),
                ),
                border: Border.all(color: MColors.black, width: 0.2),
                color: MColors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey,
                    offset: Offset(0.0, 1.0),
                    blurRadius: 3.0,
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                          iconSize: 16,
                          icon: Icon(FontAwesomeIcons.plus),
                          onPressed: () {
                            // TODO: 업데이트 하도록 구현해야함
                            // updateMyMusicList();
                            getSelectedMusicList();
                            updateMyMusicListInFirebase()
                                .whenComplete(
                                  () => widget._snackBarFunc('내 재생목록에 등록 완료'),
                                )
                                .catchError(
                                  () => widget._snackBarFunc('등록 실패'),
                                );
                          }),
                      Text(
                        '찜 목록에 추가',
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
                          iconSize: 14,
                          icon: Icon(FontAwesomeIcons.play),
                          onPressed: () {
                            playSelectMusic();
                          }),
                      Text(
                        '선택 항목 재생',
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
            child: selectedMusicList == null
                ? SizedBox.shrink()
                : CircleAvatar(
                    radius: 15,
                    backgroundColor: MColors.tomato,
                    child: Text(
                      widget._selectedList
                          .where((element) => element == true)
                          .length
                          .toString(),
                      style: MTextStyles.bold14White,
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
    widget._visibleMiniPlayerFunc();
    widget._playOrPauseMusicForSelectedListFunc();
  }

  Future<void> updateMyMusicListInFirebase() async {
    String mainCollection = FirebaseDBHelper.myMusicCollection;

    String mainDoc = Provider.of<UserProfileProvider>(context, listen: false)
        .userProfileData
        .id;
    String subCollection = FirebaseDBHelper.mySelectedMusicCollection;
    try {
      if (selectedMusicList != null) {
        if (selectedMusicList.length > 0) {
          selectedMusicList.forEach(
            (element) {
              String subDoc = element.id;
              var data = {
                "id": element.id,
                "title": element.title,
                "artist": element.artist,
                "musicType": EnumToString.convertToString(element.musicType),
                "musicPath": element.musicPath,
                "imagePath": element.imagePath,
                "dateTime": element.dateTime,
                "favorite": element.favorite,
              };
              FirebaseDBHelper.setSubCollection(
                  mainCollection, mainDoc, subCollection, subDoc, data);
              // FirebaseDBHelper.setData(collection, doc, data);
              // DBHelper.database();
            },
          );
        }
      }
    } catch (ex) {
      print(ex.toString());
    }
  }

  Future<void> updateMyMusicList() async {
    DBHelper dbHelper = DBHelper();
    Future<List<MusicInfoData>> listItems;
    // 우선 저장된 데이터를 가져오고

    try {
      if (selectedMusicList != null) {
        if (selectedMusicList.length > 0) {
          selectedMusicList.forEach(
            (element) {
              MusicInfoData data = MusicInfoData(
                id: element.id,
                title: element.title,
                artist: element.artist,
                musicType: element.musicType,
                musicPath: element.musicPath,
                imagePath: element.imagePath,
                dateTime: DateTime.now().toIso8601String(),
                favorite: element.favorite,
              );

              dbHelper.save(data);
              // DBHelper.database();
            },
          );
        }
      }
      listItems = dbHelper.getListItem();
      listItems.whenComplete(
        () => widget._snackBarFunc('내 재생목록에 등록 완료'),
      );
    } catch (ex) {
      print(ex.toString());
    }
  }
}
