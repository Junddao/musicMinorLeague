import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:music_minorleague/model/data/music_info_data.dart';
import 'package:music_minorleague/model/provider/now_play_music_provider.dart';
import 'package:music_minorleague/model/view/page/music_player/main_player_position_seek_widget.dart';
import 'package:music_minorleague/model/view/style/colors.dart';
import 'package:music_minorleague/model/view/style/size_config.dart';
import 'package:music_minorleague/model/view/style/textstyles.dart';
import 'package:music_minorleague/utils/play_func.dart';
import 'package:provider/provider.dart';

class MyMusicPlayerPage extends StatefulWidget {
  @override
  _MyMusicPlayerPageState createState() => _MyMusicPlayerPageState();
}

class _MyMusicPlayerPageState extends State<MyMusicPlayerPage> {
  List<MusicInfoData> selectedMusicList;
  bool _isPlay = false;
  Duration position = new Duration();
  Duration musicLength = new Duration();

  @override
  void initState() {
    super.initState();
    _isPlay = Provider.of<NowPlayMusicProvider>(context, listen: false).isPlay;
    selectedMusicList =
        Provider.of<NowPlayMusicProvider>(context, listen: false)
            .selectedMusicList;
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
    // if (Provider.of<NowPlayMusicProvider>(context, listen: false)
    //         .musicInfoData ==
    //     null) {
    //   return Center(
    //       child: Container(
    //     child: Text('empty!'),
    //   ));
    // } else {
    return Container(
      width: SizeConfig.screenWidth,
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            // SizedBox(
            //   height: 50,
            // ),
            // Container(
            //   alignment: Alignment.topLeft,
            //   margin: EdgeInsets.only(
            //     left: 10,
            //   ),
            //   child: IconButton(
            //     onPressed: () {},
            //     icon: Icon(FontAwesomeIcons.chevronDown),
            //   ),
            // ),
            SizedBox(
              height: 20,
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20, vertical: 50),
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
                  image: NetworkImage(Provider.of<NowPlayMusicProvider>(context,
                              listen: false)
                          .musicInfoData
                          ?.imagePath ??
                      'https://cdn.pixabay.com/photo/2018/03/04/09/51/space-3197611_1280.jpg'),
                  width: MediaQuery.of(context).size.width * 0.7,
                  height: MediaQuery.of(context).size.width * 0.7,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Text(
              Provider.of<NowPlayMusicProvider>(context, listen: false)
                      .musicInfoData
                      ?.title ??
                  'noTitle',
              style: MTextStyles.bold20Black36,
            ),
            Text(Provider.of<NowPlayMusicProvider>(context, listen: false)
                    .musicInfoData
                    ?.artist ??
                'none'),
            SizedBox(
              height: 20,
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

                    return StreamBuilder(
                        stream: PlayMusic.getSongLengthStream(),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return SizedBox.shrink();
                          }

                          final RealtimePlayingInfos infos = snapshot.data;
                          position = infos.currentPosition;
                          musicLength = infos.duration;
                          return MainPlayerPositionSeekWidget(
                              position: position,
                              infos: infos,
                              musicLength: musicLength);
                        });
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
                    playPrevious();
                  },
                  icon: Icon(Icons.skip_previous),
                ),
                IconButton(
                  iconSize: 50,
                  onPressed: () {
                    setState(() {
                      _isPlay = !_isPlay;
                      PlayMusic.playOrPauseFunc();
                    });
                  },
                  icon: Icon(
                    _isPlay == true
                        ? FontAwesomeIcons.pause
                        : FontAwesomeIcons.play,
                    // color: MColors.tomato,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    setState(() {
                      playNext();
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
    // }
  }

  void playPrevious() {
    int index = PlayMusic.assetsAudioPlayer().current.value.index;
    if (index > 0) index = index - 1;
    MusicInfoData musicInfoData = new MusicInfoData(
      id: selectedMusicList[index].id,
      title: selectedMusicList[index].title,
      artist: selectedMusicList[index].artist,
      musicPath: selectedMusicList[index].musicPath,
      imagePath: selectedMusicList[index].imagePath,
      dateTime: selectedMusicList[index].dateTime,
      favorite: selectedMusicList[index].favorite,
      musicType: selectedMusicList[index].musicType,
    );
    setNowPlayMusicInfo(musicInfoData);
    setState(() {
      PlayMusic.previous();
    });
  }

  void playNext() {
    int index = PlayMusic.assetsAudioPlayer().current.value.index;
    if (index < selectedMusicList.length) index = index + 1;
    MusicInfoData musicInfoData = new MusicInfoData(
      id: selectedMusicList[index].id,
      title: selectedMusicList[index].title,
      artist: selectedMusicList[index].artist,
      musicPath: selectedMusicList[index].musicPath,
      imagePath: selectedMusicList[index].imagePath,
      dateTime: selectedMusicList[index].dateTime,
      favorite: selectedMusicList[index].favorite,
      musicType: selectedMusicList[index].musicType,
    );
    setNowPlayMusicInfo(musicInfoData);
    setState(() {
      PlayMusic.next();
    });
  }

  void setNowPlayMusicInfo(MusicInfoData musicInfoData) {
    setState(() {
      Provider.of<NowPlayMusicProvider>(context, listen: false).musicInfoData =
          musicInfoData;
      Provider.of<NowPlayMusicProvider>(context, listen: false).isPlay = true;
      Provider.of<NowPlayMusicProvider>(context, listen: false).nowMusicId =
          musicInfoData.id;
    });
  }
}
