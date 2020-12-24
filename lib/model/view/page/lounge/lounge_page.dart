import 'dart:async';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:music_minorleague/model/data/music_info_data.dart';
import 'package:music_minorleague/model/enum/lounge_bottom_widget_enum.dart';
import 'package:music_minorleague/model/enum/music_type_enum.dart';
import 'package:music_minorleague/model/provider/mini_widget_status_provider.dart';
import 'package:music_minorleague/model/provider/now_play_music_provider.dart';

import 'package:music_minorleague/model/view/page/lounge/component/select_buttons_widget.dart';
import 'package:music_minorleague/model/view/style/colors.dart';
import 'package:music_minorleague/model/view/style/size_config.dart';
import 'package:music_minorleague/model/view/style/textstyles.dart';

import 'package:music_minorleague/utils/firebase_db_helper.dart';
import 'package:music_minorleague/utils/play_func.dart';
import 'package:provider/provider.dart';
import 'package:music_minorleague/model/view/page/widget/small_play_list_widget.dart';
// import 'component/small_play_list_widget.dart';
import 'component/small_select_list_widget.dart';
import 'component/top_twenty_music_widget.dart';

class LoungePage extends StatefulWidget {
  @override
  _LoungePageState createState() => _LoungePageState();
}

class _LoungePageState extends State<LoungePage>
    with SingleTickerProviderStateMixin {
  final _scaffoldKey = new GlobalKey<ScaffoldState>();

  bool isTabThisWeekMusicListItem;

  List<MusicInfoData> musicList;
  List<MusicInfoData> topTwentyMusicList;
  List<MusicInfoData> selectedMusicList;

  List<bool> selectedList;

  // List<bool> isPlayList;

  int selectedThumbIndex = -1;

  final List<StreamSubscription> _subscriptions = [];
  AssetsAudioPlayer _assetsAudioPlayer;

  @override
  void initState() {
    super.initState();

    isTabThisWeekMusicListItem = false;
    musicList = new List<MusicInfoData>();
    topTwentyMusicList = new List<MusicInfoData>();
    selectedMusicList = new List<MusicInfoData>();

    _initSubscription();
  }

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
  void dispose() {
    super.dispose();

    PlayMusic.disposeAudioPlayer();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    musicList =
        Provider.of<NowPlayMusicProvider>(context, listen: false).musicList;
    if (selectedList?.length !=
        Provider.of<NowPlayMusicProvider>(context, listen: false)
            .musicList
            .length) {
      selectedList = null;
      selectedList = List.generate(
          Provider.of<NowPlayMusicProvider>(context, listen: false)
              .musicList
              .length,
          (index) => false);
    }
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          '라운지',
          style: MTextStyles.bold18Black,
        ),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),
      body: _body(),
    );
  }

  _body() {
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10),
      child: Stack(
        children: [
          SingleChildScrollView(
            physics: ScrollPhysics(),
            // child: ConstrainedBox(
            //   constraints: BoxConstraints(maxHeight: SizeConfig.screenHeight),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // musicList =
                //     FirebaseDBHelper.getMusicDatabase(snapshot.data);

                // List<MusicInfoData> _twentyList =
                //     new List<MusicInfoData>();
                // musicList.length > 20
                //     ? _twentyList = musicList.sublist(0, 20)
                //     : _twentyList = musicList;
                TopTwentyMusicWidget(playOrpauseMusic),

                Padding(
                  padding:
                      const EdgeInsets.only(left: 20.0, top: 40, bottom: 12.0),
                  child: Text(
                    'All Music',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: MColors.blackColor),
                  ),
                ),
                SelectButtonsWidget(selectAllMusicFunc: selectAllMusicFunc),
                playListOfThisWeek(),
              ],
            ),
            // ),
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
            visible: Provider.of<MiniWidgetStatusProvider>(context)
                        .bottomSeletListWidget ==
                    LoungeBottomWidgets.miniSelectList
                ? true
                : false,
            child: SmallSelectListWidget(
              musicList: musicList,
              selectedList: selectedList,
              snackBarFunc: showAndHideSnackBar,
              visibleMiniPlayerFunc: visibleMiniPlayer,
              playOrPauseMusicForSelectedListFunc:
                  playOrPauseMusicForSelectedList,
            ),
          ),
        ],
      ),
    );
  }

  Widget playListOfThisWeek() {
    return Stack(
      children: [
        StreamBuilder(
          stream: FirebaseDBHelper.getDataStream(
              FirebaseDBHelper.allMusicCollection),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return Center(
                child: Text('error'),
              );
            } else if (snapshot.hasData == false) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else {
              return ListView.builder(
                shrinkWrap: true,
                // physics: ClampingScrollPhysics(),
                physics: NeverScrollableScrollPhysics(),
                itemCount: snapshot.data.docs.length,
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10.0),
                        child: Container(
                          height: 72,
                          color: selectedList[index] == true
                              ? Colors.blueGrey[100]
                              : Colors.transparent,
                          child: StreamBuilder<Object>(
                              stream: PlayMusic.getCurrentStream(),
                              builder: (context, snapshotCurrent) {
                                final Playing playing = snapshotCurrent.data;

                                final String currentMusicId =
                                    playing?.audio?.audio?.metas?.id;

                                return StreamBuilder(
                                    stream: PlayMusic.isPlayingFunc(),
                                    initialData: false,
                                    builder: (context, snapshotPlaying) {
                                      final isPlaying = snapshotPlaying.data;
                                      return ListTile(
                                        onTap: () {
                                          selectedList[index] =
                                              !selectedList[index];
                                          getSelectedMusicList();
                                          selectedList.contains(true)
                                              ? Provider.of<MiniWidgetStatusProvider>(
                                                          context,
                                                          listen: false)
                                                      .bottomSeletListWidget =
                                                  LoungeBottomWidgets
                                                      .miniSelectList
                                              : Provider.of<MiniWidgetStatusProvider>(
                                                          context,
                                                          listen: false)
                                                      .bottomSeletListWidget =
                                                  LoungeBottomWidgets.none;
                                        },
                                        leading: ClipOval(
                                          // borderRadius:
                                          //     BorderRadius.circular(4.0),
                                          // child: ExtendedImage.network(
                                          child: ExtendedImage.network(
                                            snapshot.data.docs[index]
                                                ['imagePath'],
                                            cache: true,
                                            width: 50,
                                            height: 50,

                                            fit: BoxFit.cover,
                                            // clearMemoryCacheWhenDispose: false,
                                          ),
                                        ),
                                        title: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              snapshot.data.docs[index]
                                                  ['title'],
                                              style: MTextStyles.bold16Grey06,
                                            ),
                                            SizedBox(
                                              width: 6,
                                            ),
                                            Text(
                                              snapshot.data.docs[index]
                                                  ['artist'],
                                              maxLines: 1,
                                              style: MTextStyles
                                                  .regular12WarmGrey_underline,
                                            ),
                                          ],
                                        ),
                                        trailing: Wrap(
                                          crossAxisAlignment:
                                              WrapCrossAlignment.center,
                                          children: [
                                            IconButton(
                                                iconSize: 14,
                                                icon: Icon(
                                                  isPlaying == true &&
                                                          musicList[index].id ==
                                                              currentMusicId
                                                      ? FontAwesomeIcons.pause
                                                      : FontAwesomeIcons.play,
                                                ),
                                                color: isPlaying == true &&
                                                        musicList[index].id ==
                                                            currentMusicId
                                                    ? MColors.black
                                                    : MColors.warm_grey,
                                                onPressed: () {
                                                  MusicInfoData musicInfoData =
                                                      new MusicInfoData(
                                                    id: snapshot
                                                        .data.docs[index]['id'],
                                                    title: snapshot.data
                                                        .docs[index]['title'],
                                                    artist: snapshot.data
                                                        .docs[index]['artist'],
                                                    musicPath: snapshot
                                                            .data.docs[index]
                                                        ['musicPath'],
                                                    imagePath: snapshot
                                                            .data.docs[index]
                                                        ['imagePath'],
                                                    dateTime: snapshot
                                                            .data.docs[index]
                                                        ['dateTime'],
                                                    favorite: snapshot
                                                            .data.docs[index]
                                                        ['favorite'],
                                                    musicType:
                                                        EnumToString.fromString(
                                                            MusicTypeEnum
                                                                .values,
                                                            snapshot.data
                                                                    .docs[index]
                                                                ['musicType']),
                                                  );
                                                  setState(() {
                                                    playOrpauseMusic(
                                                        musicInfoData,
                                                        currentMusicId);
                                                  });
                                                }),
                                            GestureDetector(
                                              onTap: () {
                                                _handleOnPressThumb(index);
                                              },
                                              child: Container(
                                                height: 28,
                                                width: 28,
                                                child: FlareActor(
                                                  'assets/icons/thumb.flr',
                                                  alignment: Alignment.center,
                                                  fit: BoxFit.cover,
                                                  animation:
                                                      selectedThumbIndex ==
                                                              index
                                                          ? "click"
                                                          : "idle",
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              width: 20,
                                              child: Text(
                                                musicList[index].favorite >
                                                        10000
                                                    ? '10000++'
                                                    : musicList[index]
                                                        .favorite
                                                        .toString(),
                                                style:
                                                    MTextStyles.regular8Grey06,
                                              ),
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
            }
          },
        ),
      ],
    );
  }

  void selectAllMusicFunc() {
    setState(() {
      if (selectedList.every((element) {
        return element;
      })) {
        for (int i = 0; i < selectedList.length; i++) {
          selectedList[i] = false;
        }
      } else {
        for (int i = 0; i < selectedList.length; i++) {
          selectedList[i] = true;
        }
      }
      for (int i = 0; i < selectedList.length; i++) {
        if (selectedList[i] == true) {
          selectedMusicList.add(musicList[i]);
        }
      }
      selectedList.contains(true)
          ? Provider.of<MiniWidgetStatusProvider>(context, listen: false)
              .bottomSeletListWidget = LoungeBottomWidgets.miniSelectList
          : Provider.of<MiniWidgetStatusProvider>(context, listen: false)
              .bottomSeletListWidget = LoungeBottomWidgets.none;
    });
  }

  void visibleMiniPlayer() {
    // setState(() {
    Provider.of<MiniWidgetStatusProvider>(context, listen: false)
        .bottomPlayListWidget = LoungeBottomWidgets.miniPlayer;
    Provider.of<MiniWidgetStatusProvider>(context, listen: false)
        .bottomSeletListWidget = LoungeBottomWidgets.none;
    // });
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

  void playOrPauseMusicForSelectedList() {
    PlayMusic.stopFunc().whenComplete(() {
      PlayMusic.makeNewPlayer();
      PlayMusic.playListFunc(selectedMusicList);
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

  void getSelectedMusicList() {
    selectedMusicList.clear();
    for (int i = 0; i < selectedList.length; i++) {
      if (selectedList[i] == true) {
        selectedMusicList.add(musicList[i]);
      }
    }
  }

  void _handleOnPressThumb(int index) {
    String collection = FirebaseDBHelper.allMusicCollection;
    String doc = musicList[index].id;
    int data = musicList[index].favorite;

    FirebaseDBHelper.updateFavoriteData(collection, doc, data + 1);
    setState(() {
      selectedThumbIndex = index;
    });
  }
}
