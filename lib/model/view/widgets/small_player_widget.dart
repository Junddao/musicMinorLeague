import 'dart:async';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:music_minorleague/model/provider/mini_widget_status_provider.dart';
import 'package:music_minorleague/model/view/style/colors.dart';
import 'package:music_minorleague/model/view/style/size_config.dart';
import 'package:music_minorleague/model/view/style/textstyles.dart';
import 'package:music_minorleague/model/view/widgets/position_seek_widget.dart';
import 'package:music_minorleague/utils/play_func.dart';
import 'package:provider/provider.dart';

class SmallPlayerWidget extends StatefulWidget {
  const SmallPlayerWidget({
    Key key,
  }) : super(key: key);

  @override
  _SmallPlayerWidgetState createState() => _SmallPlayerWidgetState();
}

class _SmallPlayerWidgetState extends State<SmallPlayerWidget> {
  Duration position = new Duration();
  Duration musicLength = new Duration();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 10,
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 15),
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
                    child: StreamBuilder(
                        stream: PlayMusic.getCurrentStream(),
                        builder: (context, currentSnapshot) {
                          final Playing playing = currentSnapshot.data;
                          final Metas metas = playing?.audio?.audio?.metas;

                          final String currentMusicId =
                              playing?.audio?.audio?.metas?.id;
                          return StreamBuilder(
                              stream: PlayMusic.isPlayingFunc(),
                              builder: (context, playingSnapshot) {
                                final isPlaying = playingSnapshot.data;
                                return ListTile(
                                  leading: ClipOval(
                                    // borderRadius:
                                    //     BorderRadius.circular(4.0),
                                    child: playing == null
                                        ? CircularProgressIndicator()
                                        : ExtendedImage.network(
                                            metas?.image?.path ??
                                                'https://cdn.pixabay.com/photo/2018/03/04/09/51/space-3197611_1280.jpg',
                                            cache: true,
                                            width: 50,
                                            height: 50,
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          metas?.title ?? '',
                                          style: MTextStyles.bold12Grey06,
                                        ),
                                        SizedBox(
                                          width: 6,
                                        ),
                                        Text(
                                          metas?.artist ?? '',
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
                                          PlayMusic.previous();
                                        },
                                      ),
                                      IconButton(
                                          iconSize: 10,
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
                                        iconSize: 20,
                                        onPressed: () {
                                          PlayMusic.next();
                                        },
                                      ),
                                    ],
                                  ),
                                );
                              });
                        }),
                  ),
                  SizedBox(
                    height: 40,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 15, right: 15),
                      child: StreamBuilder(
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
                          }),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
