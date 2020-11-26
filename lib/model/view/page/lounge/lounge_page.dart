import 'dart:async';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/material.dart';
import 'package:music_minorleague/model/data/music_info_data.dart';
import 'package:music_minorleague/model/enum/music_type_enum.dart';
import 'package:music_minorleague/model/provider/now_play_music_provider.dart';
import 'package:music_minorleague/model/provider/user_profile_provider.dart';
import 'package:music_minorleague/model/view/style/colors.dart';
import 'package:music_minorleague/model/view/style/size_config.dart';
import 'package:music_minorleague/model/view/style/textstyles.dart';
import 'package:music_minorleague/utils/play_func.dart';
import 'package:provider/provider.dart';

import 'component/small_play_list_widget.dart';
import 'component/small_select_list_widget.dart';

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
  TabController tabController;

  BottomWidgets bottomWidget = BottomWidgets.none;
  bool isTabThisWeekMusicListItem;

  List<MusicInfoData> musicInfoList;

  List<MusicInfoData> thisWeekMusicList;
  List<bool> selectedList;
  // List<bool> isPlayList;

  final List<StreamSubscription> _subscriptions = [];
  AssetsAudioPlayer _assetsAudioPlayer;

  @override
  void initState() {
    super.initState();
    // tabController = TabController(vsync: this, length: 2);

    isTabThisWeekMusicListItem = false;
    musicInfoList = new List<MusicInfoData>();

    //TODO: get music list from firebase store
    thisWeekMusicList = new List<MusicInfoData>();

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
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          '라운지',
          style: MTextStyles.bold18Black,
        ),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
//         bottom: PreferredSize(
//           preferredSize: Size.fromHeight(43),
//           child: Align(
//             alignment: Alignment.centerLeft,
//             child: TabBar(
//               labelPadding: EdgeInsets.only(left: 10, right: 10),
//               labelStyle: MTextStyles.bold14Tomato,
//               unselectedLabelStyle: MTextStyles.bold14PinkishGrey,
//               controller: tabController,
//               indicator: UnderlineTabIndicator(
//                 borderSide: BorderSide(width: 2.0, color: MColors.tomato),
//                 insets: EdgeInsets.only(
//                   left: 16,
//                   right: 16,
//                 ),
//               ),
//               indicatorSize: TabBarIndicatorSize.tab,
//               labelColor: MColors.tomato,
//               unselectedLabelColor: MColors.pinkish_grey,
// //                      isScrollable: true,
//               tabs: [
//                 Container(
//                     alignment: Alignment.bottomCenter,
//                     padding: EdgeInsets.only(bottom: 11.0),
//                     child: Text(
//                       '이번주 음악',
//                     )),
//                 Container(
//                     alignment: Alignment.bottomCenter,
//                     padding: EdgeInsets.only(bottom: 11.0),
//                     child: Text(
//                       '베스트 20',
//                     )),
//                 // Container(
//                 //     alignment: Alignment.bottomCenter,
//                 //     padding: EdgeInsets.only(bottom: 11.0),
//                 //     child: Text(
//                 //       '내가 찜한 음악',
//                 //     )),
//               ],
//             ),
//           ),
//         ),
      ),
      body: _buildThisWeekNewPage(),
      // TabBarView(
      //   controller: tabController,
      //   children: [
      //     _buildThisWeekNewPage(),
      //     _buildBestTwenty(),
      //   ],
      // ),
    );
  }

  _buildThisWeekNewPage() {
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10),
      child: Column(
        children: [
          PlayWidget(),
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
                                          ? bottomWidget =
                                              BottomWidgets.miniSelectList
                                          : bottomWidget = BottomWidgets.none;
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
                                                ? Icons.pause
                                                : Icons.play_arrow_outlined,
                                          ),
                                          onPressed: () {
                                            MusicInfoData musicInfoData =
                                                new MusicInfoData(
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
                                              favoriteCnt: snapshot
                                                  .data.docs[index]['favorite'],
                                              musicTypeEnum:
                                                  EnumToString.fromString(
                                                      MusicTypeEnum.values,
                                                      snapshot.data.docs[index]
                                                          ['musicType']),
                                            );
                                            Provider.of<NowPlayMusicProvider>(
                                                    context,
                                                    listen: false)
                                                .musicInfoData = musicInfoData;

                                            // play 선택한 항목이 이전 선택한 항목이 아니면 oldmusicindex 에 복사 후 재생/정지 변경
                                            int oldIndex = Provider.of<
                                                        NowPlayMusicProvider>(
                                                    context,
                                                    listen: false)
                                                .oldMusicIndex;
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
                                              oldIndex = nowIndex;
                                              nowIndex = index;
                                              selectedValue = 2;
                                            }
                                            Provider.of<NowPlayMusicProvider>(
                                                    context,
                                                    listen: false)
                                                .nowMusicIndex = nowIndex;

                                            Provider.of<NowPlayMusicProvider>(
                                                    context,
                                                    listen: false)
                                                .oldMusicIndex = oldIndex;

                                            setState(() {
                                              if (selectedValue == 0) {
                                                PlayMusic.playUrlFunc(Provider
                                                        .of<NowPlayMusicProvider>(
                                                            context,
                                                            listen: false)
                                                    .musicInfoData
                                                    .musicPath);
                                                Provider.of<NowPlayMusicProvider>(
                                                        context,
                                                        listen: false)
                                                    .oldMusicIndex = Provider
                                                        .of<NowPlayMusicProvider>(
                                                            context,
                                                            listen: false)
                                                    .nowMusicIndex;
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
                                                Provider.of<NowPlayMusicProvider>(
                                                        context,
                                                        listen: false)
                                                    .oldMusicIndex = Provider
                                                        .of<NowPlayMusicProvider>(
                                                            context,
                                                            listen: false)
                                                    .nowMusicIndex;
                                              } else if (selectedValue == 1) {
                                                PlayMusic.playOrPauseFunc();
                                              }
                                              bottomWidget =
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
                visible:
                    bottomWidget == BottomWidgets.miniSelectList ? true : false,
                child: SmallSelectListWidget(
                    thisWeekMusicList: thisWeekMusicList,
                    selectedList: selectedList),
              ),
              Visibility(
                visible:
                    bottomWidget == BottomWidgets.miniPlayer ? true : false,
                child: SmallPlayListWidget(
                  thisWeekMusicList: thisWeekMusicList,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  _buildBestTwenty() {
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10),
      child: Column(
        children: [
          PlayWidget(),
          playListOfThisWeek(),
        ],
      ),
    );
  }

  void _clearSubscriptions() {
    for (var s in _subscriptions) {
      s?.cancel();
      s = null;
    }
    _subscriptions.clear();
  }
}

class PlayWidget extends StatelessWidget {
  const PlayWidget({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          children: [
            IconButton(icon: Icon(Icons.check), onPressed: null),
            Text(
              '전체선택',
              style: MTextStyles.bold12PinkishGrey,
            ),
          ],
        ),
        // Row(
        //   children: [
        //     Column(
        //       children: [
        //         IconButton(icon: Icon(Icons.shuffle), onPressed: null),
        //         Text(
        //           '셔플재생',
        //           style: MTextStyles.bold12PinkishGrey,
        //         ),
        //       ],
        //     ),
        //     Column(
        //       children: [
        //         IconButton(
        //             icon: Icon(Icons.play_arrow_outlined), onPressed: null),
        //         Text(
        //           '전체재생',
        //           style: MTextStyles.bold12PinkishGrey,
        //         ),
        //       ],
        //     ),
        //   ],
        // ),
      ],
    );
  }
}
