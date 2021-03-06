import 'dart:async';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:extended_image/extended_image.dart';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:music_minorleague/model/data/music_info_data.dart';
import 'package:music_minorleague/model/data/user_profile_data.dart';
import 'package:music_minorleague/model/enum/lounge_bottom_widget_enum.dart';

import 'package:music_minorleague/model/provider/mini_widget_status_provider.dart';

import 'package:music_minorleague/model/provider/user_profile_provider.dart';

import 'package:music_minorleague/model/view/page/playlist/component/my_playlist_small_select_list_widget.dart';
import 'package:music_minorleague/model/view/page/playlist/component/my_select_buttons_widget.dart';

import 'package:music_minorleague/model/view/style/colors.dart';

import 'package:music_minorleague/model/view/style/textstyles.dart';
import 'package:music_minorleague/model/view/widgets/small_play_list_widget.dart';

import 'package:music_minorleague/utils/firebase_db_helper.dart';
import 'package:music_minorleague/utils/play_func.dart';
import 'package:provider/provider.dart';

class MyPlayListPage extends StatefulWidget {
  @override
  _MyPlayListPageState createState() => _MyPlayListPageState();
}

class _MyPlayListPageState extends State<MyPlayListPage>
    with SingleTickerProviderStateMixin {
  final _scaffoldKey = new GlobalKey<ScaffoldState>();
  AnimationController _controller;

  AssetsAudioPlayer _assetsAudioPlayer;
  final List<StreamSubscription> _subscriptions = [];

  List<MusicInfoData> _myMusicList = new List<MusicInfoData>();
  List<MusicInfoData> selectedMusicList = new List<MusicInfoData>();
  List<bool> _selectedList;

  BottomWidgets myPlayListWidgetEnum;
  BottomWidgets myMiniPlayer;

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

      // setState(() {});
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
    _controller = AnimationController(
        vsync: this,
        duration: Duration(seconds: 1),
        lowerBound: 0.0,
        upperBound: 1.0);
    super.initState();
    selectedMusicList = new List<MusicInfoData>();
    _selectedList = new List<bool>();
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
    // if (!_selectedList.contains(true)) {
    //   context.watch<MiniWidgetStatusProvider>().myBottomSelectListWidget =
    //       BottomWidgets.none;
    // }
    String userId = context.watch<UserProfileProvider>().userProfileData.id;
    return userId == 'Guest'
        ? Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Login 후 사용가능 합니다. 😛'),
                SizedBox(
                  height: 20,
                ),
                GestureDetector(
                  onTap: () {
                    PlayMusic.pauseFunc();
                    Navigator.of(context)
                        .pushNamedAndRemoveUntil("LoginPage", (route) => false);
                  },
                  child: Container(
                      alignment: Alignment.center,
                      height: 40,
                      width: 250,
                      decoration: BoxDecoration(
                          color: MColors.tomato,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(width: 1, color: MColors.tomato)),
                      child: Text(
                        '로그인 페이지로 이동하기',
                        style: MTextStyles.bold12White,
                      )),
                ),
              ],
            ),
          )
        : Stack(
            fit: StackFit.expand,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 10, right: 10),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      MySelectButtonsWidget(
                          selectAllMusicFunc: selectAllMusicFunc),
                      mySelectedMusicListWidget(),
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
                                .myBottomSelectListWidget ==
                            BottomWidgets.myMiniSelctList &&
                        _selectedList.contains(true)
                    ? true
                    : false,
                child: MyPlaylistSmallSelectListWidget(
                  musicList: _myMusicList,
                  selectedList: _selectedList,
                  playOrPauseMusicForSelectedListFunc:
                      playOrPauseMusicForSelectedList,
                  refreshSelectedListAndWidgetFunc:
                      refreshSelectedListAndWidgetFunc,
                ),
              ),
            ],
          );
  }

  Widget mySelectedMusicListWidget() {
    String mainCollection = FirebaseDBHelper.myMusicCollection;
    String mainDoc =
        Provider.of<UserProfileProvider>(context).userProfileData.id;
    String subCollection = FirebaseDBHelper.mySelectedMusicCollection;

    return Container(
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
              _myMusicList = FirebaseDBHelper.getMusicDatabase(snapshot.data);

              if (_selectedList?.length != _myMusicList.length) {
                _selectedList =
                    List.generate(_myMusicList.length, (index) => false);
              }
            }

            return Stack(
              children: [
                ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: _myMusicList.length,
                  itemBuilder: (context, index) {
                    return Column(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(0.0),
                          child: Container(
                            height: 72,
                            color: _selectedList[index] == true
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
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          onTap: () {
                                            _selectedList[index] =
                                                !_selectedList[index];
                                            getSelectedMusicList();
                                            _selectedList.contains(true)
                                                ? Provider.of<MiniWidgetStatusProvider>(
                                                            context,
                                                            listen: false)
                                                        .myBottomSelectListWidget =
                                                    BottomWidgets
                                                        .myMiniSelctList
                                                : Provider.of<MiniWidgetStatusProvider>(
                                                            context,
                                                            listen: false)
                                                        .myBottomSelectListWidget =
                                                    BottomWidgets.none;
                                          },
                                          leading: InkWell(
                                            onTap: () {
                                              String collection =
                                                  FirebaseDBHelper
                                                      .userCollection;
                                              String doc =
                                                  _myMusicList[index].userId;

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
                                                _myMusicList[index]?.imagePath,
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
                                                _myMusicList[index].title,
                                                style: _selectedList[index] ==
                                                        true
                                                    ? MTextStyles.bold14White
                                                    : MTextStyles.bold14Grey06,
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
                                                      ? _selectedList[index] ==
                                                              true
                                                          ? MColors.white
                                                          : MColors.black
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
          }),
    );
  }

  refreshSelectedListAndWidgetFunc() {
    Provider.of<MiniWidgetStatusProvider>(context, listen: false)
        .myBottomSelectListWidget = BottomWidgets.none;
    _selectedList.forEach((element) {
      element = false;
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
      for (int i = 0; i < _selectedList.length; i++) {
        if (_selectedList[i] == true) {
          selectedMusicList.add(_myMusicList[i]);
        }
      }
      _selectedList.contains(true)
          ? Provider.of<MiniWidgetStatusProvider>(context, listen: false)
              .myBottomSelectListWidget = BottomWidgets.myMiniSelctList
          : Provider.of<MiniWidgetStatusProvider>(context, listen: false)
              .myBottomSelectListWidget = BottomWidgets.none;
    });
  }

  void getSelectedMusicList() {
    selectedMusicList.clear();
    for (int i = 0; i < _selectedList.length; i++) {
      if (_selectedList[i] == true) {
        selectedMusicList.add(_myMusicList[i]);
      }
    }
  }

  void playOrPauseMusicForSelectedList() {
    PlayMusic.stopFunc().whenComplete(() {
      PlayMusic.clearAudioPlayer();
      PlayMusic.makeNewPlayer();
      PlayMusic.playListFunc(selectedMusicList).then((value) {
        context.read<MiniWidgetStatusProvider>().myBottomSelectListWidget =
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
          });
        });
      }
    }
  }
}
