import 'dart:async';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:extended_image/extended_image.dart';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:music_minorleague/model/data/music_info_data.dart';
import 'package:music_minorleague/model/enum/lounge_bottom_widget_enum.dart';
import 'package:music_minorleague/model/enum/myplaylist_widget_enum.dart';
import 'package:music_minorleague/model/provider/mini_widget_status_provider.dart';

import 'package:music_minorleague/model/provider/user_profile_provider.dart';

import 'package:music_minorleague/model/view/page/playlist/component/my_playlist_small_select_list_widget.dart';
import 'package:music_minorleague/model/view/page/playlist/component/my_select_buttons_widget.dart';
// import 'package:music_minorleague/model/view/page/playlist/component/my_small_play_list_widget.dart';
import 'package:music_minorleague/model/view/page/widget/small_play_list_widget.dart';
import 'package:music_minorleague/model/view/style/colors.dart';
import 'package:music_minorleague/model/view/style/size_config.dart';
import 'package:music_minorleague/model/view/style/textstyles.dart';
import 'package:music_minorleague/utils/db_helper.dart';
import 'package:music_minorleague/utils/firebase_db_helper.dart';
import 'package:music_minorleague/utils/play_func.dart';
import 'package:provider/provider.dart';

class MyPlayListPage extends StatefulWidget {
  @override
  _MyPlayListPageState createState() => _MyPlayListPageState();
}

class _MyPlayListPageState extends State<MyPlayListPage> {
  final _scaffoldKey = new GlobalKey<ScaffoldState>();
  DBHelper dbHelper = DBHelper();

  AssetsAudioPlayer _assetsAudioPlayer;
  final List<StreamSubscription> _subscriptions = [];
  List<MusicInfoData> _myMusicList = new List<MusicInfoData>();
  List<MusicInfoData> _selectedMusicList = new List<MusicInfoData>();

  List<bool> _selectedList;

  MyPlaylistWidgetEnum myPlayListWidgetEnum;
  MyPlaylistWidgetEnum myMiniPlayer;

  _initSubscription() {
    _clearSubscriptions();
    _assetsAudioPlayer = PlayMusic.assetsAudioPlayer();
    // _assetsAudioPlaye

    _subscriptions.add(_assetsAudioPlayer.playlistFinished.listen((data) {
      print("finished : $data");
    }));
    _subscriptions.add(_assetsAudioPlayer.playlistAudioFinished.listen((data) {
      print("playlistAudioFinished : $data");
    }));
    _subscriptions.add(_assetsAudioPlayer.audioSessionId.listen((sessionId) {
      print("audioSessionId : $sessionId");
    }));
    _subscriptions.add(_assetsAudioPlayer.current.listen((data) {
      print("current : $data");
    }));
    _subscriptions.add(_assetsAudioPlayer.onReadyToPlay.listen((audio) {
      print("onReadyToPlay : $audio");
    }));
    _subscriptions.add(_assetsAudioPlayer.isBuffering.listen((isBuffering) {
      print("isBuffering : $isBuffering");
    }));
    _subscriptions.add(_assetsAudioPlayer.playerState.listen((playerState) {
      print("playerState : $playerState");
    }));
    _subscriptions.add(_assetsAudioPlayer.isPlaying.listen((isplaying) {
      print("isplaying : $isplaying");
    }));
    _subscriptions
        .add(AssetsAudioPlayer.addNotificationOpenAction((notification) {
      return false;
    }));
  }

  void _clearSubscriptions() {
    for (var s in _subscriptions) {
      s?.cancel();
      s = null;
    }
    _subscriptions.clear();
  }

  @override
  void initState() {
    super.initState();
    _initSubscription();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: _appBar(),
      body: _body(),
    );
  }

  _appBar() {
    return AppBar(
      automaticallyImplyLeading: false,
      title: Text(
        '내 재생목록',
        style: MTextStyles.bold18Black,
      ),
      backgroundColor: Colors.transparent,
      elevation: 0.0,
    );
  }

  _body() {
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10),
      child: Stack(
        children: [
          SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxHeight: SizeConfig.screenHeight),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  MySelectButtonsWidget(selectAllMusicFunc: selectAllMusicFunc),
                  Expanded(
                    child: Stack(
                      children: [
                        mySelectedMusicListWidget(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Visibility(
          //   visible: Provider.of<MiniWidgetStatusProvider>(context)
          //               .bottomPlayListWidget ==
          //           LoungeBottomWidgets.miniPlayer
          //       ? true
          //       : false,
          //   child: SmallPlayListWidget(),
          // ),
          Visibility(
            visible:
                myPlayListWidgetEnum == MyPlaylistWidgetEnum.miniSelectWidget
                    ? true
                    : false,
            child: MyPlaylistSmallSelectListWidget(
              musicList: _myMusicList,
              selectedList: _selectedList,
              snackBarFunc: showAndHideSnackBar,
              refreshSelectedListAndWidgetFunc:
                  refreshSelectedListAndWidgetFunc,
            ),
          ),
        ],
      ),
    );
  }

  Widget mySelectedMusicListWidget() {
    String mainCollection = FirebaseDBHelper.myMusicCollection;
    String mainDoc = Provider.of<UserProfileProvider>(context, listen: false)
        .userProfileData
        .id;
    String subCollection = FirebaseDBHelper.mySelectedMusicCollection;
    List<String> dataList = new List<String>();
    return Flex(
      direction: Axis.vertical,
      children: [
        Expanded(
          child: StreamBuilder<Object>(
              stream: FirebaseDBHelper.getSubDataStream(
                  mainCollection, mainDoc, subCollection),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(
                    child: Text('error'),
                  );
                } else if (snapshot.hasData == false) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  _myMusicList =
                      FirebaseDBHelper.getMusicDatabase(snapshot.data);

                  if (_selectedList?.length != _myMusicList.length) {
                    _selectedList =
                        List.generate(_myMusicList.length, (index) => false);
                  }
                  return Stack(
                    children: [
                      ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: _myMusicList.length,
                        itemBuilder: (context, index) {
                          return Column(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(10.0),
                                child: Container(
                                  height: 72,
                                  color: _selectedList[index] == true
                                      ? Colors.blueGrey[100]
                                      : Colors.transparent,
                                  child: StreamBuilder(
                                      stream: PlayMusic.getCurrentStream(),
                                      builder: (context, currentSnapshot) {
                                        final Playing playing =
                                            currentSnapshot.data;
                                        final String currentMusicId =
                                            playing?.audio?.audio?.metas?.id;
                                        return StreamBuilder(
                                            stream: PlayMusic.isPlayingFunc(),
                                            initialData: false,
                                            builder:
                                                (context, snapshotPlaying) {
                                              final isPlaying =
                                                  snapshotPlaying.data;
                                              return ListTile(
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                                onTap: () {
                                                  setState(() {
                                                    _selectedList[index] =
                                                        !_selectedList[index];

                                                    _selectedList.contains(true)
                                                        ? myPlayListWidgetEnum =
                                                            MyPlaylistWidgetEnum
                                                                .miniSelectWidget
                                                        : myPlayListWidgetEnum =
                                                            MyPlaylistWidgetEnum
                                                                .none;
                                                  });
                                                },
                                                leading: ClipOval(
                                                  // borderRadius:
                                                  //     BorderRadius.circular(4.0),
                                                  child: ExtendedImage.network(
                                                    _myMusicList[index]
                                                        ?.imagePath,
                                                    cache: true,
                                                    width: 50,
                                                    height: 50,
                                                    fit: BoxFit.cover,
                                                    clearMemoryCacheWhenDispose:
                                                        true,
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
                                                      style: MTextStyles
                                                          .bold14Grey06,
                                                    ),
                                                    SizedBox(
                                                      width: 6,
                                                    ),
                                                    Text(
                                                      _myMusicList[index]
                                                          .artist,
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
                                                                  _myMusicList[
                                                                              index]
                                                                          .id ==
                                                                      currentMusicId
                                                              ? FontAwesomeIcons
                                                                  .pause
                                                              : FontAwesomeIcons
                                                                  .play,
                                                        ),
                                                        color: isPlaying ==
                                                                    true &&
                                                                _myMusicList[
                                                                            index]
                                                                        .id ==
                                                                    currentMusicId
                                                            ? MColors.black
                                                            : MColors.warm_grey,
                                                        onPressed: () {
                                                          MusicInfoData musicInfoData = new MusicInfoData(
                                                              id: _myMusicList[index]
                                                                  .id,
                                                              title: _myMusicList[
                                                                      index]
                                                                  .title,
                                                              artist:
                                                                  _myMusicList[index]
                                                                      .artist,
                                                              musicPath:
                                                                  _myMusicList[index]
                                                                      .musicPath,
                                                              imagePath:
                                                                  _myMusicList[
                                                                          index]
                                                                      .imagePath,
                                                              dateTime:
                                                                  _myMusicList[
                                                                          index]
                                                                      .dateTime,
                                                              favorite:
                                                                  _myMusicList[
                                                                          index]
                                                                      .favorite,
                                                              musicType:
                                                                  _myMusicList[
                                                                          index]
                                                                      .musicType);

                                                          setState(() {
                                                            playOrpauseMusic(
                                                                musicInfoData,
                                                                currentMusicId);
                                                          });
                                                        }),
                                                    IconButton(
                                                        icon: Icon(
                                                          Icons
                                                              .favorite_border_outlined,
                                                          size: 16,
                                                        ),
                                                        onPressed: null),
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
                      ),
                    ],
                  );
                }
              }),
        ),
      ],
    );
  }

  refreshSelectedListAndWidgetFunc() {
    setState(() {
      myPlayListWidgetEnum = MyPlaylistWidgetEnum.none;
      _selectedList.forEach((element) {
        element = false;
      });
    });
  }

  void showAndHideSnackBar(String content) {
    _scaffoldKey.currentState.showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Text(content),
          ],
        ),
      ),
    );
    Future.delayed(Duration(seconds: 2), () {
      _scaffoldKey.currentState.hideCurrentSnackBar();
    });
  }

  void selectAllMusicFunc() {
    setState(() {
      if (_selectedList.every((element) {
        return element;
      })) {
        for (int i = 0; i < _selectedList.length; i++) {
          _selectedList[i] = false;
        }
      } else {
        for (int i = 0; i < _selectedList.length; i++) {
          _selectedList[i] = true;
        }
      }
      _selectedList.contains(true)
          ? myPlayListWidgetEnum = MyPlaylistWidgetEnum.miniSelectWidget
          : myPlayListWidgetEnum = MyPlaylistWidgetEnum.none;
    });
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
        .bottomPlayListWidget = LoungeBottomWidgets.miniPlayer;
  }
}
