import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:music_minorleague/model/data/music_info_data.dart';
import 'package:music_minorleague/model/view/page/music_player/main_player_position_seek_widget.dart';
import 'package:music_minorleague/model/view/style/size_config.dart';
import 'package:music_minorleague/model/view/style/textstyles.dart';
import 'package:music_minorleague/utils/play_func.dart';

class MyMusicPlayerPage extends StatefulWidget {
  @override
  _MyMusicPlayerPageState createState() => _MyMusicPlayerPageState();
}

class _MyMusicPlayerPageState extends State<MyMusicPlayerPage> {
  List<MusicInfoData> selectedMusicList;

  Duration position = new Duration();
  Duration musicLength = new Duration();

  @override
  void initState() {
    super.initState();

    //TODO 1. 인터넷 연결 상태를 확인한다.(끊겨있으면 error 페이지 표시)
    //TODO sqlite 에 저장된 파일과 firebase 에 저장된 파일을 비교하여 파일 존재 여부를 확인하고 없으면 내 DB를 삭제한다.
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: _body(),
    );
  }

  _appBar() {
    return AppBar(
      title: Text(
        "Player",
        style: MTextStyles.bold16Black,
      ),
      centerTitle: true,
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back_ios,
          color: Colors.black,
        ),
        onPressed: () => Navigator.of(context).pop(),
      ),
      elevation: 0.0,
    );
  }

  _body() {
    return StreamBuilder<Object>(
        stream: PlayMusic.getCurrentStream(),
        builder: (context, snapshotCurrent) {
          final Playing playing = snapshotCurrent.data;

          final String currentMusicId = playing?.audio?.audio?.metas?.id;
          return StreamBuilder(
              stream: PlayMusic.isPlayingFunc(),
              initialData: false,
              builder: (context, snapshotPlaying) {
                final isPlaying = snapshotPlaying.data;
                return Container(
                  width: SizeConfig.screenWidth,
                  child: SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        SizedBox(
                          height: 20,
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 50),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Color(0x46000000),
                                offset: Offset(0, 20),
                                spreadRadius: 0,
                                blurRadius: 30,
                              ),
                              BoxShadow(
                                color: Color(0x11000000),
                                offset: Offset(0, 10),
                                spreadRadius: 0,
                                blurRadius: 30,
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Image(
                              image: ExtendedNetworkImageProvider(
                                playing?.audio?.audio?.metas?.image?.path ??
                                    'https://cdn.pixabay.com/photo/2018/03/04/09/51/space-3197611_1280.jpg',
                                cache: true,
                              ),
                              width: MediaQuery.of(context).size.width * 0.7,
                              height: MediaQuery.of(context).size.width * 0.7,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Text(
                          playing?.audio?.audio?.metas?.title ??
                              '' ??
                              'noTitle',
                          style: MTextStyles.bold20Black36,
                        ),
                        Text(playing?.audio?.audio?.metas?.artist ?? 'none'),
                        SizedBox(
                          height: 20,
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

                                final RealtimePlayingInfos infos =
                                    snapshot.data;
                                position = infos.currentPosition;
                                musicLength = infos.duration;
                                return MainPlayerPositionSeekWidget(
                                    position: position,
                                    infos: infos,
                                    musicLength: musicLength);
                              },
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 40,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            IconButton(
                              onPressed: () {
                                playing.playlist.audios.length > 1
                                    ? PlayMusic.previous()
                                    // widget._playNext()
                                    : null;
                              },
                              icon: Icon(Icons.skip_previous),
                            ),
                            IconButton(
                              iconSize: 50,
                              onPressed: () {
                                setState(() {
                                  PlayMusic.playOrPauseFunc();
                                });
                              },
                              icon: Icon(
                                isPlaying == true
                                    ? FontAwesomeIcons.pause
                                    : FontAwesomeIcons.play,
                                // color: MColors.tomato,
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                setState(() {
                                  playing.playlist.audios.length > 1
                                      ? PlayMusic.next()
                                      // widget._playNext()
                                      : null;
                                });
                              },
                              icon: Icon(Icons.skip_next),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              });
        });
    // }
  }
}
