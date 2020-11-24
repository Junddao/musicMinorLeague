import 'dart:async';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:music_minorleague/model/data/music_info_data.dart';
import 'package:music_minorleague/model/provider/now_play_music_provider.dart';
import 'package:music_minorleague/model/view/style/colors.dart';
import 'package:music_minorleague/model/view/style/size_config.dart';
import 'package:music_minorleague/model/view/style/textstyles.dart';
import 'package:music_minorleague/utils/play_func.dart';
import 'package:provider/provider.dart';

class SmallPlayListWidget extends StatefulWidget {
  const SmallPlayListWidget({
    Key key,
    playMusicIndex,
    List<MusicInfoData> thisWeekMusicList,
    List<bool> isPlayList,
    Function playOrPauseFunc,
  })  : _playMusicIndex = playMusicIndex,
        _thisWeekMusicList = thisWeekMusicList,
        _isPlayList = isPlayList,
        _playOrPauseFunc = playOrPauseFunc,
        super(key: key);

  final int _playMusicIndex;
  final List<MusicInfoData> _thisWeekMusicList;
  final List<bool> _isPlayList;
  final Function _playOrPauseFunc;

  @override
  _SmallPlayListWidgetState createState() => _SmallPlayListWidgetState();
}

class _SmallPlayListWidgetState extends State<SmallPlayListWidget> {
  Duration position = new Duration();
  Duration musicLength = new Duration();
  final List<StreamSubscription> _subscriptions = [];
  AssetsAudioPlayer _assetsAudioPlayer;

  @override
  void initState() {
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

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 0,
      child: Container(
          height: 130,
          width: SizeConfig.screenWidth - 20,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(
              Radius.circular(16),
            ),
            border: Border.all(color: Colors.black12, width: 1),
            color: Colors.white,
          ),
          child: Column(
            children: [
              Container(
                height: 80,
                child: ListTile(
                  leading: CircleAvatar(
                      backgroundImage: NetworkImage(
                          Provider.of<NowPlayMusicProvider>(context,
                                  listen: false)
                              .musicInfoData
                              .imagePath)),
                  title: InkWell(
                    onTap: () {
                      Navigator.of(context).pushNamed('MyMusicPlayerPage');
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          Provider.of<NowPlayMusicProvider>(context,
                                      listen: false)
                                  .musicInfoData
                                  ?.title ??
                              '',
                          style: MTextStyles.bold14Grey06,
                        ),
                        SizedBox(
                          width: 6,
                        ),
                        Text(
                          Provider.of<NowPlayMusicProvider>(context,
                                      listen: false)
                                  .musicInfoData
                                  ?.artist ??
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
                          onPressed: null),
                      IconButton(
                          icon: Icon(widget._playMusicIndex != null
                              ? widget._isPlayList[widget._playMusicIndex]
                                  ? Icons.pause
                                  : Icons.play_arrow_outlined
                              : Icons.play_arrow_outlined),
                          onPressed: () {
                            setState(() {
                              widget._playOrPauseFunc();
                            });
                            widget._isPlayList[widget._playMusicIndex] == true
                                ? PlayMusic.playUrlFunc(
                                    Provider.of<NowPlayMusicProvider>(context,
                                            listen: false)
                                        .musicInfoData
                                        .musicPath)
                                : PlayMusic.pauseFunc();
                          }),
                      IconButton(
                          icon: Icon(
                            Icons.skip_next,
                          ),
                          onPressed: null),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 40,
                child: Padding(
                  padding: const EdgeInsets.only(left: 15, right: 15),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          SizedBox(
                            height: 20,
                            child: StreamBuilder<Object>(
                                stream: PlayMusic.getCurrentStream(),
                                builder: (context, snapshot) {
                                  if (!snapshot.hasData) {
                                    return SizedBox.shrink();
                                  }
                                  final Playing playing = snapshot.data;
                                  return Row(
                                    children: [
                                      StreamBuilder(
                                        stream: PlayMusic.getPositionStream(),
                                        builder: (context, snapshot) {
                                          return Text(
                                            snapshot.data
                                                .toString()
                                                .substring(2, 7),
                                            style: MTextStyles.regular12Grey06,
                                          );
                                        },
                                      ),
                                      Text(' / '),
                                      StreamBuilder(
                                        stream: PlayMusic.getSongLengthStream(),
                                        builder: (context, snapshot) {
                                          if (!snapshot.hasData) {
                                            return SizedBox.shrink();
                                          }
                                          final RealtimePlayingInfos infos =
                                              snapshot.data;
                                          return Text(
                                            infos.duration
                                                .toString()
                                                .substring(2, 7),
                                            style:
                                                MTextStyles.regular10WarmGrey,
                                          );
                                        },
                                      ),
                                    ],
                                  );
                                }),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 20,
                        child: SliderTheme(
                          data: SliderTheme.of(context).copyWith(
                            activeTrackColor: MColors.tomato,
                            inactiveTrackColor: MColors.warm_grey,
                            trackHeight: 2.0,
                            thumbColor: MColors.kakao_yellow,
                            thumbShape:
                                RoundSliderThumbShape(enabledThumbRadius: 8.0),
                            overlayColor: Colors.purple.withAlpha(32),
                            overlayShape:
                                RoundSliderOverlayShape(overlayRadius: 14.0),
                          ),
                          child: StreamBuilder(
                            stream:
                                PlayMusic.assetsAudioPlayer().currentPosition,
                            builder: (context, snapshot) {
                              return Slider(
                                  min: 0,
                                  max: musicLength.inSeconds.toDouble(),
                                  value: position.inSeconds.toDouble(),
                                  onChanged: (value) {
                                    setState(() {
                                      seekToSec(value.toInt());
                                    });
                                  });
                            },
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          )),
    );
  }

  void seekToSec(int sec) {
    Duration newPos = Duration(seconds: sec);
    PlayMusic.seekFunc(newPos);
  }
}
