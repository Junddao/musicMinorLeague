import 'dart:async';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:music_minorleague/model/data/music_info_data.dart';
import 'package:music_minorleague/model/enum/lounge_bottom_widget_enum.dart';
import 'package:music_minorleague/model/enum/music_type_enum.dart';
import 'package:music_minorleague/model/provider/now_play_music_provider.dart';
import 'package:music_minorleague/model/provider/user_profile_provider.dart';
import 'package:music_minorleague/model/view/page/lounge/component/select_buttons_widget.dart';
import 'package:music_minorleague/model/view/style/colors.dart';
import 'package:music_minorleague/model/view/style/size_config.dart';
import 'package:music_minorleague/model/view/style/textstyles.dart';
import 'package:music_minorleague/utils/firebase_db_helper.dart';
import 'package:music_minorleague/utils/play_func.dart';
import 'package:provider/provider.dart';

import 'component/small_play_list_widget.dart';
import 'component/small_select_list_widget.dart';
import 'component/top_twenty_music_widget.dart';

class LoungePage extends StatefulWidget {
  @override
  _LoungePageState createState() => _LoungePageState();
}

class _LoungePageState extends State<LoungePage>
    with SingleTickerProviderStateMixin {
  final _scaffoldKey = new GlobalKey<ScaffoldState>();
  TabController tabController;

  LoungeBottomWidgets bottomSeletListWidget = LoungeBottomWidgets.none;
  LoungeBottomWidgets bottomPlayListWidget = LoungeBottomWidgets.none;
  bool isTabThisWeekMusicListItem;

  List<MusicInfoData> musicList;
  List<MusicInfoData> topTwentyMusicList;
  List<MusicInfoData> selectedMusicList;

  List<bool> selectedList;
  AnimationController _animationController;
  // List<bool> isPlayList;

  int selectedThumbIndex = 0;

  final List<StreamSubscription> _subscriptions = [];
  AssetsAudioPlayer _assetsAudioPlayer;

  @override
  void initState() {
    super.initState();
    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 300));
    // tabController = TabController(vsync: this, length: 2);

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
      if (playerState == PlayerState.pause) {
        Provider.of<NowPlayMusicProvider>(context, listen: false).isPlay =
            false;
      } else if (playerState == PlayerState.play) {
        Provider.of<NowPlayMusicProvider>(context, listen: false).isPlay = true;
      }

      setState(() {});
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
    tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
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
      body: _buildThisWeekNewPage(),
    );
  }

  _buildThisWeekNewPage() {
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
                  StreamBuilder(
                    stream: FirebaseDBHelper.getDataStream(
                        FirebaseDBHelper.allMusicCollection),
                    builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      } else {
                        musicList =
                            FirebaseDBHelper.getMusicDatabase(snapshot.data);
                        List<MusicInfoData> _twentyList =
                            new List<MusicInfoData>();
                        musicList.length > 20
                            ? _twentyList = musicList.sublist(0, 20)
                            : _twentyList = musicList;
                        return TopTwentyMusicWidget(
                            _twentyList, playOrpauseMusic, visibleMiniPlayer);
                      }
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 20.0, top: 40, bottom: 12.0),
                    child: Text(
                      'All Music',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: MColors.blackColor),
                    ),
                  ),
                  SelectButtonsWidget(selectAllMusicFunc: selectAllMusicFunc),
                  Expanded(
                    child: Stack(
                      children: [
                        playListOfThisWeek(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Visibility(
            visible: bottomPlayListWidget == LoungeBottomWidgets.miniPlayer
                ? true
                : false,
            child: SmallPlayListWidget(
              musicList: musicList,
              playNext: playNext,
              playPrevious: playPrevious,
            ),
          ),
          Visibility(
            visible: bottomSeletListWidget == LoungeBottomWidgets.miniSelectList
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
    return Flex(
      direction: Axis.vertical,
      children: [
        Expanded(
          child: Stack(
            children: [
              StreamBuilder(
                stream: FirebaseDBHelper.getDataStream(
                    FirebaseDBHelper.allMusicCollection),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else {
                    if (selectedList?.length != snapshot.data.docs.length) {
                      selectedList = null;
                      selectedList = List.generate(
                          snapshot.data.docs.length, (index) => false);
                    }

                    // if (isPlayList?.length != snapshot.data.docs.length) {
                    //   isPlayList = null;
                    //   isPlayList = List.generate(
                    //       snapshot.data.docs.length, (index) => false);
                    // }

                    return StreamBuilder<Object>(
                        stream: _assetsAudioPlayer.current,
                        builder: (context, snapshotCurrent) {
                          return ListView.builder(
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: snapshot.data.docs.length,
                            itemBuilder: (context, index) {
                              return Container(
                                height: 72,
                                color: selectedList[index] == true
                                    ? Colors.grey[300]
                                    : Colors.transparent,
                                child: ListTile(
                                  onTap: () {
                                    setState(() {
                                      selectedList[index] =
                                          !selectedList[index];
                                      getSelectedMusicList();
                                      selectedList.contains(true)
                                          ? bottomSeletListWidget =
                                              LoungeBottomWidgets.miniSelectList
                                          : bottomSeletListWidget =
                                              LoungeBottomWidgets.none;
                                    });
                                  },
                                  leading: CircleAvatar(
                                    backgroundImage: NetworkImage(
                                        snapshot.data.docs[index]['imagePath']),
                                  ),
                                  title: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        snapshot.data.docs[index]['title'],
                                        style: MTextStyles.bold14Grey06,
                                      ),
                                      SizedBox(
                                        width: 6,
                                      ),
                                      Text(
                                        snapshot.data.docs[index]['artist'],
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
                                            Provider.of<NowPlayMusicProvider>(
                                                                context,
                                                                listen: false)
                                                            .isPlay ==
                                                        true &&
                                                    musicList[index].id ==
                                                        Provider.of<NowPlayMusicProvider>(
                                                                context,
                                                                listen: false)
                                                            .nowMusicId
                                                ? FontAwesomeIcons.pause
                                                : FontAwesomeIcons.play,
                                          ),
                                          color: Provider.of<NowPlayMusicProvider>(
                                                              context,
                                                              listen: false)
                                                          .isPlay ==
                                                      true &&
                                                  musicList[index].id ==
                                                      Provider.of<NowPlayMusicProvider>(
                                                              context,
                                                              listen: false)
                                                          .nowMusicId
                                              ? MColors.black
                                              : MColors.warm_grey,
                                          onPressed: () {
                                            MusicInfoData musicInfoData =
                                                new MusicInfoData(
                                              id: snapshot.data.docs[index]
                                                  ['id'],
                                              title: snapshot.data.docs[index]
                                                  ['title'],
                                              artist: snapshot.data.docs[index]
                                                  ['artist'],
                                              musicPath: snapshot.data
                                                  .docs[index]['musicPath'],
                                              imagePath: snapshot.data
                                                  .docs[index]['imagePath'],
                                              dateTime: snapshot
                                                  .data.docs[index]['dateTime'],
                                              favorite: snapshot
                                                  .data.docs[index]['favorite'],
                                              musicType:
                                                  EnumToString.fromString(
                                                      MusicTypeEnum.values,
                                                      snapshot.data.docs[index]
                                                          ['musicType']),
                                            );
                                            playOrpauseMusic(musicInfoData);
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
                                                selectedThumbIndex == index
                                                    ? "click"
                                                    : "idle",
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 20,
                                        child: Text(
                                          musicList[index].favorite > 10000
                                              ? '10000++'
                                              : musicList[index]
                                                  .favorite
                                                  .toString(),
                                          style: MTextStyles.regular8Grey06,
                                        ),
                                      ),

                                      // IconButton(
                                      //     icon: Icon(
                                      //       Icons.thumb_up_alt_outlined,
                                      //       size: 14,
                                      //     ),
                                      //     onPressed: () {
                                      //       _handleOnPressThumb(index);
                                      //     }),
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        });
                  }
                },
              ),
            ],
          ),
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
      selectedList.contains(true)
          ? bottomSeletListWidget = LoungeBottomWidgets.miniSelectList
          : bottomSeletListWidget = LoungeBottomWidgets.none;
    });
  }

  void visibleMiniPlayer() {
    setState(() {
      bottomPlayListWidget = LoungeBottomWidgets.miniPlayer;
      bottomSeletListWidget = LoungeBottomWidgets.none;
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

  void playOrPauseMusicForSelectedList(int index) {
    MusicInfoData musicInfoData = new MusicInfoData(
      id: selectedMusicList[index].id,
      title: selectedMusicList[index].title,
      artist: selectedMusicList[index].artist,
      musicPath: selectedMusicList[index].musicPath,
      imagePath: selectedMusicList[index].imagePath,
      dateTime: selectedMusicList[index].dateTime,
      favorite: selectedMusicList[index].favorite,
      musicType: selectedMusicList[index].musicType,
    );
    setNowPlayMusicInfo(musicInfoData);

    PlayMusic.makeNewPlayer();
    _initSubscription();
    int length = selectedList.where((element) => element == true).length;
    List<Audio> audios = List.generate(length,
        (index) => new Audio.network(selectedMusicList[index].musicPath));
    PlayMusic.playListFunc(audios);
  }

  void setNowPlayMusicInfo(MusicInfoData musicInfoData) {
    setState(() {
      Provider.of<NowPlayMusicProvider>(context, listen: false).musicInfoData =
          musicInfoData;
      Provider.of<NowPlayMusicProvider>(context, listen: false).isPlay = true;
      Provider.of<NowPlayMusicProvider>(context, listen: false).nowMusicId =
          musicInfoData.id;
    });
  }

  void playOrpauseMusic(MusicInfoData musicInfoData) {
    Provider.of<NowPlayMusicProvider>(context, listen: false).musicInfoData =
        musicInfoData;

    String nowId =
        Provider.of<NowPlayMusicProvider>(context, listen: false).nowMusicId;

    int selectedValue; // 0 : first Selected , 1: same song selected, 2: different song selected

    // first selected
    if (nowId == null) {
      nowId = musicInfoData.id;
      selectedValue = 0;
    }
    // same song selected
    else if (nowId == musicInfoData.id) {
      Provider.of<NowPlayMusicProvider>(context, listen: false).isPlay = false;

      selectedValue = 1;
    }

    // different song selected
    else if (nowId != null && nowId != musicInfoData.id) {
      nowId = musicInfoData.id;
      selectedValue = 2;
    }
    Provider.of<NowPlayMusicProvider>(context, listen: false).nowMusicId =
        nowId;

    setState(() {
      if (selectedValue == 0) {
        PlayMusic.playUrlFunc(
            Provider.of<NowPlayMusicProvider>(context, listen: false)
                .musicInfoData
                .musicPath);
      } else if (selectedValue == 2) {
        PlayMusic.stopFunc();

        // _clearSubscriptions();
        PlayMusic.makeNewPlayer();

        _initSubscription();

        PlayMusic.playUrlFunc(
            Provider.of<NowPlayMusicProvider>(context, listen: false)
                .musicInfoData
                .musicPath);
      } else if (selectedValue == 1) {
        PlayMusic.playOrPauseFunc();
      }
      bottomPlayListWidget = LoungeBottomWidgets.miniPlayer;
    });
  }

  void getSelectedMusicList() {
    selectedMusicList.clear();
    for (int i = 0; i < selectedList.length; i++) {
      if (selectedList[i] == true) {
        selectedMusicList.add(musicList[i]);
      }
    }
    Provider.of<NowPlayMusicProvider>(context, listen: false)
        .selectedMusicList = selectedMusicList;
  }

  void playPrevious() {
    int index = PlayMusic.assetsAudioPlayer().current.value.index;
    if (index > 0) index = index - 1;
    MusicInfoData musicInfoData = new MusicInfoData(
      id: selectedMusicList[index].id,
      title: selectedMusicList[index].title,
      artist: selectedMusicList[index].artist,
      musicPath: selectedMusicList[index].musicPath,
      imagePath: selectedMusicList[index].imagePath,
      dateTime: selectedMusicList[index].dateTime,
      favorite: selectedMusicList[index].favorite,
      musicType: selectedMusicList[index].musicType,
    );
    setNowPlayMusicInfo(musicInfoData);
    setState(() {
      PlayMusic.previous();
    });
  }

  void playNext() {
    int index = PlayMusic.assetsAudioPlayer().current.value.index;
    if (index < selectedMusicList.length) index = index + 1;
    MusicInfoData musicInfoData = new MusicInfoData(
      id: selectedMusicList[index].id,
      title: selectedMusicList[index].title,
      artist: selectedMusicList[index].artist,
      musicPath: selectedMusicList[index].musicPath,
      imagePath: selectedMusicList[index].imagePath,
      dateTime: selectedMusicList[index].dateTime,
      favorite: selectedMusicList[index].favorite,
      musicType: selectedMusicList[index].musicType,
    );
    setNowPlayMusicInfo(musicInfoData);
    setState(() {
      PlayMusic.next();
    });
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
