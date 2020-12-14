import 'dart:async';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:music_minorleague/model/data/music_info_data.dart';
import 'package:music_minorleague/model/provider/now_play_music_provider.dart';
import 'package:music_minorleague/model/view/page/lounge/component/position_seek_widget.dart';
import 'package:music_minorleague/model/view/style/colors.dart';
import 'package:music_minorleague/model/view/style/size_config.dart';
import 'package:music_minorleague/model/view/style/textstyles.dart';
import 'package:music_minorleague/utils/play_func.dart';
import 'package:provider/provider.dart';

class SmallPlayListWidget extends StatefulWidget {
  const SmallPlayListWidget({
    Key key,
    List<MusicInfoData> musicList,
    Function playNext,
    Function playPrevious,
  })  : _musicList = musicList,
        _playNext = playNext,
        _playPrevious = playPrevious,
        super(key: key);

  final List<MusicInfoData> _musicList;
  final Function _playNext;
  final Function _playPrevious;

  @override
  _SmallPlayListWidgetState createState() => _SmallPlayListWidgetState();
}

class _SmallPlayListWidgetState extends State<SmallPlayListWidget> {
  Duration position = new Duration();
  Duration musicLength = new Duration();
  final List<StreamSubscription> _subscriptions = [];
  AssetsAudioPlayer _assetsAudioPlayer;
  bool listenOnlyUserInterraction = false;

  int oldMusicIndex = -1;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 10,
      child: Container(
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
                    child: ExtendedImage.network(
                      Provider.of<NowPlayMusicProvider>(context, listen: false)
                          .musicInfoData
                          .imagePath,
                      cache: true,
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                      clearMemoryCacheWhenDispose: true,
                    ),
                  ),
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
                          style: MTextStyles.bold12Grey06,
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
                          style: MTextStyles.regular10WarmGrey,
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
                        iconSize: 20,
                        onPressed: () {
                          widget._playPrevious();
                        },
                      ),
                      IconButton(
                          iconSize: 10,
                          icon: Icon(Provider.of<NowPlayMusicProvider>(context,
                                          listen: false)
                                      .isPlay ==
                                  true
                              ? FontAwesomeIcons.pause
                              : FontAwesomeIcons.play),
                          color: Provider.of<NowPlayMusicProvider>(context,
                                          listen: false)
                                      .isPlay ==
                                  true
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
                        iconSize: 20,
                        onPressed: () {
                          widget._playNext();
                        },
                      ),
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
                    builder: (context, currentSnapshot) {
                      if (!currentSnapshot.hasData) {
                        return SizedBox.shrink();
                      }
                      final Playing playing = currentSnapshot.data;

                      return StreamBuilder(
                          stream: PlayMusic.getSongLengthStream(),
                          builder: (context, snapshot) {
                            if (!snapshot.hasData) {
                              return SizedBox.shrink();
                            }

                            final RealtimePlayingInfos infos = snapshot.data;
                            position = infos.currentPosition;
                            musicLength = infos.duration;
                            return PositionSeekWidget(
                                position: position,
                                infos: infos,
                                musicLength: musicLength);
                          });
                    },
                  ),
                ),
              ),
            ],
          )),
    );
  }
}
