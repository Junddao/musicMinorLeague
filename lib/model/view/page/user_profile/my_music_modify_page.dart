import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:music_minorleague/model/data/music_info_data.dart';
import 'package:music_minorleague/model/enum/lounge_bottom_widget_enum.dart';
import 'package:music_minorleague/model/provider/mini_widget_status_provider.dart';
import 'package:music_minorleague/model/provider/user_profile_provider.dart';
import 'package:music_minorleague/model/view/style/colors.dart';
import 'package:music_minorleague/model/view/style/textstyles.dart';
import 'package:music_minorleague/utils/firebase_db_helper.dart';
import 'package:music_minorleague/utils/play_func.dart';
import 'package:provider/provider.dart';

import 'component/small_player_widget.dart';

class MyMusicModifyPage extends StatefulWidget {
  @override
  _MyMusicModifyPageState createState() => _MyMusicModifyPageState();
}

class _MyMusicModifyPageState extends State<MyMusicModifyPage> {
  List<MusicInfoData> _myMusicList;

  @override
  void initState() {
    _myMusicList = new List<MusicInfoData>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: _body(),
    );
  }

  _appBar() {
    return AppBar(
      // automaticallyImplyLeading: false,
      title: Text(
        '내 노래 편집',
        style: MTextStyles.bold18Black,
      ),
      backgroundColor: Colors.transparent,
      elevation: 0.0,
    );
  }

  _body() {
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10, bottom: 30),
      child: Stack(
        fit: StackFit.expand,
        children: [
          StreamBuilder(
              stream: FirebaseDBHelper.getMyMusicDataStream(
                  FirebaseDBHelper.allMusicCollection,
                  Provider.of<UserProfileProvider>(context).userProfileData.id),
              builder: (context, snapshot) {
                _myMusicList = FirebaseDBHelper.getMusicDatabase(snapshot.data);

                return ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: _myMusicList.length,
                  itemBuilder: (context, index) {
                    return Column(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10.0),
                          child: Container(
                            height: 72,
                            child: StreamBuilder(
                                stream: PlayMusic.getCurrentStream(),
                                builder: (context, currentSnapshot) {
                                  final Playing playing = currentSnapshot.data;

                                  final String currentMusicId =
                                      playing?.audio?.audio?.metas?.id;
                                  return StreamBuilder(
                                      stream: PlayMusic.isPlayingFunc(),
                                      builder: (context, playingSnapshot) {
                                        final isPlaying = playingSnapshot.data;
                                        return ListTile(
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          leading: ClipOval(
                                            // borderRadius:
                                            //     BorderRadius.circular(4.0),
                                            child: ExtendedImage.network(
                                              _myMusicList[index]?.imagePath,
                                              cache: true,
                                              width: 50,
                                              height: 50,
                                              fit: BoxFit.cover,
                                              clearMemoryCacheWhenDispose: true,
                                            ),
                                          ),
                                          title: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                _myMusicList[index].title,
                                                style: MTextStyles.bold14Grey06,
                                              ),
                                              SizedBox(
                                                width: 6,
                                              ),
                                              Text(
                                                _myMusicList[index].artist,
                                                maxLines: 1,
                                                style: MTextStyles
                                                    .regular12WarmGrey_underline,
                                              ),
                                            ],
                                          ),
                                          trailing: Wrap(
                                            children: [
                                              IconButton(
                                                  iconSize: 14,
                                                  icon: Icon(
                                                    isPlaying == true &&
                                                            _myMusicList[index]
                                                                    .id ==
                                                                currentMusicId
                                                        ? FontAwesomeIcons.pause
                                                        : FontAwesomeIcons.play,
                                                  ),
                                                  color: isPlaying == true &&
                                                          _myMusicList[index]
                                                                  .id ==
                                                              currentMusicId
                                                      ? MColors.black
                                                      : MColors.warm_grey,
                                                  onPressed: () {
                                                    MusicInfoData
                                                        musicInfoData =
                                                        MusicInfoData.fromMap(
                                                            _myMusicList[index]
                                                                .toMap());

                                                    playOrpauseMusic(
                                                        musicInfoData,
                                                        currentMusicId);
                                                  }),
                                              IconButton(
                                                icon: Icon(Icons
                                                    .delete_forever_outlined),
                                                onPressed: () {
                                                  deleteMyMusic(index);
                                                },
                                              ),
                                            ],
                                          ),
                                        );
                                      });
                                }),
                          ),
                        ),
                        Divider(
                          height: 1,
                          indent: 10,
                          endIndent: 10,
                        ),
                      ],
                    );
                  },
                );
              }),
          Visibility(
            visible: Provider.of<MiniWidgetStatusProvider>(context)
                        .bottomPlayListWidget ==
                    BottomWidgets.miniPlayer
                ? true
                : false,
            child: SmallPlayerWidget(),
          ),
        ],
      ),
    );
  }

  void playOrpauseMusic(MusicInfoData musicInfoData, String currentPlayingId) {
    if (currentPlayingId == musicInfoData.id) {
      PlayMusic.playOrPauseFunc();
    } else {
      PlayMusic.stopFunc().whenComplete(() {
        PlayMusic.makeNewPlayer();
        PlayMusic.playUrlFunc(musicInfoData);
      });
    }
    Provider.of<MiniWidgetStatusProvider>(context, listen: false)
        .bottomPlayListWidget = BottomWidgets.miniPlayer;
  }

  void deleteMyMusic(int index) {
    String doc = _myMusicList[index].id;
    FirebaseDBHelper.deleteDoc(FirebaseDBHelper.allMusicCollection, doc);

    FirebaseDBHelper.deleteAllSubDoc(FirebaseDBHelper.myMusicCollection, doc);

    Provider.of<MiniWidgetStatusProvider>(context, listen: false)
        .bottomPlayListWidget = BottomWidgets.none;
  }
}
