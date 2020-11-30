import 'dart:async';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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
    List<MusicInfoData> musicList,
  })  : _musicList = musicList,
        super(key: key);

  final List<MusicInfoData> _musicList;

  @override
  _SmallPlayListWidgetState createState() => _SmallPlayListWidgetState();
}

class _SmallPlayListWidgetState extends State<SmallPlayListWidget> {
  Duration position = new Duration();
  Duration musicLength = new Duration();
  final List<StreamSubscription> _subscriptions = [];
  AssetsAudioPlayer _assetsAudioPlayer;

  int oldMusicIndex = -1;

  @override
  void initState() {
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
            border: Border.all(color: MColors.black, width: 1),
            color: MColors.white,
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
                          iconSize: 12,
                          icon: Icon(Provider.of<NowPlayMusicProvider>(context,
                                          listen: false)
                                      .nowMusicIndex !=
                                  null
                              ? Provider.of<NowPlayMusicProvider>(context,
                                              listen: false)
                                          .isPlay ==
                                      true
                                  ? FontAwesomeIcons.pause
                                  : FontAwesomeIcons.play
                              : FontAwesomeIcons.play),
                          onPressed: () {
                            setState(() {
                              PlayMusic.playOrPauseFunc();
                            });
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
                  child: StreamBuilder<Object>(
                    stream: PlayMusic.getCurrentStream(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return SizedBox.shrink();
                      }
                      final Playing playing = snapshot.data;
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              SizedBox(
                                height: 20,
                                child: Row(
                                  children: [
                                    StreamBuilder(
                                      stream: PlayMusic.getPositionStream(),
                                      builder: (context, snapshot) {
                                        if (!snapshot.hasData) {
                                          return SizedBox.shrink();
                                        }
                                        position = snapshot.data;
                                        return Text(
                                          durationToString(snapshot.data),
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
                                        musicLength = infos.duration;
                                        return Text(
                                          durationToString(infos.duration),
                                          style: MTextStyles.regular10WarmGrey,
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          StreamBuilder(
                              stream: PlayMusic.getPositionStream(),
                              builder: (context, snapshot) {
                                if (!snapshot.hasData) {
                                  return SizedBox.shrink();
                                }
                                return Expanded(
                                  child: SliderTheme(
                                    data: SliderTheme.of(context).copyWith(
                                      activeTrackColor: MColors.tomato,
                                      inactiveTrackColor: MColors.warm_grey,
                                      trackHeight: 2.0,
                                      thumbColor: MColors.kakao_yellow,
                                      thumbShape: RoundSliderThumbShape(
                                          enabledThumbRadius: 8.0),
                                      overlayColor: Colors.purple.withAlpha(32),
                                      overlayShape: RoundSliderOverlayShape(
                                          overlayRadius: 14.0),
                                    ),
                                    child: Slider(
                                      min: 0,
                                      max:
                                          musicLength.inMilliseconds.toDouble(),
                                      value: position.inMilliseconds.toDouble(),
                                      onChanged: (value) {
                                        setState(() {
                                          PlayMusic.seekFunc(Duration(
                                              milliseconds: value.floor()));
                                        });
                                      },
                                    ),
                                  ),
                                );
                              }),
                        ],
                      );
                    },
                  ),
                ),
              ),
            ],
          )),
    );
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
