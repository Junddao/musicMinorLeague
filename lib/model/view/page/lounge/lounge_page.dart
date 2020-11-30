import 'dart:async';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:music_minorleague/model/data/music_info_data.dart';
import 'package:music_minorleague/model/enum/music_type_enum.dart';
import 'package:music_minorleague/model/provider/now_play_music_provider.dart';
import 'package:music_minorleague/model/provider/user_profile_provider.dart';
import 'package:music_minorleague/model/view/page/lounge/component/select_buttons_widget.dart';
import 'package:music_minorleague/model/view/style/colors.dart';
import 'package:music_minorleague/model/view/style/size_config.dart';
import 'package:music_minorleague/model/view/style/textstyles.dart';
import 'package:music_minorleague/utils/play_func.dart';
import 'package:provider/provider.dart';

import 'component/small_play_list_widget.dart';
import 'component/small_select_list_widget.dart';
import 'component/top_twenty_music_widget.dart';

enum BottomWidgets {
  miniSelectList,
  miniPlayer,
  none,
}

class LoungePage extends StatefulWidget {
  @override
  _LoungePageState createState() => _LoungePageState();
}

class _LoungePageState extends State<LoungePage>
    with SingleTickerProviderStateMixin {
  final _scaffoldKey = new GlobalKey<ScaffoldState>();
  TabController tabController;

  BottomWidgets bottomSeletListWidget = BottomWidgets.none;
  BottomWidgets bottomPlayListWidget = BottomWidgets.none;
  bool isTabThisWeekMusicListItem;

  List<MusicInfoData> musicList;
  List<MusicInfoData> topTwentyMusicList;
  List<bool> selectedList;
  // List<bool> isPlayList;

  final List<StreamSubscription> _subscriptions = [];
  AssetsAudioPlayer _assetsAudioPlayer;

  @override
  void initState() {
    super.initState();
    // tabController = TabController(vsync: this, length: 2);

    isTabThisWeekMusicListItem = false;
    musicList = new List<MusicInfoData>();
    topTwentyMusicList = new List<MusicInfoData>();

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

  List<MusicInfoData> _getMusicDatabase(QuerySnapshot qs) {
    List<MusicInfoData> musicList = new List<MusicInfoData>();
    for (int idx = 0; idx < qs.docs.length; idx++) {
      MusicInfoData musicInfoData = new MusicInfoData();

      musicInfoData.artist = qs.docs[idx].data()['artist'];
      musicInfoData.dateTime = qs.docs[idx].data()['dateTime'];
      musicInfoData.favorite = qs.docs[idx].data()['favorite'];
      musicInfoData.imagePath = qs.docs[idx].data()['imagePath'];
      musicInfoData.musicPath = qs.docs[idx].data()['musicPath'];

      musicInfoData.musicType = EnumToString.fromString(
          MusicTypeEnum.values, qs.docs[idx].data()['musicType']);
      musicInfoData.title = qs.docs[idx].data()['title'];
      musicList.add(musicInfoData);

      int favoriteNum = qs.docs[idx].data()['favorite'];

      print(favoriteNum);
    }

    return musicList;
  }

  @override
  void dispose() {
    super.dispose();
    tabController.dispose();
  }

  Stream<QuerySnapshot> getData() {
    return FirebaseFirestore.instance.collection('allMusic').snapshots();
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
      child: Column(
        children: [
          StreamBuilder(
            stream: getData(),
            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                musicList = _getMusicDatabase(snapshot.data);
                List<MusicInfoData> _twentyList = new List<MusicInfoData>();
                musicList.length > 20
                    ? _twentyList = musicList.sublist(0, 20)
                    : _twentyList = musicList;
                return TopTwentyMusicWidget(_twentyList);
              }
            },
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
                stream: getData(),
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
                                      selectedList.contains(true)
                                          ? bottomSeletListWidget =
                                              BottomWidgets.miniSelectList
                                          : bottomSeletListWidget =
                                              BottomWidgets.none;
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
                                    children: [
                                      IconButton(
                                          iconSize: 14,
                                          icon: Icon(
                                            Provider.of<NowPlayMusicProvider>(
                                                                context,
                                                                listen: false)
                                                            .isPlay ==
                                                        true &&
                                                    index ==
                                                        Provider.of<NowPlayMusicProvider>(
                                                                context,
                                                                listen: false)
                                                            .nowMusicIndex
                                                ? FontAwesomeIcons.pause
                                                : FontAwesomeIcons.play,
                                          ),
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
                                            Provider.of<NowPlayMusicProvider>(
                                                    context,
                                                    listen: false)
                                                .musicInfoData = musicInfoData;

                                            int nowIndex = Provider.of<
                                                        NowPlayMusicProvider>(
                                                    context,
                                                    listen: false)
                                                .nowMusicIndex;

                                            int selectedValue; // 0 : first Selected , 1: same song selected, 2: different song selected

                                            // first selected
                                            if (nowIndex < 0) {
                                              nowIndex = index;
                                              selectedValue = 0;
                                            }
                                            // same song selected
                                            else if (nowIndex == index) {
                                              Provider.of<NowPlayMusicProvider>(
                                                      context,
                                                      listen: false)
                                                  .isPlay = false;

                                              selectedValue = 1;
                                            }

                                            // different song selected
                                            else if (nowIndex >= 0 &&
                                                nowIndex != index) {
                                              nowIndex = index;
                                              selectedValue = 2;
                                            }
                                            Provider.of<NowPlayMusicProvider>(
                                                    context,
                                                    listen: false)
                                                .nowMusicIndex = nowIndex;

                                            setState(() {
                                              if (selectedValue == 0) {
                                                PlayMusic.playUrlFunc(Provider
                                                        .of<NowPlayMusicProvider>(
                                                            context,
                                                            listen: false)
                                                    .musicInfoData
                                                    .musicPath);
                                              } else if (selectedValue == 2) {
                                                PlayMusic.stopFunc();

                                                // _clearSubscriptions();
                                                PlayMusic.makeNewPlayer();

                                                _initSubscription();

                                                PlayMusic.playUrlFunc(Provider
                                                        .of<NowPlayMusicProvider>(
                                                            context,
                                                            listen: false)
                                                    .musicInfoData
                                                    .musicPath);
                                              } else if (selectedValue == 1) {
                                                PlayMusic.playOrPauseFunc();
                                              }
                                              bottomPlayListWidget =
                                                  BottomWidgets.miniPlayer;
                                            });
                                          }),
                                      IconButton(
                                          icon: Icon(
                                            Icons.favorite_border_outlined,
                                            size: 16,
                                          ),
                                          onPressed: null),
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
              Visibility(
                visible: bottomPlayListWidget == BottomWidgets.miniPlayer
                    ? true
                    : false,
                child: SmallPlayListWidget(
                  musicList: musicList,
                ),
              ),
              Visibility(
                visible: bottomSeletListWidget == BottomWidgets.miniSelectList
                    ? true
                    : false,
                child: SmallSelectListWidget(
                  musicList: musicList,
                  selectedList: selectedList,
                  snackBarFunc: showAndHideSnackBar,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // _buildBestTwenty() {
  //   return Padding(
  //     padding: const EdgeInsets.only(left: 10, right: 10),
  //     child: Column(
  //       children: [
  //         SelectButtonsWidget(selectAllMusicFunc: selectAllMusicFunc),
  //         playListOfThisWeek(),
  //       ],
  //     ),
  //   );
  // }

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
          ? bottomSeletListWidget = BottomWidgets.miniSelectList
          : bottomSeletListWidget = BottomWidgets.none;
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
}
