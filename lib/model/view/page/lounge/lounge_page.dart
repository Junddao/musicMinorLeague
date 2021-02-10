import 'dart:async';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:music_minorleague/model/data/music_info_data.dart';
import 'package:music_minorleague/model/data/user_profile_data.dart';
import 'package:music_minorleague/model/enum/lounge_bottom_widget_enum.dart';
import 'package:music_minorleague/model/enum/lounge_music_type_enum.dart';
import 'package:music_minorleague/model/enum/music_type_enum.dart';
import 'package:music_minorleague/model/provider/mini_widget_status_provider.dart';
import 'package:music_minorleague/model/provider/now_play_music_provider.dart';
import 'package:music_minorleague/model/provider/thumb_up_provider.dart';

import 'package:music_minorleague/model/view/page/lounge/component/select_buttons_widget.dart';
import 'package:music_minorleague/model/view/page/user_profile/other_user_profile_page.dart';
import 'package:music_minorleague/model/view/style/colors.dart';
import 'package:music_minorleague/model/view/style/size_config.dart';
import 'package:music_minorleague/model/view/style/textstyles.dart';
import 'package:music_minorleague/model/view/widgets/small_play_list_widget.dart';

import 'package:music_minorleague/utils/firebase_db_helper.dart';
import 'package:music_minorleague/utils/play_func.dart';
import 'package:provider/provider.dart';

import 'component/lounge_choice_chip_widget.dart';

import 'component/small_select_list_widget.dart';
import 'component/top_twenty_music_widget.dart';

class LoungePage extends StatefulWidget {
  @override
  _LoungePageState createState() => _LoungePageState();
}

class _LoungePageState extends State<LoungePage>
    with SingleTickerProviderStateMixin {
  final _scaffoldKey = new GlobalKey<ScaffoldState>();
  AnimationController _controller;

  bool isTabThisWeekMusicListItem;

  List<MusicInfoData> musicList;
  List<MusicInfoData> topTwentyMusicList;
  List<MusicInfoData> selectedMusicList;

  List<bool> selectedList;

  // List<bool> isPlayList;

  int selectedThumbIndex = -1;

  final List<StreamSubscription> _subscriptions = [];
  AssetsAudioPlayer _assetsAudioPlayer;

  LoungeMusicTypeEnum _typeOfMusic;
  List<LoungeMusicTypeEnum> typeOfMusicList;

  @override
  void initState() {
    _controller = AnimationController(
        vsync: this,
        duration: Duration(seconds: 1),
        lowerBound: 0.0,
        upperBound: 1.0);
    super.initState();

    // tabController = TabController(vsync: this, length: 2);

    isTabThisWeekMusicListItem = false;
    musicList = new List<MusicInfoData>();
    topTwentyMusicList = new List<MusicInfoData>();
    selectedMusicList = new List<MusicInfoData>();
    selectedList = new List<bool>();
    _typeOfMusic = LoungeMusicTypeEnum.all;
    typeOfMusicList = List.generate(LoungeMusicTypeEnum.values.length,
        (index) => LoungeMusicTypeEnum.values[index]);

    // _initSubscription();
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
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    // page 넘오올때 초기화 해줘야 한다.
    // if (!selectedList.contains(true)) {
    //   context.watch<MiniWidgetStatusProvider>().bottomSeletListWidget =
    //       BottomWidgets.none;
    // }

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          '라운지',
          style: MTextStyles.bold18Black,
        ),
        centerTitle: false,
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        // actions: [
        //   IconButton(
        //     icon: Icon(Icons.search),
        //     onPressed: () {

        //     },
        //   ),
        // ],
      ),
      body: _buildThisWeekNewPage(),
    );
  }

  _buildThisWeekNewPage() {
    return Stack(
      fit: StackFit.expand,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 10, right: 10),
          child: SingleChildScrollView(
            physics: ScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
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
                      List<MusicInfoData> _twentyList =
                          new List<MusicInfoData>();
                      _twentyList =
                          FirebaseDBHelper.getMusicDatabase(snapshot.data);

                      //favorite 로 정렬
                      _twentyList
                          .sort((a, b) => b.favorite.compareTo(a.favorite));

                      if (_twentyList.length > 20)
                        _twentyList = _twentyList.sublist(0, 20);

                      return TopTwentyMusicWidget(
                          _twentyList, playOrpauseMusic);
                    }
                  },
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(left: 20.0, top: 40, bottom: 12.0),
                  child: Text(
                    '최신음악',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: MColors.blackColor),
                  ),
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Wrap(
                    alignment: WrapAlignment.start,
                    direction: Axis.horizontal,
                    spacing: 5.0, // gap between adjacent chips
                    runSpacing: 5.0, // gap between lines

                    children: [
                      LoungeChoiceChipWidget(
                        typeOfMusicList: typeOfMusicList,
                        returnDataFunc: returnDataFunc,
                      ),
                    ],
                  ),
                ),
                SelectButtonsWidget(selectAllMusicFunc: selectAllMusicFunc),
                playListOfThisWeek(),
                SizedBox(
                  height: 110,
                ),
              ],
            ),
          ),
        ),
        Visibility(
          visible: Provider.of<MiniWidgetStatusProvider>(context)
                      .bottomPlayListWidget ==
                  BottomWidgets.miniPlayer
              ? true
              : false,
          child: SmallPlayListWidget(),
        ),
        Visibility(
          visible: Provider.of<MiniWidgetStatusProvider>(context)
                          .bottomSeletListWidget ==
                      BottomWidgets.miniSelectList &&
                  selectedList.contains(true)
              ? true
              : false,
          child: SmallSelectListWidget(
            musicList: musicList,
            selectedList: selectedList,
            snackBarFunc: showAndHideSnackBar,
            playOrPauseMusicForSelectedListFunc:
                playOrPauseMusicForSelectedList,
          ),
        ),
      ],
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
              var allMusicList =
                  FirebaseDBHelper.getMusicDatabase(snapshot.data);
              if (_typeOfMusic == LoungeMusicTypeEnum.all) {
                musicList = allMusicList;
              } else {
                musicList.clear();
                allMusicList.forEach((element) {
                  if (EnumToString.convertToString(element.musicType) ==
                      EnumToString.convertToString(_typeOfMusic)) {
                    musicList.add(element);
                  }
                });
              }

              musicList.sort((a, b) => b.dateTime.compareTo(a.dateTime));

              if (selectedList?.length != musicList.length) {
                selectedList.clear();
                selectedList =
                    List.generate(musicList.length, (index) => false);
              }
              return ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: musicList.length,
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(0.0),
                        child: Container(
                          height: 72,
                          color: selectedList[index] == true
                              ? MColors.grey_06
                              : Colors.transparent,
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
                                        onTap: () {
                                          selectedList[index] =
                                              !selectedList[index];
                                          getSelectedMusicList();
                                          selectedList.contains(true)
                                              ? Provider.of<MiniWidgetStatusProvider>(
                                                          context,
                                                          listen: false)
                                                      .bottomSeletListWidget =
                                                  BottomWidgets.miniSelectList
                                              : Provider.of<MiniWidgetStatusProvider>(
                                                          context,
                                                          listen: false)
                                                      .bottomSeletListWidget =
                                                  BottomWidgets.none;
                                        },
                                        leading: InkWell(
                                          onTap: () {
                                            String collection =
                                                FirebaseDBHelper.userCollection;
                                            String doc =
                                                musicList[index].userId;

                                            FirebaseDBHelper.getData(
                                                    collection, doc)
                                                .then((value) {
                                              UserProfileData
                                                  otherUserProfileData =
                                                  UserProfileData.fromMap(
                                                      value.data());

                                              Navigator.of(context).pushNamed(
                                                  'OtherUserProfilePage',
                                                  arguments:
                                                      otherUserProfileData);
                                            });
                                          },
                                          child: ClipOval(
                                            // borderRadius:
                                            //     BorderRadius.circular(4.0),
                                            child: ExtendedImage.network(
                                              musicList[index].imagePath,
                                              cache: true,
                                              width: 50,
                                              height: 50,
                                              fit: BoxFit.cover,
                                              loadStateChanged:
                                                  (ExtendedImageState state) {
                                                switch (state
                                                    .extendedImageLoadState) {
                                                  case LoadState.loading:
                                                    return SizedBox.shrink();
                                                    break;
                                                  case LoadState.completed:
                                                    _controller.forward();
                                                    return FadeTransition(
                                                      opacity: _controller,
                                                      child: ExtendedRawImage(
                                                        image: state
                                                            .extendedImageInfo
                                                            ?.image,
                                                        width: 50,
                                                        height: 50,
                                                        fit: BoxFit.cover,
                                                        // scale: 1.0,
                                                      ),
                                                    );
                                                    break;
                                                  case LoadState.failed:
                                                    _controller.reset();
                                                    return Image.asset(
                                                        'assets/images/default_cover_Image.jpg');
                                                    break;
                                                }
                                              },
                                            ),
                                          ),
                                        ),
                                        title: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              musicList[index].title,
                                              style: selectedList[index] == true
                                                  ? MTextStyles.bold14White
                                                  : MTextStyles.bold14Grey06,
                                            ),
                                            SizedBox(
                                              width: 6,
                                            ),
                                            Text(
                                              musicList[index].artist,
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
                                                    ? selectedList[index] ==
                                                            true
                                                        ? MColors.white
                                                        : MColors.black
                                                    : MColors.warm_grey,
                                                onPressed: () {
                                                  MusicInfoData musicInfoData =
                                                      MusicInfoData.fromMap(
                                                          musicList[index]
                                                              .toMap());

                                                  playOrpauseMusic(
                                                      musicInfoData,
                                                      currentMusicId);
                                                }),
                                            Container(
                                                height: 28,
                                                width: 28,
                                                child: IconButton(
                                                    icon: Icon(Icons
                                                        .thumb_up_alt_outlined),
                                                    onPressed: () {
                                                      context
                                                                  .read<
                                                                      ThumbUpProvider>()
                                                                  .thumbUpData
                                                                  .todayCnt >
                                                              0
                                                          ? _handleOnPressThumb(
                                                              index)
                                                          : showToastMessage(
                                                              '추천 갯수가 소진됐습니다.\n앱 종료 후 다시 실행시 추천 갯수는 보충됩니다.😛');
                                                    },
                                                    iconSize: 15,
                                                    color:
                                                        selectedList[index] ==
                                                                true
                                                            ? Colors.white
                                                            : MColors.grey_06)),
                                            SizedBox(
                                              width: 20,
                                              child: Text(
                                                musicList[index].favorite >
                                                        10000
                                                    ? '10000++'
                                                    : musicList[index]
                                                        .favorite
                                                        .toString(),
                                                style: selectedList[index] ==
                                                        true
                                                    ? MTextStyles.regular8White
                                                    : MTextStyles
                                                        .regular8Grey06,
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
      getSelectedMusicList();
    });
    selectedList.contains(true)
        ? Provider.of<MiniWidgetStatusProvider>(context, listen: false)
            .bottomSeletListWidget = BottomWidgets.miniSelectList
        : Provider.of<MiniWidgetStatusProvider>(context, listen: false)
            .bottomSeletListWidget = BottomWidgets.none;
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
      PlayMusic.clearAudioPlayer();
      PlayMusic.makeNewPlayer();
      PlayMusic.playListFunc(selectedMusicList).then((value) {
        context.read<MiniWidgetStatusProvider>().bottomSeletListWidget =
            BottomWidgets.none;
        context.read<MiniWidgetStatusProvider>().bottomPlayListWidget =
            BottomWidgets.miniPlayer;
      });
    });
  }

  void playOrpauseMusic(MusicInfoData musicInfoData, String currentPlayingId) {
    if (context.read<MiniWidgetStatusProvider>().bottomPlayListWidget ==
        BottomWidgets.none) {
      PlayMusic.makeNewPlayer();
      PlayMusic.playUrlFunc(musicInfoData).then((value) {
        context.read<MiniWidgetStatusProvider>().bottomPlayListWidget =
            BottomWidgets.miniPlayer;
      });
    } else {
      if (currentPlayingId == musicInfoData.id) {
        PlayMusic.playOrPauseFunc();
      } else {
        PlayMusic.stopFunc().whenComplete(() {
          PlayMusic.clearAudioPlayer();
          PlayMusic.makeNewPlayer();
          PlayMusic.playUrlFunc(musicInfoData).then((value) {
            setState(() {});
            // context.read<MiniWidgetStatusProvider>().bottomPlayListWidget =
            //     BottomWidgets.miniPlayer;
          });
        });
      }
    }
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
    selectedThumbIndex = index;
    // setState(() {
    //   selectedThumbIndex = index;
    // });

    context.read<ThumbUpProvider>().thumbUpData.todayCnt--;
  }

  void returnDataFunc(LoungeMusicTypeEnum selectedData) {
    setState(() {
      selectedList.clear();
      selectedMusicList.clear();
      _typeOfMusic = selectedData;
    });
  }

  showToastMessage(String msg) {
    Scaffold.of(context).showSnackBar(
        SnackBar(duration: Duration(seconds: 2), content: Text(msg)));
  }
}
