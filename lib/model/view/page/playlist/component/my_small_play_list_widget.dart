import 'dart:async';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:music_minorleague/model/data/music_info_data.dart';

import 'package:music_minorleague/model/view/page/playlist/component/my_position_seek_widget.dart';
import 'package:music_minorleague/model/view/style/colors.dart';
import 'package:music_minorleague/model/view/style/size_config.dart';
import 'package:music_minorleague/model/view/style/textstyles.dart';
import 'package:music_minorleague/utils/play_func.dart';
import 'package:provider/provider.dart';

class MySmallPlayListWidget extends StatefulWidget {
  const MySmallPlayListWidget({
    Key key,
    List<MusicInfoData> musicList,
  })  : _musicList = musicList,
        super(key: key);

  final List<MusicInfoData> _musicList;

  @override
  _MySmallPlayListWidgetState createState() => _MySmallPlayListWidgetState();
}

class _MySmallPlayListWidgetState extends State<MySmallPlayListWidget> {
  Duration position = new Duration();
  Duration musicLength = new Duration();

  AssetsAudioPlayer _assetsAudioPlayer;
  bool listenOnlyUserInterraction = false;

  bool bMinButtonClick = false;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (bMinButtonClick == true) {
      return Positioned(
        bottom: 30,
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 15.0, bottom: 15.0),
              child: Container(
                height: 0,
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
                      blurRadius: 3.0,
                    ),
                  ],
                ),
                child: Center(child: Text('empty!')),
              ),
            ),
            Positioned(
              right: 10,
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    bMinButtonClick = !bMinButtonClick;
                  });

                  // Provider.of<MiniWidgetStatusProvider>(context, listen: false)
                  //     .bottomPlayListWidget = LoungeBottomWidgets.none;
                },
                child: CircleAvatar(
                  radius: 15,
                  backgroundColor: MColors.white,
                  foregroundColor: MColors.brownish_grey,
                  child: Icon(Icons.arrow_circle_up_outlined),
                ),
              ),
            ),
          ],
        ),
      );
    } else {
      return Positioned(
        bottom: 0,
        child: StreamBuilder(
            stream: PlayMusic.getCurrentStream(),
            builder: (context, currentSnapshot) {
              final Playing playing = currentSnapshot.data;
              final String currentMusicId = playing?.audio?.audio?.metas?.id;
              return StreamBuilder(
                  stream: PlayMusic.isPlayingFunc(),
                  builder: (context, playingSnapshot) {
                    final isPlaying = playingSnapshot.data;
                    return Container(
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
                              blurRadius: 3.0,
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            Container(
                              height: 50,
                              child: ListTile(
                                leading: ClipOval(
                                  // borderRadius:
                                  //     BorderRadius.circular(4.0),
                                  child: playing == null
                                      ? CircularProgressIndicator()
                                      : ExtendedImage.network(
                                          playing?.audio?.audio?.metas?.image
                                                  ?.path ??
                                              'https://cdn.pixabay.com/photo/2018/03/04/09/51/space-3197611_1280.jpg',
                                          cache: true,
                                          width: 40,
                                          height: 40,
                                          fit: BoxFit.cover,
                                          clearMemoryCacheWhenDispose: true,
                                        ),
                                ),
                                title: InkWell(
                                  onTap: () {
                                    Navigator.of(context)
                                        .pushNamed('MyMusicPlayerPage');
                                  },
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        playing?.audio?.audio?.metas?.title ??
                                            '',
                                        style: MTextStyles.bold14Grey06,
                                      ),
                                      SizedBox(
                                        width: 6,
                                      ),
                                      Text(
                                        playing?.audio?.audio?.metas?.artist ??
                                            '',
                                        maxLines: 1,
                                        style: MTextStyles.regular12WarmGrey,
                                      ),
                                    ],
                                  ),
                                ),
                                trailing: Wrap(
                                  children: [
                                    IconButton(
                                      icon: Icon(
                                        Icons.skip_previous,
                                      ),
                                      onPressed: () {
                                        playing.playlist.audios.length > 1
                                            ? PlayMusic.previous()
                                                .then((value) {
                                                value == true
                                                    ? print('prev ok')
                                                    : print('prev ng');
                                              })
                                            // widget._playNext()
                                            : null;
                                      },
                                    ),
                                    IconButton(
                                        iconSize: 12,
                                        icon: Icon(isPlaying == true
                                            ? FontAwesomeIcons.pause
                                            : FontAwesomeIcons.play),
                                        color: isPlaying == true
                                            ? MColors.black
                                            : MColors.warm_grey,
                                        onPressed: () {
                                          setState(() {
                                            PlayMusic.playOrPauseFunc();
                                          });
                                        }),
                                    IconButton(
                                      icon: Icon(
                                        Icons.skip_next,
                                      ),
                                      onPressed: () {
                                        playing.playlist.audios.length > 1
                                            ? PlayMusic.next().then((value) {
                                                value == true
                                                    ? print('next ok')
                                                    : print('next ng');
                                              })
                                            // widget._playNext()
                                            : null;
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 40,
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(left: 15, right: 15),
                                child: StreamBuilder<Object>(
                                  stream: PlayMusic.getCurrentStream(),
                                  builder: (context, snapshot) {
                                    if (!snapshot.hasData) {
                                      return SizedBox.shrink();
                                    }
                                    final Playing playing = snapshot.data;

                                    return StreamBuilder(
                                        stream: PlayMusic.getSongLengthStream(),
                                        builder: (context, snapshot) {
                                          if (!snapshot.hasData) {
                                            return SizedBox.shrink();
                                          }

                                          final RealtimePlayingInfos infos =
                                              snapshot.data;
                                          position = infos.currentPosition;
                                          musicLength = infos.duration;
                                          return MyPositionSeekWidget(
                                              position: position,
                                              infos: infos,
                                              musicLength: musicLength);
                                        });
                                  },
                                ),
                              ),
                            ),
                          ],
                        ));
                  });
            }),
      );
    }
  }

  String durationToString(Duration duration) {
    String twoDigits(int n) {
      if (n >= 10) return "$n";
      return "0$n";
    }

    String twoDigitMinutes =
        twoDigits(duration.inMinutes.remainder(Duration.minutesPerHour));
    String twoDigitSeconds =
        twoDigits(duration.inSeconds.remainder(Duration.secondsPerMinute));
    return "$twoDigitMinutes:$twoDigitSeconds";
  }
}
