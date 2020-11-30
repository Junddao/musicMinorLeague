import 'dart:async';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:music_minorleague/model/data/music_info_data.dart';
import 'package:music_minorleague/model/enum/music_type_enum.dart';
import 'package:music_minorleague/model/provider/now_play_music_provider.dart';
import 'package:music_minorleague/model/view/style/textstyles.dart';
import 'package:music_minorleague/utils/play_func.dart';
import 'package:provider/provider.dart';

class MyPlayListPage extends StatefulWidget {
  @override
  _MyPlayListPageState createState() => _MyPlayListPageState();
}

class _MyPlayListPageState extends State<MyPlayListPage> {
  AssetsAudioPlayer _assetsAudioPlayer;
  final List<StreamSubscription> _subscriptions = [];
  List<MusicInfoData> _selectedMusicList;

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
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: _body(),
    );
  }

  _appBar() {}

  _body() {
    return playListOfThisWeek();
  }

  Widget playListOfThisWeek() {
    return Flex(
      direction: Axis.vertical,
      children: [
        Expanded(
          child: Stack(
            children: [
              // if (isPlayList?.length != snapshot.data.docs.length) {
              //   isPlayList = null;
              //   isPlayList = List.generate(
              //       snapshot.data.docs.length, (index) => false);
              // }

              StreamBuilder<Object>(
                  stream: PlayMusic.getCurrentStream(),
                  builder: (context, snapshotCurrent) {
                    return ListView.builder(
                      itemCount: _selectedMusicList.length,
                      itemBuilder: (context, index) {
                        return Container(
                          height: 72,
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundImage: NetworkImage(
                                  _selectedMusicList[index].imagePath),
                            ),
                            title: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _selectedMusicList[index].title,
                                  style: MTextStyles.bold14Grey06,
                                ),
                                SizedBox(
                                  width: 6,
                                ),
                                Text(
                                  _selectedMusicList[index].artist,
                                  maxLines: 1,
                                  style:
                                      MTextStyles.regular12WarmGrey_underline,
                                ),
                              ],
                            ),
                            trailing: Wrap(
                              children: [
                                IconButton(
                                    iconSize: 14,
                                    icon: Icon(
                                      Provider.of<NowPlayMusicProvider>(context,
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
                                              title: _selectedMusicList[index]
                                                  .title,
                                              artist: _selectedMusicList[index]
                                                  .artist,
                                              musicPath:
                                                  _selectedMusicList[index]
                                                      .musicPath,
                                              imagePath:
                                                  _selectedMusicList[index]
                                                      .imagePath,
                                              dateTime:
                                                  _selectedMusicList[index]
                                                      .dateTime,
                                              favorite:
                                                  _selectedMusicList[index]
                                                      .favorite,
                                              musicType:
                                                  _selectedMusicList[index]
                                                      .musicType);

                                      Provider.of<NowPlayMusicProvider>(context,
                                              listen: false)
                                          .musicInfoData = musicInfoData;

                                      int nowIndex =
                                          Provider.of<NowPlayMusicProvider>(
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
                                      Provider.of<NowPlayMusicProvider>(context,
                                              listen: false)
                                          .nowMusicIndex = nowIndex;

                                      setState(() {
                                        if (selectedValue == 0) {
                                          PlayMusic.playUrlFunc(
                                              Provider.of<NowPlayMusicProvider>(
                                                      context,
                                                      listen: false)
                                                  .musicInfoData
                                                  .musicPath);
                                        } else if (selectedValue == 2) {
                                          PlayMusic.stopFunc();

                                          PlayMusic.makeNewPlayer();
                                          _initSubscription();

                                          PlayMusic.playUrlFunc(
                                              Provider.of<NowPlayMusicProvider>(
                                                      context,
                                                      listen: false)
                                                  .musicInfoData
                                                  .musicPath);
                                        } else if (selectedValue == 1) {
                                          PlayMusic.playOrPauseFunc();
                                        }
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
                  }),
            ],
          ),
        ),
      ],
    );
  }
}
